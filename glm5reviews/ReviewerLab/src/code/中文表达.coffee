#!/usr/bin/env coffee

# 探索：中文世界的流程和结构表达
# 目标：显而易见、轻而易举

fs = require "fs"
PptxGenJS = require "pptxgenjs"

演示 = null
页数 = 0

# ============================================
# 核心洞察：中文表达的特点
# ============================================
#
# 1. 流程表达：起承转合、先...后...、从...到...
# 2. 结构表达：总-分、上-下、内-外
# 3. 关系表达：因果、递进、并列、转折
#
# 设计原则：
# - 用自然语言描述，而不是图形符号
# - 用语义化表达，而不是形式化语法
# - 用简洁描述，而不是详尽定义
#
# ============================================

# 基础函数
创作 = (标题) ->
  演示 = new PptxGenJS()
  演示.layout = "LAYOUT_16x9"
  演示.title = 标题
  页数 = 0
  console.log "📝 开始创作：#{标题}"

完成 = (文件名) ->
  演示.writeFile({ fileName: 文件名 })
    .then ->
      console.log "✅ 创作完成：#{文件名}"
      console.log "   共 #{页数} 页诗篇"

# ============================================
# 流程表达：用自然语言描述流程
# ============================================

流程 = (描述) ->
  页数++
  slide = 演示.addSlide()
  
  # 标题
  slide.addText 描述.标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  
  # 解析步骤
  步骤列表 = 描述.步骤 ? 描述.环节 ? 描述.阶段 ? []
  
  if 步骤列表.length > 0
    # 绘制流程图
    步骤数 = 步骤列表.length
    步骤宽度 = 8 / 步骤数
    起始x = 1
    
    for 步骤, 索引 in 步骤列表
      x = 起始x + 索引 * 步骤宽度
      
      # 步骤框
      slide.addShape "rect",
        x: x, y: 1.5, w: 步骤宽度 - 0.3, h: 0.8
        fill: { color: "2B579A" }
      
      # 步骤文字
      slide.addText 步骤,
        x: x, y: 1.6, w: 步骤宽度 - 0.3, h: 0.6
        fontSize: 14, color: "FFFFFF", align: "center", bold: true
      
      # 箭头（除了最后一个）
      if 索引 < 步骤数 - 1
        slide.addText "→",
          x: x + 步骤宽度 - 0.3, y: 1.6, w: 0.3, h: 0.6
          fontSize: 20, color: "2B579A", align: "center"
    
    # 如果是循环流程
    if 描述.循环 or 描述.闭环
      slide.addText "↑",
        x: 8.5, y: 2.5, w: 0.5, h: 0.5
        fontSize: 24, color: "2B579A", align: "center"
      slide.addText "←←←←←←←←←←←←←←←←←",
        x: 1, y: 2.8, w: 8, h: 0.3
        fontSize: 12, color: "999999", align: "center"
      slide.addText "↓",
        x: 0.8, y: 2.5, w: 0.5, h: 0.5
        fontSize: 24, color: "2B579A", align: "center"
    
    # 说明文字
    if 描述.说明
      slide.addText 描述.说明,
        x: 0.5, y: 3.5, w: 9, h: 1.5
        fontSize: 14, color: "666666"

# ============================================
# 结构表达：用自然语言描述层级
# ============================================

结构 = (描述) ->
  页数++
  slide = 演示.addSlide()
  
  # 标题
  slide.addText 描述.标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  
  # 解析层级
  层级列表 = 描述.层级 ? 描述.层次 ? 描述.级别 ? []
  
  if 层级列表.length > 0
    # 绘制层级结构
    for 层级, 索引 in 层级列表
      y = 1.2 + 索引 * 1
      
      # 层级框
      宽度 = 9 - 索引 * 1.5
      x偏移 = 索引 * 0.75
      
      slide.addShape "rect",
        x: 0.5 + x偏移, y: y, w: 宽度, h: 0.7
        fill: { color: "2B579A", transparency: 索引 * 20 }
      
      # 层级文字
      if typeof 层级 == "string"
        slide.addText 层级,
          x: 0.5 + x偏移, y: y + 0.1, w: 宽度, h: 0.5
          fontSize: 16, color: "FFFFFF", align: "center", bold: true
      else if typeof 层级 == "object"
        # 支持更复杂的层级描述
        slide.addText 层级.名称 ? 层级.name,
          x: 0.5 + x偏移, y: y + 0.1, w: 宽度, h: 0.5
          fontSize: 16, color: "FFFFFF", align: "center", bold: true

# ============================================
# 关系表达：用自然语言描述关系
# ============================================

关系 = (描述) ->
  页数++
  slide = 演示.addSlide()
  
  # 标题
  slide.addText 描述.标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  
  # 解析关系类型
  关系类型 = 描述.类型 ? "并列"
  
  switch 关系类型
    when "并列", "平行"
      # 并列关系：左右排列
      项目列表 = 描述.项目 ? 描述.要素 ? []
      项目数 = 项目列表.length
      项目宽度 = 8 / 项目数
      
      for 项目, 索引 in 项目列表
        x = 1 + 索引 * 项目宽度
        
        slide.addShape "rect",
          x: x, y: 1.5, w: 项目宽度 - 0.3, h: 1.5
          fill: { color: "2B579A" }
        
        if typeof 项目 == "string"
          slide.addText 项目,
            x: x, y: 2, w: 项目宽度 - 0.3, h: 0.5
            fontSize: 14, color: "FFFFFF", align: "center", bold: true
        else if typeof 项目 == "object"
          slide.addText 项目.名称 ? 项目.name,
            x: x, y: 1.6, w: 项目宽度 - 0.3, h: 0.5
            fontSize: 14, color: "FFFFFF", align: "center", bold: true
          if 项目.说明
            slide.addText 项目.说明,
              x: x, y: 2.2, w: 项目宽度 - 0.3, h: 0.6
              fontSize: 10, color: "FFFFFF", align: "center"
    
    when "因果", "递进"
      # 因果/递进关系：上下排列
      原因 = 描述.原因 ? 描述.起点 ? ""
      结果 = 描述.结果 ? 描述.终点 ? ""
      
      slide.addShape "rect",
        x: 2, y: 1.5, w: 6, h: 0.8
        fill: { color: "2B579A" }
      slide.addText 原因,
        x: 2, y: 1.6, w: 6, h: 0.6
        fontSize: 16, color: "FFFFFF", align: "center", bold: true
      
      slide.addText "↓",
        x: 4.5, y: 2.4, w: 1, h: 0.5
        fontSize: 24, color: "2B579A", align: "center"
      
      slide.addShape "rect",
        x: 2, y: 3, w: 6, h: 0.8
        fill: { color: "2B579A" }
      slide.addText 结果,
        x: 2, y: 3.1, w: 6, h: 0.6
        fontSize: 16, color: "FFFFFF", align: "center", bold: true
    
    when "对比", "比较"
      # 对比关系：左右对比
      左侧 = 描述.左侧 ? 描述.甲方 ? ""
      右侧 = 描述.右侧 ? 描述.乙方 ? ""
      
      slide.addShape "rect",
        x: 0.5, y: 1.5, w: 4, h: 2
        fill: { color: "2B579A" }
      slide.addText 左侧,
        x: 0.5, y: 2, w: 4, h: 1
        fontSize: 16, color: "FFFFFF", align: "center", bold: true
      
      slide.addText "VS",
        x: 4.5, y: 2, w: 1, h: 1
        fontSize: 20, color: "FF6B6B", align: "center", bold: true
      
      slide.addShape "rect",
        x: 5.5, y: 1.5, w: 4, h: 2
        fill: { color: "FF6B6B" }
      slide.addText 右侧,
        x: 5.5, y: 2, w: 4, h: 1
        fontSize: 16, color: "FFFFFF", align: "center", bold: true

# ============================================
# 万能表达：自动识别类型
# ============================================

图 = (描述) ->
  # 自动识别类型
  if 描述.步骤 or 描述.环节 or 描述.阶段
    流程 描述
  else if 描述.层级 or 描述.层次 or 描述.级别
    结构 描述
  else if 描述.类型 or 描述.项目 or 描述.要素
    关系 描述
  else
    # 默认：简单文本
    页数++
    slide = 演示.addSlide()
    slide.addText 描述.标题,
      x: 0.5, y: 2, w: 9, h: 1.5
      fontSize: 28, bold: true, color: "2B579A", align: "center"

# 导出
module.exports = { 创作, 流程, 结构, 关系, 图, 完成 }
