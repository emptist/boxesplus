#!/usr/bin/env coffee

# CoffeeScript 双侧编程探索
# 类一侧：定义规则、模板、默认值
# 实例一侧：填充具体内容

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# ============================================
# 核心设计：幻灯片类
# ============================================

class 幻灯片
  # 类一侧：模板和默认值
  @模板库: {}
  @默认:
    颜色: "2B579A"
    字体: 16
    布局: "LAYOUT_16x9"
  
  # 类方法：注册模板
  @注册模板: (名称, 模板) ->
    @模板库[名称] = 模板
  
  # 类方法：批量创建
  @批量创建: (列表) ->
    列表.map (项) => new @(项)
  
  # 实例一侧：具体内容
  constructor: (@选项 = {}) ->
    {@标题, @类型, @内容, @颜色} = @选项
    @颜色 ?= 幻灯片.默认.颜色
  
  # 实例方法：渲染到 PPTX
  渲染: (演示) ->
    switch @类型
      when "封面" then @渲染封面 演示
      when "章节" then @渲染章节 演示
      when "列表" then @渲染列表 演示
      when "表格" then @渲染表格 演示
      when "流程" then @渲染流程 演示
      when "结构" then @渲染结构 演示
      else @渲染默认 演示
  
  渲染封面: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 2, w: 9, h: 1.5
      fontSize: 44, bold: true, color: @颜色, align: "center"
    if @内容
      slide.addText @内容,
        x: 0.5, y: 3.5, w: 9, h: 0.8
        fontSize: 24, color: "666666", align: "center"
  
  渲染章节: (演示) ->
    slide = 演示.addSlide()
    if @选项.编号
      slide.addText @选项.编号,
        x: 0.5, y: 1.5, w: 9, h: 0.8
        fontSize: 20, color: "999999", align: "center"
    slide.addText @标题,
      x: 0.5, y: 2.2, w: 9, h: 1.2
      fontSize: 40, bold: true, color: @颜色, align: "center"
    if @内容
      slide.addText @内容,
        x: 0.5, y: 3.4, w: 9, h: 0.6
        fontSize: 18, color: "666666", align: "center"
  
  渲染列表: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 0.3, w: 9, h: 0.7
      fontSize: 28, bold: true, color: @颜色
    if Array.isArray @内容
      text = @内容.map (项, i) =>
        { text: "#{i + 1}. #{项}\n", options: { fontSize: 16, breakLine: true } }
      slide.addText text,
        x: 0.5, y: 1.2, w: 9, h: 4
  
  渲染表格: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 0.3, w: 9, h: 0.7
      fontSize: 28, bold: true, color: @颜色
    if @选项.表头 and @选项.行数据
      slide.addTable [@选项.表头, ...@选项.行数据],
        x: 0.5, y: 1.2, w: 9, h: 4
        fontSize: 12
        border: { type: "solid", pt: 1, color: "CCCCCC" }
  
  渲染流程: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 0.3, w: 9, h: 0.7
      fontSize: 28, bold: true, color: @颜色
    if Array.isArray @内容
      步骤数 = @内容.length
      步骤宽度 = 8 / 步骤数
      for 步骤, 索引 in @内容
        x = 1 + 索引 * 步骤宽度
        slide.addShape "rect",
          x: x, y: 1.5, w: 步骤宽度 - 0.3, h: 0.8
          fill: { color: @颜色 }
        slide.addText 步骤,
          x: x, y: 1.6, w: 步骤宽度 - 0.3, h: 0.6
          fontSize: 14, color: "FFFFFF", align: "center", bold: true
        if 索引 < 步骤数 - 1
          slide.addText "→",
            x: x + 步骤宽度 - 0.3, y: 1.6, w: 0.3, h: 0.6
            fontSize: 20, color: @颜色, align: "center"
  
  渲染结构: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 0.3, w: 9, h: 0.7
      fontSize: 28, bold: true, color: @颜色
    if Array.isArray @内容
      for 层级, 索引 in @内容
        y = 1.2 + 索引 * 1
        宽度 = 9 - 索引 * 1.5
        x偏移 = 索引 * 0.75
        slide.addShape "rect",
          x: 0.5 + x偏移, y: y, w: 宽度, h: 0.7
          fill: { color: @颜色, transparency: 索引 * 20 }
        slide.addText 层级,
          x: 0.5 + x偏移, y: y + 0.1, w: 宽度, h: 0.5
          fontSize: 16, color: "FFFFFF", align: "center", bold: true
  
  渲染默认: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 2, w: 9, h: 1.5
      fontSize: 28, bold: true, color: @颜色, align: "center"

# ============================================
# 演示文稿类
# ============================================

class 演示文稿
  # 类一侧
  @当前: null
  
  # 类方法：开始创作
  @开始: (标题) ->
    @当前 = new @(标题)
    console.log "📝 开始创作：#{标题}"
    @当前
  
  # 实例一侧
  constructor: (@标题) ->
    @pptx = new PptxGenJS()
    @pptx.layout = "LAYOUT_16x9"
    @pptx.title = @标题
    @幻灯片列表 = []
  
  # 添加幻灯片
  添加: (选项) ->
    幻灯 = new 幻灯片(选项)
    @幻灯片列表.push 幻灯
    this  # 支持链式调用
  
  # 批量添加
  批量添加: (列表) ->
    列表.forEach (项) => @添加 项
    this
  
  # 保存
  保存: (文件名) ->
    @幻灯片列表.forEach (幻灯) => 幻灯.渲染 @pptx
    @pptx.writeFile({ fileName: 文件名 })
      .then =>
        console.log "✅ 创作完成：#{文件名}"
        console.log "   共 #{@幻灯片列表.length} 页幻灯片"

# ============================================
# 注册常用模板
# ============================================

幻灯片.注册模板 "课程封面",
  类型: "封面"
  颜色: "2B579A"

幻灯片.注册模板 "课程章节",
  类型: "章节"
  颜色: "2B579A"

幻灯片.注册模板 "课程列表",
  类型: "列表"
  颜色: "2B579A"

# ============================================
# 导出
# ============================================

module.exports = {
  幻灯片
  演示文稿
  开始: (标题) -> 演示文稿.开始 标题
}
