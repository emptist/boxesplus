# BoxesPlus - 高级 OO API (Class-as-Slide 模式)
# 正确实现 @cso: @dataPrepare?() 模式

{ generateHtml, htmlToPdf, htmlToPptx } = require "./hybrid-generator.coffee"
fs = require "fs"
path = require "path"

# ============================================
# Slide - 基类
# ============================================

class Slide
  @layout: "default"
  @scale: "1.0"
  
  # 子类必须在 @dataPrepare 之后定义 @cso
  @dataPrepare: -> null
  
  getTitle: -> @title or @constructor.name
  
  constructor: (data = {}) ->
    @title = data.title or @getTitle()
    @layout = data.layout or @constructor.layout
    @scale = data.scale or @constructor.scale
    @_data = data

  toData: ->
    data = {
      type: @layout
      title: @getTitle()
      scale: @scale
    }
    
    switch @layout
      when "title"
        data.subtitle = @_data.subtitle
      when "mermaid"
        data.chart = @_data.chart
      when "list"
        data.items = @_data.items or []
      when "two-col"
        data.leftTitle = @_data.leftTitle
        data.leftItems = @_data.leftItems or []
        data.rightTitle = @_data.rightTitle
        data.rightItems = @_data.rightItems or []
      else
        data.content = @_data.content
    
    data

# ============================================
# Slide 子类 - 每个类都需要自己的 @cso
# ============================================

class TitleSlide extends Slide
  @layout: "title"
  @dataPrepare: -> {}
  @cso: @dataPrepare?()
  
  constructor: (title, subtitle = "") ->
    super({title, subtitle, layout: "title"})

class MermaidSlide extends Slide
  @layout: "mermaid"
  @scale: "0.9"
  @dataPrepare: -> {}
  @cso: @dataPrepare?()
  
  constructor: (title, chart, scale = "0.9") ->
    super({title, chart, scale, layout: "mermaid"})

class ListSlide extends Slide
  @layout: "list"
  @dataPrepare: -> {}
  @cso: @dataPrepare?()
  
  constructor: (title, items) ->
    super({title, items, layout: "list"})

class TwoColSlide extends Slide
  @layout: "two-col"
  @dataPrepare: -> {}
  @cso: @dataPrepare?()
  
  constructor: (title, leftTitle, leftItems, rightTitle, rightItems) ->
    super({title, leftTitle, leftItems, rightTitle, rightItems, layout: "two-col"})

# ============================================
# Section
# ============================================

class Section
  @dataPrepare: -> null
  
  constructor: (title, data = {}) ->
    @title = title or @constructor.name
    @_slides = []
    @_data = data
  
  add: (slide) ->
    @_slides.push(slide)
    this
  
  addSlide: (slideClass, data = {}) ->
    if slideClass instanceof Slide
      @_slides.push(slideClass)
    else
      @_slides.push(new slideClass(data))
    this
  
  getSlides: -> @_slides
  count: -> @_slides.length

# ============================================
# Presentation
# ============================================

class Presentation
  @sections: []
  @dataPrepare: -> null
  
  constructor: (title) ->
    @title = title or @constructor.name
    @_sections = []
    @_slides = []
  
  addSection: (section) ->
    @_sections.push(section)
    @_slides.push(...section.getSlides())
    this
  
  add: (section) -> @addSection(section)
  
  addSlide: (slideOrClass, data = {}) ->
    if slideOrClass instanceof Slide
      @_slides.push(slideOrClass)
    else
      @_slides.push(new slideOrClass(data))
    this
  
  getAllSlides: -> @_slides
  
  toData: ->
    title: @title
    slides: for slide in @_slides
      slide.toData()
  
  generate: (baseName = "output") ->
    htmlPath = "outputs/#{baseName}.html"
    pdfPath = "outputs/#{baseName}.pdf"
    pptxPath = "outputs/#{baseName}.pptx"
    
    generateHtml(@toData(), htmlPath)
    await htmlToPdf(htmlPath, pdfPath)
    await htmlToPptx(htmlPath, pptxPath)
    console.log "🎉 #{@title} 生成完成!"

# ============================================
# CHARTS
# ============================================

CHARTS = require("./hybrid-generator.coffee").CHARTS

# ============================================
# 导出
# ============================================

module.exports = {
  Slide
  TitleSlide
  MermaidSlide
  ListSlide
  TwoColSlide
  Section
  Presentation
  CHARTS
}
