# BoxesPlus - Declarative Presentation Framework
# 用户只要运行 coffee self.coffee，所有一切都会完成

fs = require "fs"
pptxgen = require "pptxgenjs"

# ============================================
# Slide - 幻灯片基类（声明式）
# ============================================

class Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        y = 1.2
        
        for key, value of properties
            @renderPropertyToPptx(slide, key, value, y)
            y += 1.0
    
    @getProperties: ->
        props = {}
        for key, value of this
            unless key in ['name', 'length', 'prototype', 'toPptx', 'getProperties', 'renderPropertyToPptx']
                props[key] = value
        props
    
    @renderPropertyToPptx: (slide, key, value, y) ->
        if typeof value is 'string'
            if value.match(/\.(png|jpg|jpeg|gif|svg)$/i)
                slide.addText key,
                    x: 0.5, y: y, w: 9, h: 0.3
                    fontSize: 16, bold: true
                slide.addImage
                    x: 0.5, y: y + 0.4, w: 4, h: 3
                    path: value
            else
                slide.addText key,
                    x: 0.5, y: y, w: 9, h: 0.3
                    fontSize: 16, bold: true
                slide.addText value,
                    x: 0.5, y: y + 0.4, w: 9, h: 0.5
                    fontSize: 14
        
        else if typeof value is 'object' and not Array.isArray(value)
            if value['图'] and value['文']
                slide.addText key,
                    x: 0.5, y: y, w: 9, h: 0.3
                    fontSize: 16, bold: true
                slide.addImage
                    x: 0.5, y: y + 0.4, w: 4, h: 3
                    path: value['图']
                slide.addText value['文'],
                    x: 5, y: y + 0.4, w: 4.5, h: 3
                    fontSize: 14

# ============================================
# TitleSlide - 标题页
# ============================================

class TitleSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 2.5, w: 9, h: 1
            fontSize: 44, bold: true, color: "366092", align: "center"
        
        if @副标题
            slide.addText @副标题,
                x: 0.5, y: 3.5, w: 9, h: 0.5
                fontSize: 24, color: "666666", align: "center"

# ============================================
# ContentSlide - 内容页
# ============================================

class ContentSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        y = 1.2
        
        for key, value of properties
            slide.addText "• #{value}",
                x: 0.5, y: y, w: 9, h: 0.4
                fontSize: 18, color: "333333"
            y += 0.5

# ============================================
# TwoColumnSlide - 两栏页
# ============================================

class TwoColumnSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        keys = Object.keys(properties)
        half = Math.ceil(keys.length / 2)
        
        y = 1.2
        for key, i in keys[0...half]
            value = properties[key]
            slide.addText "#{key}: #{value}",
                x: 0.5, y: y, w: 4.5, h: 0.4
                fontSize: 14
            y += 0.5
        
        y = 1.2
        for key, i in keys[half..]
            value = properties[key]
            slide.addText "#{key}: #{value}",
                x: 5, y: y, w: 4.5, h: 0.4
                fontSize: 14
            y += 0.5

# ============================================
# TableSlide - 表格页
# ============================================

class TableSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        rows = [["项目", "内容"]]
        
        for key, value of properties
            rows.push([key, value])
        
        slide.addTable rows,
            x: 0.5, y: 1.2, w: 9, h: 4
            fontSize: 14
            border: { pt: 1, color: "CCCCCC" }
            fill: { color: "F5F5F5" }

# ============================================
# CardSlide - 卡片页
# ============================================

class CardSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        cards = Object.keys(properties)
        cardWidth = 8.5 / cards.length
        
        for key, i in cards
            value = properties[key]
            x = 0.75 + i * cardWidth
            
            slide.addShape "rect",
                x: x, y: 1.2, w: cardWidth - 0.2, h: 1.8
                fill: { color: "F0F0F0" }
            
            slide.addText key,
                x: x + 0.1, y: 1.3, w: cardWidth - 0.4, h: 0.4
                fontSize: 16, bold: true, color: "366092"
            
            slide.addText value,
                x: x + 0.1, y: 1.8, w: cardWidth - 0.4, h: 1.2
                fontSize: 12, color: "333333"

# ============================================
# ImageSlide - 图片页
# ============================================

class ImageSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        y = 1.2
        
        for key, value of properties
            if typeof value is 'string' and value.match(/\.(png|jpg|jpeg|gif|svg)$/i)
                slide.addImage
                    x: 0.5, y: y, w: 9, h: 4
                    path: value
            else
                slide.addText "#{key}: #{value}",
                    x: 0.5, y: y, w: 9, h: 0.4
                    fontSize: 14
                y += 0.5

# ============================================
# ImageTextSlide - 图文混排页
# ============================================

class ImageTextSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        y = 1.2
        
        for key, value of properties
            if typeof value is 'object' and value['图'] and value['文']
                slide.addImage
                    x: 0.5, y: y, w: 4, h: 3
                    path: value['图']
                slide.addText value['文'],
                    x: 5, y: y, w: 4.5, h: 3
                    fontSize: 14
                y += 3.5
            else
                slide.addText "#{key}: #{value}",
                    x: 0.5, y: y, w: 9, h: 0.4
                    fontSize: 14
                y += 0.5

# ============================================
# TimelineSlide - 时间线页
# ============================================

class TimelineSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        items = Object.keys(properties)
        itemWidth = 8.5 / items.length
        
        slide.addShape "line",
            x: 0.5, y: 2.5, w: 9, h: 0
            line: { color: "366092", width: 2 }
        
        for key, i in items
            value = properties[key]
            x = 0.75 + i * itemWidth
            
            slide.addShape "circle",
                x: x + itemWidth/2 - 0.1, y: 2.4, w: 0.2, h: 0.2
                fill: { color: "366092" }
            
            slide.addText key,
                x: x, y: 1.8, w: itemWidth, h: 0.4
                fontSize: 14, bold: true, align: "center"
            
            slide.addText value,
                x: x, y: 2.8, w: itemWidth, h: 1.5
                fontSize: 12, align: "center"

# ============================================
# QuoteSlide - 引用页
# ============================================

class QuoteSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        y = 1.5
        
        for key, value of properties
            slide.addShape "rect",
                x: 0.5, y: y, w: 9, h: 1.5
                fill: { color: "F5F5F5" }
            
            slide.addText "\"#{value}\"",
                x: 1, y: y + 0.3, w: 8, h: 0.8
                fontSize: 18, italic: true, color: "666666"
            
            slide.addText "— #{key}",
                x: 1, y: y + 1.1, w: 8, h: 0.3
                fontSize: 14, align: "right", color: "999999"
            
            y += 2

# ============================================
# NumberSlide - 数字页
# ============================================

class NumberSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        items = Object.keys(properties)
        itemWidth = 8.5 / items.length
        
        for key, i in items
            value = properties[key]
            x = 0.75 + i * itemWidth
            
            slide.addText value,
                x: x, y: 1.5, w: itemWidth, h: 1
                fontSize: 48, bold: true, color: "366092", align: "center"
            
            slide.addText key,
                x: x, y: 2.6, w: itemWidth, h: 0.5
                fontSize: 16, color: "666666", align: "center"

# ============================================
# ProcessSlide - 流程图页
# ============================================

class ProcessSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        steps = Object.keys(properties)
        stepWidth = 8.5 / steps.length
        
        for key, i in steps
            value = properties[key]
            x = 0.75 + i * stepWidth
            
            # 步骤框
            slide.addShape "rect",
                x: x, y: 1.5, w: stepWidth - 0.3, h: 1.2
                fill: { color: "E8F4FD" }
                line: { color: "366092", width: 1 }
            
            # 步骤编号
            slide.addShape "circle",
                x: x + stepWidth/2 - 0.2, y: 1.3, w: 0.4, h: 0.4
                fill: { color: "366092" }
            
            slide.addText "#{i + 1}",
                x: x + stepWidth/2 - 0.2, y: 1.35, w: 0.4, h: 0.3
                fontSize: 14, bold: true, color: "FFFFFF", align: "center"
            
            # 步骤标题
            slide.addText key,
                x: x + 0.1, y: 1.8, w: stepWidth - 0.5, h: 0.4
                fontSize: 14, bold: true, align: "center"
            
            # 步骤内容
            slide.addText value,
                x: x + 0.1, y: 2.2, w: stepWidth - 0.5, h: 0.4
                fontSize: 12, align: "center"
            
            # 箭头（除了最后一个）
            if i < steps.length - 1
                slide.addText "→",
                    x: x + stepWidth - 0.3, y: 1.9, w: 0.3, h: 0.4
                    fontSize: 24, color: "366092"

# ============================================
# GanttSlide - 甘特图页
# ============================================

class GanttSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        tasks = Object.keys(properties)
        taskHeight = 0.6
        startY = 1.2
        
        # 时间轴（假设12个月）
        months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
        monthWidth = 7 / 12
        
        # 绘制月份标题
        for month, i in months
            slide.addText month,
                x: 2 + i * monthWidth, y: 1, w: monthWidth, h: 0.3
                fontSize: 10, align: "center"
        
        # 绘制任务条
        for task, i in tasks
            value = properties[task]
            y = startY + i * taskHeight
            
            # 任务名称
            slide.addText task,
                x: 0.5, y: y, w: 1.5, h: taskHeight
                fontSize: 12, align: "right"
            
            # 任务条（假设格式为 "开始月-结束月"）
            if typeof value is 'string' and value.match(/^\d+-\d+$/)
                [start, end] = value.split("-").map(Number)
                barWidth = (end - start + 1) * monthWidth
                barX = 2 + (start - 1) * monthWidth
                
                slide.addShape "rect",
                    x: barX, y: y + 0.1, w: barWidth, h: taskHeight - 0.2
                    fill: { color: "4472C4" }
                
                slide.addText value,
                    x: barX, y: y + 0.15, w: barWidth, h: taskHeight - 0.3
                    fontSize: 10, color: "FFFFFF", align: "center"

# ============================================
# ComparisonSlide - 对比页
# ============================================

class ComparisonSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        items = Object.keys(properties)
        
        # 左侧
        if items.length >= 1
            key = items[0]
            value = properties[key]
            
            slide.addShape "rect",
                x: 0.5, y: 1.2, w: 4, h: 3.5
                fill: { color: "E8F4FD" }
            
            slide.addText key,
                x: 0.5, y: 1.3, w: 4, h: 0.5
                fontSize: 18, bold: true, align: "center"
            
            slide.addText value,
                x: 0.7, y: 1.9, w: 3.6, h: 2.5
                fontSize: 14
        
        # VS
        slide.addText "VS",
            x: 4.5, y: 2.5, w: 1, h: 0.5
            fontSize: 24, bold: true, color: "FF6B6B", align: "center"
        
        # 右侧
        if items.length >= 2
            key = items[1]
            value = properties[key]
            
            slide.addShape "rect",
                x: 5.5, y: 1.2, w: 4, h: 3.5
                fill: { color: "FFF4E6" }
            
            slide.addText key,
                x: 5.5, y: 1.3, w: 4, h: 0.5
                fontSize: 18, bold: true, align: "center"
            
            slide.addText value,
                x: 5.7, y: 1.9, w: 3.6, h: 2.5
                fontSize: 14

# ============================================
# PyramidSlide - 金字塔页
# ============================================

class PyramidSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        levels = Object.keys(properties)
        levelHeight = 0.8
        startY = 1.2
        
        for level, i in levels
            value = properties[level]
            y = startY + i * levelHeight
            
            # 金字塔层级（从上到下逐渐变宽）
            width = 2 + i * 1.5
            x = 5 - width / 2
            
            # 层级背景
            colors = ["4472C4", "5B9BD5", "70AD47", "FFC000", "ED7D31"]
            slide.addShape "rect",
                x: x, y: y, w: width, h: levelHeight - 0.1
                fill: { color: colors[i % colors.length] }
            
            # 层级文本
            slide.addText "#{level}: #{value}",
                x: x, y: y + 0.2, w: width, h: levelHeight - 0.3
                fontSize: 14, color: "FFFFFF", align: "center"

# ============================================
# MindmapSlide - 思维导图页
# ============================================

class MindmapSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        branches = Object.keys(properties)
        
        # 中心节点
        slide.addShape "oval",
            x: 4, y: 2.5, w: 2, h: 1
            fill: { color: "366092" }
        
        slide.addText @name,
            x: 4, y: 2.7, w: 2, h: 0.6
            fontSize: 14, bold: true, color: "FFFFFF", align: "center"
        
        # 分支节点
        angleStep = 360 / branches.length
        radius = 2.5
        
        for branch, i in branches
            value = properties[branch]
            angle = (i * angleStep - 90) * Math.PI / 180
            x = 5 + radius * Math.cos(angle) - 1
            y = 3 + radius * Math.sin(angle) - 0.3
            
            # 连接线
            slide.addShape "line",
                x: 5, y: 3, w: x + 1 - 5, h: y + 0.3 - 3
                line: { color: "CCCCCC", width: 1 }
            
            # 分支节点
            slide.addShape "rect",
                x: x, y: y, w: 2, h: 0.6
                fill: { color: "E8F4FD" }
                line: { color: "366092", width: 1 }
            
            slide.addText branch,
                x: x, y: y + 0.1, w: 2, h: 0.4
                fontSize: 12, align: "center"

# ============================================
# SWOTSlide - SWOT分析页
# ============================================

class SWOTSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        
        # S - 优势
        if properties['优势'] or properties['S']
            value = properties['优势'] or properties['S']
            slide.addShape "rect",
                x: 0.5, y: 1.2, w: 4.5, h: 2
                fill: { color: "E8F5E9" }
            
            slide.addText "优势 (Strengths)",
                x: 0.5, y: 1.3, w: 4.5, h: 0.4
                fontSize: 16, bold: true, align: "center"
            
            slide.addText value,
                x: 0.7, y: 1.8, w: 4.1, h: 1.2
                fontSize: 12
        
        # W - 劣势
        if properties['劣势'] or properties['W']
            value = properties['劣势'] or properties['W']
            slide.addShape "rect",
                x: 5, y: 1.2, w: 4.5, h: 2
                fill: { color: "FFEBEE" }
            
            slide.addText "劣势 (Weaknesses)",
                x: 5, y: 1.3, w: 4.5, h: 0.4
                fontSize: 16, bold: true, align: "center"
            
            slide.addText value,
                x: 5.2, y: 1.8, w: 4.1, h: 1.2
                fontSize: 12
        
        # O - 机会
        if properties['机会'] or properties['O']
            value = properties['机会'] or properties['O']
            slide.addShape "rect",
                x: 0.5, y: 3.4, w: 4.5, h: 2
                fill: { color: "E3F2FD" }
            
            slide.addText "机会 (Opportunities)",
                x: 0.5, y: 3.5, w: 4.5, h: 0.4
                fontSize: 16, bold: true, align: "center"
            
            slide.addText value,
                x: 0.7, y: 4, w: 4.1, h: 1.2
                fontSize: 12
        
        # T - 威胁
        if properties['威胁'] or properties['T']
            value = properties['威胁'] or properties['T']
            slide.addShape "rect",
                x: 5, y: 3.4, w: 4.5, h: 2
                fill: { color: "FFF3E0" }
            
            slide.addText "威胁 (Threats)",
                x: 5, y: 3.5, w: 4.5, h: 0.4
                fontSize: 16, bold: true, align: "center"
            
            slide.addText value,
                x: 5.2, y: 4, w: 4.1, h: 1.2
                fontSize: 12

# ============================================
# Section - 节类（声明式）
# ============================================

class Section
    @toPptx: (pptx) ->
        # 支持函数和数组两种方式
        slides = if typeof @幻灯片 is 'function' then @幻灯片() else @幻灯片 ? []
        
        for slide in slides
            slide.toPptx?(pptx)

# ============================================
# Chapter - 章类（声明式）
# ============================================

class Chapter
    @toPptx: (pptx) ->
        # 支持函数和数组两种方式
        sections = if typeof @节 is 'function' then @节() else @节 ? []
        
        for section in sections
            section.toPptx?(pptx)

# ============================================
# Presentation - 演示文稿类（声明式）
# ============================================

class Presentation
    @generate: ->
        outputPath = "outputs/#{@name}.pptx"
        
        console.log "\n🚀 Generating presentation: #{@name}\n"
        
        pptx = new pptxgen()
        pptx.title = @name
        pptx.author = "BoxesPlus"
        
        # 支持函数和数组两种方式
        sections = if typeof @sections is 'function' then @sections() else @sections ? []
        
        for section in sections
            section.toPptx?(pptx)
        
        pptx.writeFile({ fileName: outputPath })
        console.log "✅ Generated: #{outputPath}\n"
    
    @newPresentation: ->
        setImmediate => @generate()

# ============================================
# 导出
# ============================================

module.exports = {
    Slide
    TitleSlide
    ContentSlide
    TwoColumnSlide
    TableSlide
    CardSlide
    ImageSlide
    ImageTextSlide
    TimelineSlide
    QuoteSlide
    NumberSlide
    ProcessSlide
    GanttSlide
    ComparisonSlide
    PyramidSlide
    MindmapSlide
    SWOTSlide
    Section
    Chapter
    Presentation
}
