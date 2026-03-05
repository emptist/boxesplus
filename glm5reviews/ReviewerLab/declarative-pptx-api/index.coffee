# BoxesPlus - Declarative Presentation Framework
# 用户只要运行 coffee self.coffee，所有一切都会完成

fs = require "fs"
pptxgen = require "pptxgenjs"
SmartLayout = require "./smart-layout"

# ============================================
# 全局配置
# ============================================

OUTPUT_DIR = "#{__dirname}/outputs"

# ============================================
# Slide - 幻灯片基类（声明式）
# ============================================

class Slide
    @toPptx: (pptx) ->
        try
            slide = pptx.addSlide()
            
            slide.addText @name,
                x: 0.5, y: 0.3, w: 9, h: 0.6
                fontSize: 28, bold: true, color: "366092"
            
            properties = @getProperties()
            y = 1.2
            
            for key, value of properties
                @renderPropertyToPptx(slide, key, value, y)
                y += 1.0
        catch error
            console.error "❌ Error in slide '#{@name}':", error.message
            console.error "   Stack:", error.stack
            @createErrorSlide(pptx, error)
    
    @createErrorSlide: (pptx, error) ->
        slide = pptx.addSlide()
        slide.addText "Error in #{@name}",
            x: 0.5, y: 2, w: 9, h: 1
            fontSize: 32, color: "FF0000", align: "center", bold: true
        slide.addText error.message,
            x: 0.5, y: 3.2, w: 9, h: 0.5
            fontSize: 18, color: "666666", align: "center"
    
    @getProperties: ->
        props = {}
        for key, value of this
            unless key in ['name', 'length', 'prototype', 'toPptx', 'getProperties', 'renderPropertyToPptx', 'autoFontSize', 'fitText']
                props[key] = value
        props
    
    @autoFontSize: (text, width, height, maxFontSize = 18, minFontSize = 10) ->
        SmartLayout.calculateFontSize(text, width, height)
    
    @fitText: (text, width, height) ->
        SmartLayout.adjustFontSize(text, width, height, 18, 10)
    
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
# 标题页 - 用于课程封面、章节封面
#
# 支持属性：
# - @副标题: string - 副标题文本（可选）
#
# 示例：
# class 课程名称 extends TitleSlide
#     @副标题: "医院管理核心模块课程"
# ============================================

class TitleSlide extends Slide
    @validate: ->
        unless @name
            throw new Error "TitleSlide must have a name"
        if @副标题 and typeof @副标题 isnt 'string'
            throw new Error "副标题 must be a string in TitleSlide '#{@name}'"
        true
    
    @toPptx: (pptx) ->
        try
            @validate()
            slide = pptx.addSlide()
            
            slide.addText @name,
                x: 0.5, y: 2.5, w: 9, h: 1
                fontSize: 44, bold: true, color: "366092", align: "center"
            
            if @副标题
                slide.addText @副标题,
                    x: 0.5, y: 3.5, w: 9, h: 0.5
                    fontSize: 24, color: "666666", align: "center"
        catch error
            console.error "❌ Error in TitleSlide '#{@name}':", error.message
            console.error "   Stack:", error.stack
            @createErrorSlide(pptx, error)

# ============================================
# ContentSlide - 内容页
# ============================================
# 内容页 - 用于展示文本内容
#
# 支持属性：
# - @属性名: string - 任意文本内容
# - 支持多个属性，每个属性显示为一行
#
# 示例：
# class 课程对象 extends ContentSlide
#     @对象1: "医院院长、书记、分管副院长"
#     @对象2: "品牌/宣传/市场/客服部门负责人"
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
            fontSize = @autoFontSize(value, 9, 0.4)
            
            slide.addText "• #{value}",
                x: 0.5, y: y, w: 9, h: 0.4
                fontSize: fontSize, color: "333333"
            y += 0.5

# ============================================
# CodeSlide - 代码页
# ============================================

class CodeSlide extends ContentSlide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        y = 1.2
        
        for key, value of properties
            if key is '代码'
                fontSize = @autoFontSize(value, 9, 5)
                
                slide.addText value,
                    x: 0.5, y: y, w: 9, h: 5
                    fontSize: fontSize, color: "333333", align: "left"
                y += 5.2
            else
                fontSize = @autoFontSize(value, 9, 0.4)
                
                slide.addText "• #{value}",
                    x: 0.5, y: y, w: 9, h: 0.4
                    fontSize: fontSize, color: "333333"
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
        
        maxKeyLength = 0
        maxValueLength = 0
        
        for key, value of properties
            keyLen = key.length
            valLen = value?.length or 0
            maxKeyLength = Math.max(maxKeyLength, keyLen)
            maxValueLength = Math.max(maxValueLength, valLen)
        
        totalLength = maxKeyLength + maxValueLength
        if totalLength > 0
            keyRatio = maxKeyLength / totalLength
            valueRatio = maxValueLength / totalLength
            keyWidth = Math.max(1.5, Math.min(3, 9 * keyRatio))
            valueWidth = 9 - keyWidth
        else
            keyWidth = 2.5
            valueWidth = 6.5
        
        rows = [["项目", "内容"]]
        
        for key, value of properties
            rows.push([key, value])
        
        slide.addTable rows,
            x: 0.5, y: 1.2, w: 9, h: 4
            fontSize: 14
            border: { pt: 1, color: "CCCCCC" }
            fill: { color: "F5F5F5" }
            colW: [keyWidth, valueWidth]

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
            
            fontSize = @autoFontSize(value, cardWidth - 0.4, 1.2)
            
            slide.addShape "rect",
                x: x, y: 1.2, w: cardWidth - 0.2, h: 1.8
                fill: { color: "F0F0F0" }
            
            slide.addText key,
                x: x + 0.1, y: 1.3, w: cardWidth - 0.4, h: 0.4
                fontSize: 16, bold: true, color: "366092"
            
            slide.addText value,
                x: x + 0.1, y: 1.8, w: cardWidth - 0.4, h: 1.2
                fontSize: fontSize, color: "333333"

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
        propertyCount = Object.keys(properties).length
        availableHeight = 7.5 - 1.2
        quoteHeight = availableHeight / propertyCount
        
        y = 1.2
        
        for key, value of properties
            slide.addShape "rect",
                x: 0.5, y: y, w: 9, h: quoteHeight
                fill: { color: "F5F5F5" }
            
            fontSize = @autoFontSize(value, 8, quoteHeight * 0.6)
            slide.addText "\"#{value}\"",
                x: 1, y: y + quoteHeight * 0.2, w: 8, h: quoteHeight * 0.6
                fontSize: fontSize, italic: true, color: "666666"
            
            slide.addText "— #{key}",
                x: 1, y: y + quoteHeight * 0.8, w: 8, h: quoteHeight * 0.2
                fontSize: Math.min(14, fontSize), align: "right", color: "999999"
            
            y += quoteHeight

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
            
            numberMatch = value.match(/(\d+\.?\d*\s*%?|\d+\s*[万千万亿]+[+]?)$/)
            displayValue = if numberMatch then numberMatch[1] else value
            
            valueFontSize = Math.max(@autoFontSize(displayValue, itemWidth, 1), 32)
            slide.addText displayValue,
                x: x, y: 1.5, w: itemWidth, h: 1
                fontSize: valueFontSize, bold: true, color: "366092", align: "center"
            
            labelFontSize = @autoFontSize(key, itemWidth, 0.5)
            slide.addText key,
                x: x, y: 2.6, w: itemWidth, h: 0.5
                fontSize: labelFontSize, color: "666666", align: "center"

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
# SWOT分析页 - 用于战略分析、优劣势分析
#
# 支持属性：
# - @优势 or @S: string - 优势内容
# - @劣势 or @W: string - 劣势内容
# - @机会 or @O: string - 机会内容
# - @威胁 or @T: string - 威胁内容
# - 至少需要一个属性
#
# 示例：
# class 品牌建设SWOT分析 extends SWOTSlide
#     @优势: "技术领先、专家团队"
#     @劣势: "传播不足、新媒体弱"
#     @机会: "政策支持、市场需求"
#     @威胁: "竞争激烈、舆论风险"
# ============================================

class SWOTSlide extends Slide
    @validate: ->
        unless @name
            throw new Error "SWOTSlide must have a name"
        properties = @getProperties()
        hasSWOT = properties['优势'] or properties['S'] or 
                  properties['劣势'] or properties['W'] or
                  properties['机会'] or properties['O'] or
                  properties['威胁'] or properties['T']
        unless hasSWOT
            throw new Error "SWOTSlide '#{@name}' must have at least one of: 优势/S, 劣势/W, 机会/O, 威胁/T"
        true
    
    @toPptx: (pptx) ->
        try
            @validate()
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
        catch error
            console.error "❌ Error in SWOTSlide '#{@name}':", error.message
            console.error "   Stack:", error.stack
            @createErrorSlide(pptx, error)

# ============================================
# SectionSlide - 章节页
# ============================================
# 章节页 - 用于章节分隔
#
# 支持属性：
# - @编号: string - 章节编号（可选）
# - @副标题: string - 副标题文本（可选）
#
# 示例：
# class 第一章 extends SectionSlide
#     @编号: "01"
#     @副标题: "品牌建设基础"
# ============================================

class SectionSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addShape "rect",
            x: 0, y: 0, w: 10, h: 7.5
            fill: { color: "366092" }
        
        if @编号
            slide.addText @编号,
                x: 0.5, y: 2.5, w: 9, h: 0.8
                fontSize: 48, bold: true, color: "FFFFFF", align: "center"
        
        slide.addText @name,
            x: 0.5, y: 3.5, w: 9, h: 1
            fontSize: 44, bold: true, color: "FFFFFF", align: "center"
        
        if @副标题
            slide.addText @副标题,
                x: 0.5, y: 4.5, w: 9, h: 0.5
                fontSize: 24, color: "E8F4FD", align: "center"

# ============================================
# EndSlide - 结束页
# ============================================
# 结束页 - 用于课程结束
#
# 支持属性：
# - @感谢语: string - 感谢语（可选）
# - @联系方式: string - 联系方式（可选）
#
# 示例：
# class 谢谢 extends EndSlide
#     @感谢语: "感谢聆听"
#     @联系方式: "contact@example.com"
# ============================================

class EndSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addShape "rect",
            x: 0, y: 0, w: 10, h: 7.5
            fill: { color: "366092" }
        
        slide.addText @name,
            x: 0.5, y: 2.5, w: 9, h: 1
            fontSize: 48, bold: true, color: "FFFFFF", align: "center"
        
        if @感谢语
            slide.addText @感谢语,
                x: 0.5, y: 3.8, w: 9, h: 0.5
                fontSize: 24, color: "E8F4FD", align: "center"
        
        if @联系方式
            slide.addText @联系方式,
                x: 0.5, y: 4.5, w: 9, h: 0.5
                fontSize: 18, color: "B4D7F0", align: "center"

# ============================================
# PDCASlide - PDCA循环页
# ============================================
# PDCA循环页 - 用于质量管理
#
# 支持属性：
# - @P: string - Plan计划
# - @D: string - Do执行
# - @C: string - Check检查
# - @A: string - Act处理
#
# 示例：
# class 质量管理PDCA extends PDCASlide
#     @P: "制定质量目标和计划"
#     @D: "执行质量计划"
#     @C: "检查质量结果"
#     @A: "处理质量问题"
# ============================================

class PDCASlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        
        colors = ["E8F5E9", "E3F2FD", "FFF3E0", "FFEBEE"]
        labels = ["P - Plan", "D - Do", "C - Check", "A - Act"]
        keys = ["P", "D", "C", "A"]
        
        for i in [0..3]
            x = if i % 2 == 0 then 0.5 else 5
            y = if i < 2 then 1.1 else 4.0
            
            slide.addShape "rect",
                x: x, y: y, w: 4.5, h: 2.6
                fill: { color: colors[i] }
            
            slide.addText labels[i],
                x: x, y: y + 0.1, w: 4.5, h: 0.4
                fontSize: 16, bold: true, align: "center"
            
            if properties[keys[i]]
                fontSize = @autoFontSize(properties[keys[i]], 4.1, 1.8)
                slide.addText properties[keys[i]],
                    x: x + 0.2, y: y + 0.6, w: 4.1, h: 1.8
                    fontSize: fontSize

# ============================================
# OrgChartSlide - 组织架构图页
# ============================================
# 组织架构图页 - 用于组织结构
#
# 支持属性：
# - @顶层: string - 顶层领导
# - @中层: string - 中层管理（多个用逗号分隔）
# - @基层: string - 基层员工（多个用逗号分隔）
#
# 示例：
# class 医院组织架构 extends OrgChartSlide
#     @顶层: "院长"
#     @中层: "副院长, 科室主任"
#     @基层: "医生, 护士, 行政人员"
# ============================================

class OrgChartSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        
        # 顶层
        if properties['顶层']
            slide.addShape "rect",
                x: 3.5, y: 1.2, w: 3, h: 0.8
                fill: { color: "366092" }
            
            slide.addText properties['顶层'],
                x: 3.5, y: 1.3, w: 3, h: 0.6
                fontSize: 16, bold: true, color: "FFFFFF", align: "center"
        
        # 中层
        if properties['中层']
            middle = properties['中层'].split(',').map (s) -> s.trim()
            middleWidth = 8 / middle.length
            startX = 1
            
            for person, i in middle
                x = startX + i * middleWidth
                
                # 连接线
                slide.addShape "line",
                    x: 5, y: 2, w: x + middleWidth / 2 - 5, h: 0.8
                    line: { color: "CCCCCC", width: 1 }
                
                slide.addShape "rect",
                    x: x, y: 2.8, w: middleWidth - 0.2, h: 0.8
                    fill: { color: "4472C4" }
                
                slide.addText person,
                    x: x, y: 2.9, w: middleWidth - 0.2, h: 0.6
                    fontSize: 14, color: "FFFFFF", align: "center"
        
        # 基层
        if properties['基层']
            bottom = properties['基层'].split(',').map (s) -> s.trim()
            bottomWidth = 8 / bottom.length
            startX = 1
            
            for person, i in bottom
                x = startX + i * bottomWidth
                
                # 连接线
                slide.addShape "line",
                    x: 5, y: 3.6, w: x + bottomWidth / 2 - 5, h: 0.8
                    line: { color: "CCCCCC", width: 1 }
                
                slide.addShape "rect",
                    x: x, y: 4.4, w: bottomWidth - 0.2, h: 0.8
                    fill: { color: "70AD47" }
                
                slide.addText person,
                    x: x, y: 4.5, w: bottomWidth - 0.2, h: 0.6
                    fontSize: 12, color: "FFFFFF", align: "center"

# ============================================
# BoxSlide - 盒子图页
# ============================================
# 盒子图页 - 用于概念关系
#
# 支持属性：
# - @属性名: string - 盒子内容
# - 支持多个属性，每个属性显示为一个盒子
#
# 示例：
# class 品牌建设要素 extends BoxSlide
#     @品牌定位: "明确品牌定位"
#     @品牌传播: "制定传播策略"
#     @品牌管理: "建立管理体系"
#     @品牌评估: "定期评估效果"
# ============================================

class BoxSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        boxes = Object.keys(properties)
        boxWidth = 8.5 / boxes.length
        
        for key, i in boxes
            value = properties[key]
            x = 0.75 + i * boxWidth
            
            slide.addShape "rect",
                x: x, y: 2, w: boxWidth - 0.2, h: 2
                fill: { color: "E8F4FD" }
                line: { color: "366092", width: 2 }
            
            slide.addText key,
                x: x, y: 2.2, w: boxWidth - 0.2, h: 0.5
                fontSize: 16, bold: true, color: "366092", align: "center"
            
            slide.addText value,
                x: x + 0.1, y: 2.8, w: boxWidth - 0.4, h: 1
                fontSize: 14, align: "center"

# ============================================
# MatrixSlide - 矩阵图页
# ============================================
# 矩阵图页 - 用于分析框架
#
# 支持属性：
# - @属性名: string - 矩阵内容
# - 支持多个属性，每个属性显示为一个矩阵元素
#
# 示例：
# class 波士顿矩阵 extends MatrixSlide
#     @明星: "高增长高市场份额"
#     @金牛: "低增长高市场份额"
#     @问题: "高增长低市场份额"
#     @瘦狗: "低增长低市场份额"
# ============================================

class MatrixSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        
        positions = [
            {x: 0.5, y: 1.1}
            {x: 5, y: 1.1}
            {x: 0.5, y: 4.0}
            {x: 5, y: 4.0}
        ]
        
        colors = ["E8F5E9", "E3F2FD", "FFF3E0", "FFEBEE"]
        keys = Object.keys(properties)
        
        for i in [0..Math.min(3, keys.length - 1)]
            key = keys[i]
            value = properties[key]
            pos = positions[i]
            
            slide.addShape "rect",
                x: pos.x, y: pos.y, w: 4.5, h: 2.6
                fill: { color: colors[i] }
            
            slide.addText key,
                x: pos.x, y: pos.y + 0.1, w: 4.5, h: 0.4
                fontSize: 16, bold: true, align: "center"
            
            fontSize = @autoFontSize(value, 4.1, 1.8)
            slide.addText value,
                x: pos.x + 0.2, y: pos.y + 0.6, w: 4.1, h: 1.8
                fontSize: fontSize

# ============================================
# MermaidSlide - Mermaid图表页
# ============================================

class MermaidSlide extends Slide
    @toPptx: (pptx) ->
        slide = pptx.addSlide()
        
        slide.addText @name,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        properties = @getProperties()
        diagram = properties.diagram || properties.图表 || ""
        
        slide.addText "Mermaid Diagram (HTML Output Required)",
            x: 0.5, y: 2.5, w: 9, h: 1
            fontSize: 18, color: "999999", align: "center"
        
        slide.addText diagram.substring(0, 200) + (if diagram.length > 200 then "..." else ""),
            x: 0.5, y: 3.5, w: 9, h: 2
            fontSize: 10, color: "666666", align: "left"
    
    @toHtml: ->
        properties = @getProperties()
        diagram = properties.diagram || properties.图表 || ""
        
        """
        <section>
            <h3 style="color: #1a365d; margin-bottom: 20px;">#{@name}</h3>
            <div class="mermaid" style="font-size: 24px;">
#{diagram}
            </div>
        </section>
        """

# ============================================
# Section - 册类（声明式）
# ============================================
# 册类 - 用于组织章节
#
# 支持属性：
# - @chapters: array - 包含的章节列表
#
# 示例：
# class 第一章册 extends Section
#     @chapters: -> [第一章章]
# ============================================

class Section
    @toPptx: (pptx) ->
        # 渲染Section封面
        slide = pptx.addSlide()
        slide.addText @name,
            x: 0.5, y: 2.5, w: 9, h: 1
            fontSize: 44, bold: true, color: "366092", align: "center"
        
        # 支持函数和数组两种方式，统一使用 @including 属性
        # 支持 Chapter、Node、Slide 任意一个类型的数组
        including = if typeof @including is 'function' then @including() else @including ? []
        
        unless including.length > 0
            console.warn "⚠️  Warning: Section '#{@name}' has no including defined"
        
        for include in including
            unless include?.toPptx
                console.warn "⚠️  Warning: '#{include?.name or include}' in Section '#{@name}' is not a valid class (did you forget to extend?)"
            include.toPptx?(pptx)

# ============================================
# Chapter - 章类（声明式）
# ============================================

class Chapter
    @toPptx: (pptx) ->
        # 渲染Chapter封面
        slide = pptx.addSlide()
        slide.addText @name,
            x: 0.5, y: 2.5, w: 9, h: 1
            fontSize: 44, bold: true, color: "366092", align: "center"
        
        # 支持函数和数组两种方式，统一使用 @including 属性
        # 支持 Node、Slide 任意一个类型的数组
        including = if typeof @including is 'function' then @including() else @including ? []
        
        for include in including
            include.toPptx?(pptx)

# ============================================
# Node - 节类（声明式）
# ============================================
# 节类 - 用于组织幻灯片
#
# 支持属性：
# - @slides: array - 包含的幻灯片列表
#
# 示例：
# class 第一节节 extends Node
#     @slides: -> [项目起源, 早期探索, HQCoffee参考, 早期技术栈]
# ============================================

class Node
    @toPptx: (pptx) ->
        # 渲染Node封面
        slide = pptx.addSlide()
        slide.addText @name,
            x: 0.5, y: 2.5, w: 9, h: 1
            fontSize: 44, bold: true, color: "366092", align: "center"
        
        # 支持函数和数组两种方式，统一使用 @including 属性
        # 支持 Slide 类型的数组
        including = if typeof @including is 'function' then @including() else @including ? []
        
        unless including.length > 0
            console.warn "⚠️  Warning: Node '#{@name}' has no including defined"
        
        for include in including
            unless include?.toPptx
                console.warn "⚠️  Warning: '#{include?.name or include}' in Node '#{@name}' is not a valid Slide class (did you forget to extend Slide?)"
            include.toPptx?(pptx)

# ============================================
# Presentation - 书类（声明式）
# ============================================
# 书类 - 用于组织册
#
# 支持属性：
# - @sections: array - 包含的册列表
#
# 示例：
# class BoxesPlus项目演进史 extends Presentation
#     @sections: -> [封面册, 第一章册]
# ============================================

class Presentation
    @generate: ->
        try
            outputPath = "#{OUTPUT_DIR}/#{@name}.pptx"
            
            console.log "\n🚀 Generating presentation: #{@name}\n"
            
            pptx = new pptxgen()
            pptx.title = @name
            pptx.author = "BoxesPlus"
            
            # 渲染Presentation封面
            slide = pptx.addSlide()
            slide.addText @name,
                x: 0.5, y: 2.5, w: 9, h: 1
                fontSize: 44, bold: true, color: "366092", align: "center"
            
            # 支持函数和数组两种方式，统一使用 @including 属性
            # 支持 Section、Chapter、Node、Slide 任意一个类型的数组
            including = if typeof @including is 'function' then @including() else @including ? []
            
            unless including.length > 0
                console.warn "⚠️  Warning: Presentation '#{@name}' has no including defined"
            
            for include in including
                unless include?.toPptx
                    console.warn "⚠️  Warning: '#{include?.name or include}' in Presentation '#{@name}' is not a valid class (did you forget to extend?)"
                include.toPptx?(pptx)
            
            pptx.writeFile({ fileName: outputPath })
            console.log "✅ Generated: #{outputPath}\n"
        catch error
            console.error "❌ Error in presentation '#{@name}':", error.message
            console.error "   Stack:", error.stack
            console.error "   Please check your slide definitions and try again.\n"
            process.exit(1)
    
    @newPresentation: ->
        setImmediate => @generate()
    
    @generateHtml: ->
        try
            outputPath = "#{OUTPUT_DIR}/#{@name}.html"
            
            console.log "\n🌐 Generating HTML presentation: #{@name}\n"
            
            slidesHtml = []
            
            sections = if typeof @sections is 'function' then @sections() else @sections ? []
            
            for section in sections
                continue unless section?.幻灯片
                slides = if typeof section.幻灯片 is 'function' then section.幻灯片() else section.幻灯片 ? []
                
                for slide in slides
                    if slide?.toHtml
                        slidesHtml.push slide.toHtml()
                    else if slide?.name
                        slidesHtml.push """
                        <section>
                            <h2>#{slide.name}</h2>
                        </section>
                        """
            
            html = """
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>#{@name}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
    <style>
        .reveal .slides section { text-align: center; }
        .reveal { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; }
        .mermaid { display: flex; justify-content: center; margin: 20px 0; }
        .reveal .mermaid svg { max-width: 100%; height: auto; }
        .reveal h1, .reveal h2, .reveal h3 { color: #1a365d; }
    </style>
</head>
<body>
    <div class="reveal">
        <div class="slides">
            #{slidesHtml.join("\n")}
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
    <script>
        mermaid.initialize({ 
            startOnLoad: true,
            theme: 'base',
            themeVariables: {
                primaryColor: '#3182ce',
                edgeLabelBackground: '#ffffff',
                tertiaryColor: '#f7fafc'
            }
        });
        Reveal.initialize({
            hash: true,
            slideNumber: true,
            transition: 'slide',
            center: true,
            width: 1280,
            height: 720
        });
    </script>
</body>
</html>
            """
            
            fs.writeFileSync(outputPath, html)
            console.log "✅ Generated: #{outputPath}\n"
        catch error
            console.error "❌ Error in HTML generation '#{@name}':", error.message
            process.exit(1)

# ============================================
# 导出
# ============================================

module.exports = {
    Slide
    TitleSlide
    ContentSlide
    CodeSlide
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
    SectionSlide
    EndSlide
    PDCASlide
    OrgChartSlide
    BoxSlide
    MatrixSlide
    MermaidSlide
    Section
    Chapter
    Node
    Presentation
}
