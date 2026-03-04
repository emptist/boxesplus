# BoxesPlus - Declarative API
# 结合声明式设计 + Mermaid图表支持

{ generateHtml, htmlToPdf, htmlToPptx, CHARTS } = require "./hybrid-generator.coffee"

# ============================================
# Slide - 基础幻灯片类
# ============================================

class Slide
  @layout: "default"
  @scale: "1.0"
  @chart: null
  
  @getProperties: ->
    props = {}
    for key, value of this
      unless key in ['name', 'length', 'prototype', 'toPptx', 'getProperties', 'toData', 'layout', 'scale', 'chart']
        props[key] = value
    props

  @toData: ->
    type: @layout
    title: @getTitle()
    scale: @scale

  @getTitle: -> @name or @constructor.name

# ============================================
# 基础幻灯片类型
# ============================================

class TitleSlide extends Slide
  @layout: "title"
  @subtitle: ""
  
  @toData: ->
    type: "title"
    title: @getTitle()
    subtitle: @subtitle or ""

class ContentSlide extends Slide
  @layout: "content"
  
  @toData: ->
    props = @getProperties()
    items = Object.values(props)
    type: "content"
    title: @getTitle()
    items: items

class ListSlide extends Slide
  @layout: "list"
  
  @toData: ->
    props = @getProperties()
    items = Object.values(props)
    type: "list"
    title: @getTitle()
    items: items

class TwoColSlide extends Slide
  @layout: "two-col"
  @leftTitle: "左侧"
  @rightTitle: "右侧"
  @leftItems: []
  @rightItems: []
  
  @toData: ->
    type: "two-col"
    title: @getTitle()
    leftTitle: @leftTitle or "左侧"
    rightTitle: @rightTitle or "右侧"
    leftItems: @leftItems or []
    rightItems: @rightItems or []

class ImageSlide extends Slide
  @layout: "image"

# ============================================
# Mermaid 图表幻灯片 (核心功能!)
# ============================================

class MermaidSlide extends Slide
  @layout: "mermaid"
  @scale: "0.9"
  @chart: null
  
  @toData: ->
    type: "mermaid"
    title: @getTitle()
    chart: @chart or ""
    scale: @scale or "0.9"

class FlowchartSlide extends MermaidSlide
  @chart: null

class PDCA extends MermaidSlide
  @chart: CHARTS.pdca

class Pareto extends MermaidSlide
  @chart: CHARTS.pareto

class EventLoop extends MermaidSlide
  @chart: CHARTS.eventLoop

class DataLifecycle extends MermaidSlide
  @chart: CHARTS.dataLifecycle

class BrandPyramid extends MermaidSlide
  @chart: CHARTS.brandPyramid

class QualitySystem extends MermaidSlide
  @chart: CHARTS.qualitySystem

class PatientSafety extends MermaidSlide
  @chart: CHARTS.patientSafety

class SWOT extends MermaidSlide
  @chart: CHARTS.swot

class Surgery extends MermaidSlide
  @chart: CHARTS.surgery

class Evaluation extends MermaidSlide
  @chart: CHARTS.evaluation

class Timeline extends MermaidSlide
  @chart: CHARTS.timeline

class Mindmap extends MermaidSlide
  @chart: CHARTS.mindmap

class Gantt extends MermaidSlide
  @chart: CHARTS.ganttSimple

# ============================================
# 复合幻灯片类型
# ============================================

class SWOTSlide extends Slide
  @layout: "swot"

class TimelineSlide extends Slide
  @layout: "timeline"

class ProcessSlide extends Slide
  @layout: "process"

class CardSlide extends Slide
  @layout: "card"

class PyramidSlide extends Slide
  @layout: "pyramid"

# ============================================
# Section
# ============================================

class Section
  @slides: []
  
  @getSlides: ->
    slides = if typeof @slides is 'function' then @slides() else @slides ? []
    slides

  @toData: ->
    title: @getTitle()
    slides: for slide in @getSlides()
      slide.toData()

  @getTitle: -> @name or @constructor.name

# ============================================
# Presentation
# ============================================

class Presentation
  @sections: []
  
  @generate: (baseName) ->
    name = baseName or @name or @constructor.name
    
    htmlPath = "outputs/#{name}.html"
    pdfPath = "outputs/#{name}.pdf"
    pptxPath = "outputs/#{name}.pptx"
    
    console.log "\n🚀 Generating: #{name}\n"
    
    sections = if typeof @sections is 'function' then @sections() else @sections ? []
    
    slides = []
    for section in sections
      slides.push(...section.getSlides())
    
    data = {
      title: name
      slides: for slide in slides
        slide.toData()
    }
    
    generateHtml(data, htmlPath)
    htmlToPdf(htmlPath, pdfPath)
    htmlToPptx(htmlPath, pptxPath)
    
    console.log "✅ Generated: #{pptxPath}\n"
  
  @newPresentation: ->
    setImmediate => @generate()

  @getTitle: -> @name or @constructor.name

# ============================================
# 便捷函数
# ============================================

# 使用类属性快速创建幻灯片
createSlide = (slideClass, props = {}) ->
  class extends slideClass
    for key, value of props
      do (key, value) =>
        Object.defineProperty @prototype, key,
          get: -> value

# 从数据数组创建幻灯片集合
createSlides = (slideClass, dataArray) ->
  for data in dataArray
    class extends slideClass
      for key, value of data
        do (key, value) =>
          Object.defineProperty @prototype, key,
            get: -> value

# ============================================
# 导出
# ============================================

module.exports = {
  Slide
  TitleSlide
  ContentSlide
  ListSlide
  TwoColSlide
  ImageSlide
  MermaidSlide
  FlowchartSlide
  PDCA
  Pareto
  EventLoop
  DataLifecycle
  BrandPyramid
  QualitySystem
  PatientSafety
  SWOT
  Surgery
  Evaluation
  Timeline
  Mindmap
  Gantt
  SWOTSlide
  TimelineSlide
  ProcessSlide
  CardSlide
  PyramidSlide
  Section
  Presentation
  CHARTS
  createSlide
  createSlides
}
