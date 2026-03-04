#!/usr/bin/env coffee

# 极简诗式 PPTX 生成器
# 让写 PPTX 像写诗一样简洁优美

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# 全局状态
演示 = null
页数 = 0

# 极简 API：一个函数搞定一切
诗 = (内容...) ->
  页数++
  
  # 根据参数数量和类型自动判断
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
          列表页 首行, 次行.split("\n")
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

章节页 = (编号, 标题, 副标题) ->
  slide = 演示.addSlide()
  slide.addText 编号,
    x: 0.5, y: 1.5, w: 9, h: 0.8
    fontSize: 20, color: "999999", align: "center"
  slide.addText 标题,
    x: 0.5, y: 2.2, w: 9, h: 1.2
    fontSize: 40, bold: true, color: "2B579A", align: "center"
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

# 导出
module.exports = { 创作, 诗, 完成 }
