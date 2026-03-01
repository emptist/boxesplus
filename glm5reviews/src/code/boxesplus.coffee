#!/usr/bin/env coffee

# BoxesPlus - 医院管理课程PPTX生成工具集
# 统一API入口

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# ============================================
# 版本信息
# ============================================

版本 = "2.0.0"
console.log "📦 BoxesPlus v#{版本} - 医院管理课程PPTX生成工具"

# ============================================
# 第一层：基础API（直接封装PptxGenJS）
# ============================================

基础API =
  创建演示: ->
    pptx = new PptxGenJS()
    pptx.layout = "LAYOUT_16x9"
    pptx
  
  添加幻灯片: (pptx) ->
    pptx.addSlide()
  
  添加文本: (slide, 文本, 选项 = {}) ->
    默认选项 =
      x: 选项.x ? 0.5
      y: 选项.y ? 0.5
      w: 选项.w ? 9
      h: 选项.h ? 0.5
      fontSize: 选项.fontSize ? 16
      color: 选项.color ? "333333"
      bold: 选项.bold ? false
      align: 选项.align ? "left"
    slide.addText 文本, 默认选项
  
  添加形状: (slide, 类型, 选项 = {}) ->
    slide.addShape 类型, 选项
  
  保存文件: (pptx, 文件名) ->
    pptx.writeFile({ fileName: 文件名 })

# ============================================
# 第二层：中文API（语义化封装）
# ============================================

中文API =
  当前演示: null
  当前幻灯片: null
  
  开始: (标题) ->
    @当前演示 = 基础API.创建演示()
    @当前演示.title = 标题
    console.log "📝 开始创作：#{标题}"
    this
  
  封面页: (标题, 副标题 = "") ->
    slide = 基础API.添加幻灯片 @当前演示
    基础API.添加文本 slide, 标题,
      x: 0.5, y: 2, w: 9, h: 1.5
      fontSize: 44, bold: true, color: "2B579A", align: "center"
    if 副标题
      基础API.添加文本 slide, 副标题,
        x: 0.5, y: 3.5, w: 9, h: 0.8
        fontSize: 24, color: "666666", align: "center"
    this
  
  章节页: (编号, 标题, 副标题 = "") ->
    slide = 基础API.添加幻灯片 @当前演示
    if 编号
      基础API.添加文本 slide, 编号,
        x: 0.5, y: 1.5, w: 9, h: 0.8
        fontSize: 20, color: "999999", align: "center"
    基础API.添加文本 slide, 标题,
      x: 0.5, y: 2.2, w: 9, h: 1.2
      fontSize: 40, bold: true, color: "2B579A", align: "center"
    if 副标题
      基础API.添加文本 slide, 副标题,
        x: 0.5, y: 3.4, w: 9, h: 0.6
        fontSize: 18, color: "666666", align: "center"
    this
  
  列表页: (标题, 项目列表) ->
    slide = 基础API.添加幻灯片 @当前演示
    基础API.添加文本 slide, 标题,
      x: 0.5, y: 0.3, w: 9, h: 0.7
      fontSize: 28, bold: true, color: "2B579A"
    
    if Array.isArray 项目列表
      文本列表 = 项目列表.map (项, i) ->
        text: "#{i + 1}. #{项}\n"
        options: fontSize: 16, breakLine: true
      基础API.添加文本 slide, 文本列表,
        x: 0.5, y: 1.2, w: 9, h: 4
    this
  
  结束: (文件名) ->
    @当前演示.writeFile({ fileName: 文件名 })
      .then =>
        console.log "✅ 创作完成：#{文件名}"
        console.log "   共 #{@当前演示.slides.length} 页幻灯片"

# ============================================
# 第三层：诗式API（极简表达）
# ============================================

诗式API =
  当前演示: null
  页数: 0
  
  创作: (标题) ->
    @当前演示 = new PptxGenJS()
    @当前演示.layout = "LAYOUT_16x9"
    @当前演示.title = 标题
    @页数 = 0
    console.log "📝 开始创作：#{标题}"
    this
  
  诗: (内容) ->
    @页数++
    slide = @当前演示.addSlide()
    
    if Array.isArray 内容
      switch 内容.length
        when 1
          @渲染单行 slide, 内容[0]
        when 2
          @渲染双行 slide, 内容[0], 内容[1]
        when 3
          @渲染三行 slide, 内容[0], 内容[1], 内容[2]
    else if typeof 内容 == "object"
      @渲染对象 slide, 内容
    
    this
  
  渲染单行: (slide, 文本) ->
    if 文本.length > 30
      slide.addText 文本,
        x: 0.5, y: 2, w: 9, h: 1.5
        fontSize: 24, color: "333333", align: "center"
    else
      slide.addText 文本,
        x: 0.5, y: 2, w: 9, h: 1.5
        fontSize: 44, bold: true, color: "2B579A", align: "center"
  
  渲染双行: (slide, 首行, 次行) ->
    slide.addText 首行,
      x: 0.5, y: 2, w: 9, h: 1
      fontSize: 40, bold: true, color: "2B579A", align: "center"
    
    if typeof 次行 == "string"
      if 次行.includes "\n"
        项目列表 = 次行.split("\n").filter (行) -> 行.trim()
        文本列表 = 项目列表.map (项, i) ->
          text: "#{i + 1}. #{项}\n"
          options: fontSize: 16, breakLine: true
        slide.addText 文本列表,
          x: 0.5, y: 1.2, w: 9, h: 4
      else
        slide.addText 次行,
          x: 0.5, y: 3.2, w: 9, h: 0.8
          fontSize: 20, color: "666666", align: "center"
    else if Array.isArray 次行
      文本列表 = 次行.map (项, i) ->
        text: "#{i + 1}. #{项}\n"
        options: fontSize: 16, breakLine: true
      slide.addText 文本列表,
        x: 0.5, y: 1.2, w: 9, h: 4
  
  渲染三行: (slide, 首行, 次行, 三行) ->
    slide.addText 首行,
      x: 0.5, y: 1.5, w: 9, h: 0.8
      fontSize: 20, color: "999999", align: "center"
    slide.addText 次行,
      x: 0.5, y: 2.2, w: 9, h: 1.2
      fontSize: 40, bold: true, color: "2B579A", align: "center"
    slide.addText 三行,
      x: 0.5, y: 3.4, w: 9, h: 0.6
      fontSize: 18, color: "666666", align: "center"
  
  渲染对象: (slide, 对象) ->
    switch 对象.类型
      when "卡片"
        @渲染卡片 slide, 对象
      when "时间线"
        @渲染时间线 slide, 对象
      when "表格"
        @渲染表格 slide, 对象
  
  完成: (文件名) ->
    @当前演示.writeFile({ fileName: 文件名 })
      .then =>
        console.log "✅ 创作完成：#{文件名}"
        console.log "   共 #{@页数} 页诗篇"

# ============================================
# 第四层：双侧编程API（架构化）
# ============================================

class 幻灯片基类
  constructor: (@选项 = {}) ->
    {@标题, @类型, @内容, @颜色} = @选项
    @颜色 ?= "2B579A"
  
  渲染: (演示) ->
    switch @类型
      when "封面" then @渲染封面 演示
      when "章节" then @渲染章节 演示
      when "列表" then @渲染列表 演示
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
      文本列表 = @内容.map (项, i) =>
        text: "#{i + 1}. #{项}\n"
        options: fontSize: 16, breakLine: true
      slide.addText 文本列表,
        x: 0.5, y: 1.2, w: 9, h: 4
  
  渲染默认: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 2, w: 9, h: 1.5
      fontSize: 28, bold: true, color: @颜色, align: "center"

class 课程幻灯片 extends 幻灯片基类
  @封面: (标题, 副标题) ->
    new @ 类型: "封面", 标题: 标题, 内容: 副标题
  
  @章节: (编号, 标题, 副标题) ->
    new @ 类型: "章节", 编号: 编号, 标题: 标题, 内容: 副标题
  
  @列表: (标题, 内容列表) ->
    new @ 类型: "列表", 标题: 标题, 内容: 内容列表

双侧编程API =
  当前演示: null
  幻灯片列表: []
  
  开始: (标题) ->
    @当前演示 = new PptxGenJS()
    @当前演示.layout = "LAYOUT_16x9"
    @当前演示.title = 标题
    @幻灯片列表 = []
    console.log "📝 开始创作：#{标题}"
    this
  
  添加: (幻灯片) ->
    @幻灯片列表.push 幻灯片
    this
  
  完成: (文件名) ->
    @幻灯片列表.forEach (幻灯) => 幻灯.渲染 @当前演示
    @当前演示.writeFile({ fileName: 文件名 })
      .then =>
        console.log "✅ 创作完成：#{文件名}"
        console.log "   共 #{@幻灯片列表.length} 页幻灯片"

# ============================================
# 导出统一API
# ============================================

module.exports =
  版本: 版本
  
  基础: 基础API
  中文: 中文API
  诗式: 诗式API
  双侧: 双侧编程API
  
  幻灯片: 幻灯片基类
  课程幻灯片: 课程幻灯片
  
  便捷方法:
    开始: (标题) -> 中文API.开始 标题
    创作: (标题) -> 诗式API.创作 标题
    课程: (标题) -> 双侧编程API.开始 标题
