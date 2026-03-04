#!/usr/bin/env coffee

# 核心洞察：一切皆JSON定义
# 文字表达 → JSON定义 → 解析渲染

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# ============================================
# 第一步：自然语言 → JSON定义
# ============================================

解析文本 = (文本) ->
  行列表 = 文本.split("\n").filter (行) -> 行.trim()
  
  # 根据缩进判断层级
  结果 = []
  当前层级 = 0
  层级栈 = [结果]
  
  for 行 in 行列表
    缩进 = 行.match(/^(\s*)/)[1].length
    内容 = 行.trim()
    
    if 缩进 > 当前层级
      # 进入子层级
      新层级 = []
      层级栈[层级栈.length - 1].push 新层级
      层级栈.push 新层级
      当前层级 = 缩进
    else if 缩进 < 当前层级
      # 返回上层
      while 当前层级 > 缩进 and 层级栈.length > 1
        层级栈.pop()
        当前层级 -= 2
    
    if 内容
      层级栈[层级栈.length - 1].push 内容
  
  结果

# ============================================
# 第二步：JSON定义 → 页面类型识别
# ============================================

识别类型 = (定义) ->
  if Array.isArray 定义
    switch 定义.length
      when 0 then "空"
      when 1 then "标题"
      when 2 then "封面"
      when 3
        if Array.isArray 定义[1] and Array.isArray 定义[2]
          "表格"
        else
          "章节"
      else
        if 定义.every (项) -> typeof 项 == "string"
          "列表"
        else
          "复杂结构"
  else if typeof 定义 == "object"
    if 定义.步骤 or 定义.环节 or 定义.阶段
      "流程"
    else if 定义.层级 or 定义.层次 or 定义.级别
      "结构"
    else if 定义.类型 or 定义.项目 or 定义.要素
      "关系"
    else
      "对象"
  else
    "文本"

# ============================================
# 第三步：JSON定义 → 渲染指令
# ============================================

生成渲染指令 = (定义) ->
  类型 = 识别类型 定义
  
  switch 类型
    when "标题"
      类型: "标题页"
      标题: 定义[0]
    
    when "封面"
      类型: "封面页"
      标题: 定义[0]
      副标题: 定义[1]
    
    when "章节"
      类型: "章节页"
      编号: 定义[0]
      标题: 定义[1]
      副标题: 定义[2]
    
    when "列表"
      类型: "列表页"
      标题: 定义[0]
      项目: 定义[1..]
    
    when "表格"
      类型: "表格页"
      标题: 定义[0]
      表头: 定义[1]
      行数据: 定义[2]
    
    when "流程"
      类型: "流程页"
      标题: 定义.标题
      步骤: 定义.步骤 ? 定义.环节 ? 定义.阶段
      循环: 定义.循环 ? 定义.闭环
    
    when "结构"
      类型: "结构页"
      标题: 定义.标题
      层级: 定义.层级 ? 定义.层次 ? 定义.级别
    
    when "关系"
      类型: "关系页"
      标题: 定义.标题
      关系类型: 定义.类型
      数据: 定义
    
    else
      类型: "默认页"
      内容: 定义

# ============================================
# 第四步：渲染指令 → PPTX页面
# ============================================

渲染页面 = (pptx, 指令) ->
  slide = pptx.addSlide()
  
  switch 指令.类型
    when "标题页"
      slide.addText 指令.标题,
        x: 0.5, y: 2, w: 9, h: 1.5
        fontSize: 44, bold: true, color: "2B579A", align: "center"
    
    when "封面页"
      slide.addText 指令.标题,
        x: 0.5, y: 2, w: 9, h: 1.5
        fontSize: 44, bold: true, color: "2B579A", align: "center"
      if 指令.副标题
        slide.addText 指令.副标题,
          x: 0.5, y: 3.5, w: 9, h: 0.8
          fontSize: 24, color: "666666", align: "center"
    
    when "章节页"
      if 指令.编号
        slide.addText 指令.编号,
          x: 0.5, y: 1.5, w: 9, h: 0.8
          fontSize: 20, color: "999999", align: "center"
      slide.addText 指令.标题,
        x: 0.5, y: 2.2, w: 9, h: 1.2
        fontSize: 40, bold: true, color: "2B579A", align: "center"
      if 指令.副标题
        slide.addText 指令.副标题,
          x: 0.5, y: 3.4, w: 9, h: 0.6
          fontSize: 18, color: "666666", align: "center"
    
    when "列表页"
      slide.addText 指令.标题,
        x: 0.5, y: 0.3, w: 9, h: 0.7
        fontSize: 28, bold: true, color: "2B579A"
      文本列表 = 指令.项目.map (项, i) ->
        text: "#{i + 1}. #{项}\n"
        options: fontSize: 16, breakLine: true
      slide.addText 文本列表,
        x: 0.5, y: 1.2, w: 9, h: 4
    
    when "流程页"
      slide.addText 指令.标题,
        x: 0.5, y: 0.3, w: 9, h: 0.7
        fontSize: 28, bold: true, color: "2B579A"
      
      步骤数 = 指令.步骤.length
      步骤宽度 = 8 / 步骤数
      
      for 步骤, 索引 in 指令.步骤
        x = 1 + 索引 * 步骤宽度
        slide.addShape "rect",
          x: x, y: 1.5, w: 步骤宽度 - 0.3, h: 0.8
          fill: { color: "2B579A" }
        slide.addText 步骤,
          x: x, y: 1.6, w: 步骤宽度 - 0.3, h: 0.6
          fontSize: 14, color: "FFFFFF", align: "center", bold: true
        if 索引 < 步骤数 - 1
          slide.addText "→",
            x: x + 步骤宽度 - 0.3, y: 1.6, w: 0.3, h: 0.6
            fontSize: 20, color: "2B579A", align: "center"
    
    when "结构页"
      slide.addText 指令.标题,
        x: 0.5, y: 0.3, w: 9, h: 0.7
        fontSize: 28, bold: true, color: "2B579A"
      
      for 层级, 索引 in 指令.层级
        y = 1.2 + 索引 * 1
        宽度 = 9 - 索引 * 1.5
        x偏移 = 索引 * 0.75
        slide.addShape "rect",
          x: 0.5 + x偏移, y: y, w: 宽度, h: 0.7
          fill: { color: "2B579A", transparency: 索引 * 20 }
        slide.addText 层级,
          x: 0.5 + x偏移, y: y + 0.1, w: 宽度, h: 0.5
          fontSize: 16, color: "FFFFFF", align: "center", bold: true

# ============================================
# 完整流程：文本 → PPTX
# ============================================

文本转PPTX = (文本, 文件名) ->
  # 第一步：解析文本
  定义列表 = 解析文本 文本
  console.log "📄 解析文本完成，共 #{定义列表.length} 个定义"
  
  # 第二步：生成渲染指令
  指令列表 = 定义列表.map 生成渲染指令
  console.log "🎨 生成渲染指令完成"
  
  # 第三步：创建PPTX
  pptx = new PptxGenJS()
  pptx.layout = "LAYOUT_16x9"
  
  # 第四步：渲染页面
  指令列表.forEach (指令) -> 渲染页面 pptx, 指令
  console.log "✨ 渲染页面完成"
  
  # 第五步：保存文件
  pptx.writeFile({ fileName: 文件名 })
    .then ->
      console.log "✅ 创作完成：#{文件名}"
      console.log "   共 #{指令列表.length} 页幻灯片"

# ============================================
# 导出
# ============================================

module.exports = {
  解析文本
  识别类型
  生成渲染指令
  渲染页面
  文本转PPTX
}
