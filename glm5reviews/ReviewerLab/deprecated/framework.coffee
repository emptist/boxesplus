# BoxesPlus - Declarative Presentation Framework
# 用户只要运行 coffee self.coffee，所有一切都会完成

fs = require "fs"
pptxgen = require "pptxgenjs"

# ============================================
# Slide - 幻灯片类（声明式）
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
# Section - 节类（声明式）
# ============================================

class Section
    @toPptx: (pptx) ->
        slidesKey = Object.keys(this).find((k) -> k in ['幻灯片', 'slides'])
        slides = if slidesKey then this[slidesKey] else []
        
        for slide in slides
            slide.toPptx(pptx)

# ============================================
# Chapter - 章类（声明式）
# ============================================

class Chapter
    @toPptx: (pptx) ->
        sectionsKey = Object.keys(this).find((k) -> k in ['节', 'sections', '章'])
        sections = if sectionsKey then this[sectionsKey] else []
        
        for section in sections
            section.toPptx(pptx)

# ============================================
# Presentation - 演示文稿类（声明式）
# ============================================

class Presentation
    @generate: (outputPath) ->
        outputPath ?= "outputs/#{@name}.pptx"
        
        console.log "\n🚀 Generating presentation: #{@name}\n"
        
        pptx = new pptxgen()
        pptx.title = @name
        pptx.author = "BoxesPlus"
        
        sectionsKey = Object.keys(this).find((k) -> k in ['sections', '章', 'parts'])
        sections = if sectionsKey then this[sectionsKey] else []
        
        for section in sections
            section.toPptx(pptx)
        
        pptx.writeFile({ fileName: outputPath })
        console.log "✅ Generated: #{outputPath}\n"

# ============================================
# 自动生成机制（CoffeeScript 独特特性）
# ============================================

# 在下一个事件循环中执行，确保所有类都已定义
setImmediate ->
    presentations = []
    
    # 扫描全局对象，找到所有 Presentation 子类
    for name, value of global
        try
            if typeof value is 'function' and value.prototype?
                proto = Object.getPrototypeOf(value)
                if proto?.name is 'Presentation' and value.name isnt 'Presentation'
                    presentations.push(value)
        catch error
    
    # 自动生成
    if presentations.length > 0
        console.log "\n🎯 Found #{presentations.length} presentation(s)"
        
        for presentation in presentations
            presentation.generate()

# ============================================
# 导出
# ============================================

module.exports = {
    Slide
    Section
    Chapter
    Presentation
}
