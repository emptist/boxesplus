#!/usr/bin/env coffee

# 真正的诗式 PPTX 生成器
# 让写 PPTX 像写诗一样优美，不需要逗号！

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# 全局状态
演示 = null
页数 = 0

# 极简 API：一个函数搞定一切
诗 = (内容) ->
  页数++
  
  # 如果是数组，根据长度判断类型
  if Array.isArray(内容)
    switch 内容.length
      when 1
        # 单行诗 = 标题页或引用
        if typeof 内容[0] == "string"
          if 内容[0].length > 30
            引用页 内容[0]
          else
            标题页 内容[0]
      
      when 2
        # 两行诗 = 标题+副标题 或 标题+列表
        [首行, 次行] = 内容
        if typeof 次行 == "string"
          if 次行.includes("\n")
            列表页 首行, 次行.split("\n").filter (行) -> 行.trim()
          else
            标题页 首行, 次行
        else if Array.isArray(次行)
          列表页 首行, 次行
      
      when 3
        # 三行诗 = 章节页 或 表格
        [首行, 次行, 三行] = 内容
        if typeof 三行 == "string"
          章节页 首行, 次行, 三行
        else if Array.isArray(次行) and Array.isArray(三行)
          表格页 首行, 次行, 三行
      
      when 4
        # 四行诗 = 带颜色的章节页
        [首行, 次行, 三行, 四行] = 内容
        if typeof 四行 == "string"
          章节页 首行, 次行, 三行, 四行
  
  # 如果是对象，直接解析
  else if typeof 内容 == "object"
    解析对象 内容

# 开始创作
创作 = (标题) ->
  演示 = new PptxGenJS()
  演示.layout = "LAYOUT_16x9"
  演示.title = 标题
  页数 = 0
  console.log "📝 开始创作：#{标题}"

# 完成
完成 = (文件名) ->
  演示.writeFile({ fileName: 文件名 })
    .then ->
      console.log "✅ 创作完成：#{文件名}"
      console.log "   共 #{页数} 页诗篇"

# 内部函数
标题页 = (标题, 副标题) ->
  slide = 演示.addSlide()
  slide.addText 标题,
    x: 0.5, y: 2, w: 9, h: 1.5
    fontSize: 44, bold: true, color: "2B579A", align: "center"
  if 副标题
    slide.addText 副标题,
      x: 0.5, y: 3.5, w: 9, h: 0.8
      fontSize: 24, color: "666666", align: "center"

章节页 = (编号, 标题, 副标题, 颜色) ->
  slide = 演示.addSlide()
  slide.addText 编号,
    x: 0.5, y: 1.5, w: 9, h: 0.8
    fontSize: 20, color: "999999", align: "center"
  slide.addText 标题,
    x: 0.5, y: 2.2, w: 9, h: 1.2
    fontSize: 40, bold: true, color: "2B579A", align: "center"
  if 副标题
    slide.addText 副标题,
      x: 0.5, y: 3.4, w: 9, h: 0.6
      fontSize: 18, color: "666666", align: "center"

列表页 = (标题, 项目) ->
  slide = 演示.addSlide()
  slide.addText 标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  text = 项目.map (项, i) ->
    { text: "#{i + 1}. #{项}\n", options: { fontSize: 16, breakLine: true } }
  slide.addText text,
    x: 0.5, y: 1.2, w: 9, h: 4

表格页 = (标题, 表头, 行) ->
  slide = 演示.addSlide()
  slide.addText 标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  slide.addTable [表头, 行...],
    x: 0.5, y: 1.2, w: 9, h: 4
    fontSize: 12
    border: { type: "solid", pt: 1, color: "CCCCCC" }

引用页 = (文字) ->
  slide = 演示.addSlide()
  slide.addText "\"#{文字}\"",
    x: 1, y: 2, w: 8, h: 2
    fontSize: 24, italic: true, color: "666666", align: "center"

解析对象 = (对象) ->
  # 预留对象解析功能
  if 对象.类型
    switch 对象.类型
      when "卡片" then 卡片页 对象.标题, 对象.卡片
      when "对比" then 对比页 对象.标题, 对象.左侧, 对象.右侧
      when "时间线" then 时间线页 对象.标题, 对象.事件

卡片页 = (标题, 卡片列表) ->
  slide = 演示.addSlide()
  slide.addText 标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  列数 = Math.min(卡片列表.length, 4)
  卡片宽度 = 9 / 列数 - 0.2
  for 卡片, 索引 in 卡片列表
    列 = 索引 % 列数
    行 = Math.floor(索引 / 列数)
    x = 0.5 + 列 * (卡片宽度 + 0.2)
    y = 1.2 + 行 * 2
    slide.addText 卡片.标题,
      x: x, y: y, w: 卡片宽度, h: 0.5
      fontSize: 14, bold: true, color: "2B579A"
    slide.addText 卡片.内容,
      x: x, y: y + 0.6, w: 卡片宽度, h: 1.2
      fontSize: 11, color: "666666"

对比页 = (标题, 左侧, 右侧) ->
  slide = 演示.addSlide()
  slide.addText 标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  slide.addText 左侧.标题,
    x: 0.5, y: 1.2, w: 4.2, h: 0.5
    fontSize: 18, bold: true, color: "2B579A"
  左侧文本 = 左侧.项目.map (项目) ->
    { text: "• #{项目}\n", options: { fontSize: 14, breakLine: true } }
  slide.addText 左侧文本,
    x: 0.5, y: 1.8, w: 4.2, h: 3.5
  slide.addText 右侧.标题,
    x: 5.3, y: 1.2, w: 4.2, h: 0.5
    fontSize: 18, bold: true, color: "2B579A"
  右侧文本 = 右侧.项目.map (项目) ->
    { text: "• #{项目}\n", options: { fontSize: 14, breakLine: true } }
  slide.addText 右侧文本,
    x: 5.3, y: 1.8, w: 4.2, h: 3.5

时间线页 = (标题, 事件列表) ->
  slide = 演示.addSlide()
  slide.addText 标题,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, bold: true, color: "2B579A"
  事件数 = 事件列表.length
  事件宽度 = 9 / 事件数
  for 事件, 索引 in 事件列表
    x = 0.5 + 索引 * 事件宽度
    slide.addText 事件.date,
      x: x, y: 1.5, w: 事件宽度, h: 0.4
      fontSize: 12, color: "2B579A", align: "center"
    slide.addText 事件.title,
      x: x, y: 2, w: 事件宽度, h: 0.4
      fontSize: 14, bold: true, align: "center"
    slide.addText 事件.desc,
      x: x, y: 2.5, w: 事件宽度, h: 1
      fontSize: 10, color: "666666", align: "center"

# 导出
module.exports = { 创作, 诗, 完成 }
