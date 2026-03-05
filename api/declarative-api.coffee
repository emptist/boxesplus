# BoxesPlus - Declarative API
# 结合声明式设计 + Mermaid图表支持

{ generateHtml, htmlToPdf, htmlToPptx, CHARTS } = require "./hybrid-generator.coffee"
{ Theme, Themes, getTheme, createCustomTheme, getThemeColors, getThemePptxConfig } = require "./themes.coffee"
{ SmartImage, ImageLayout, ImageGrid, ImageComparison, ImageCarousel, ImageWithText } = require "./smart-image.coffee"
{ Animation, Transition, SlideAnimation, AnimationSequence, AnimatedSlide } = require "./animations.coffee"
{ PdfConfig, PdfHeader, PdfFooter, PdfWatermark, PdfExport } = require "./pdf-config.coffee"
{ ValidationError, ValidationResult, Validator, ErrorHandler, FallbackContent, ErrorSlide, RetryHandler, ErrorBoundary } = require "./error-handling.coffee"
{ Logger, ErrorLogger, AuditLogger } = require "./logging.coffee"
Errors = require "./error-types.coffee"

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

# ============================================
# ComparisonSlide - 对比页
# ============================================

class ComparisonSlide extends Slide
  @layout: "comparison"
  
  @toData: ->
    props = @getProperties()
    keys = Object.keys(props)
    leftKey = keys[0] or "方案A"
    rightKey = keys[1] or "方案B"
    leftValue = props[leftKey] or ""
    rightValue = props[rightKey] or ""
    type: "comparison"
    title: @getTitle()
    leftTitle: leftKey
    rightTitle: rightKey
    leftContent: leftValue
    rightContent: rightValue

class ImageSlide extends Slide
  @layout: "image"

# ============================================
# QuoteSlide - 引用页
# ============================================

class QuoteSlide extends Slide
  @layout: "quote"
  
  @toData: ->
    props = @getProperties()
    keys = Object.keys(props)
    values = Object.values(props)
    type: "quote"
    title: @getTitle()
    author: keys[0] or ""
    quote: values[0] or ""

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

class HospitalReview extends MermaidSlide
  @chart: CHARTS.hospitalReview

class DoctorPatient extends MermaidSlide
  @chart: CHARTS.doctorPatient

class Performance extends MermaidSlide
  @chart: CHARTS.performance

class Training extends MermaidSlide
  @chart: CHARTS.training

class Research extends MermaidSlide
  @chart: CHARTS.research

class TalentTeam extends MermaidSlide
  @chart: CHARTS.talentTeam

class Decision extends MermaidSlide
  @chart: CHARTS.decision

class Architecture extends MermaidSlide
  @chart: CHARTS.architecture

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
  @theme: "default"
  
  @generate: (baseName) ->
    name = baseName or @name or @constructor.name
    
    htmlPath = "outputs/#{name}.html"
    pdfPath = "outputs/#{name}.pdf"
    pptxPath = "outputs/#{name}.pptx"
    
    console.log "\n🚀 Generating: #{name}\n"
    
    Logger.info "Starting presentation generation", { name, theme: @theme }
    
    sections = if typeof @sections is 'function' then @sections() else @sections ? []
    
    validationResult = Validator.validatePresentation({ sections })
    unless validationResult.isValid()
      for warning in validationResult.getWarningMessages()
        Logger.warn "Validation warning: #{warning}"
      if validationResult.hasErrors()
        for error in validationResult.getErrorMessages()
          Logger.error "Validation error: #{error}"
    
    slides = []
    for section in sections
      slides.push(...section.getSlides())
    
    for slide, i in slides
      slideResult = Validator.validateSlide(slide.toData())
      unless slideResult.isValid()
        for warning in slideResult.getWarningMessages()
          Logger.warn "Slide #{i} warning: #{warning}"
    
    theme = getTheme(@theme)
    
    data = {
      title: name
      theme: theme
      slides: for slide in slides
        slide.toData()
    }
    
    try
      generateHtml(data, htmlPath)
      Logger.info "HTML generated successfully", { path: htmlPath }
    catch error
      Logger.error "HTML generation failed", { error: error.message }
      ErrorLogger.logError(error, { phase: "html", name })
    
    try
      htmlToPdf(htmlPath, pdfPath)
      Logger.info "PDF generated successfully", { path: pdfPath }
    catch error
      Logger.error "PDF generation failed", { error: error.message }
      ErrorLogger.logError(error, { phase: "pdf", name })
    
    try
      htmlToPptx(htmlPath, pptxPath)
      Logger.info "PPTX generated successfully", { path: pptxPath }
    catch error
      Logger.error "PPTX generation failed", { error: error.message }
      ErrorLogger.logError(error, { phase: "pptx", name })
    
    console.log "✅ Generated: #{pptxPath}\n"
    AuditLogger.log "presentation_generated", { name, formats: ["html", "pdf", "pptx"] }
  
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
  QuoteSlide
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
  HospitalReview
  DoctorPatient
  Performance
  Training
  Research
  TalentTeam
  Decision
  Architecture
  ComparisonSlide
  SWOTSlide
  TimelineSlide
  ProcessSlide
  CardSlide
  PyramidSlide
  Section
  Presentation
  CHARTS
  Theme
  Themes
  getTheme
  createCustomTheme
  getThemeColors
  getThemePptxConfig
  SmartImage
  ImageLayout
  ImageGrid
  ImageComparison
  ImageCarousel
  ImageWithText
  Animation
  Transition
  SlideAnimation
  AnimationSequence
  AnimatedSlide
  PdfConfig
  PdfHeader
  PdfFooter
  PdfWatermark
  PdfExport
  ValidationError
  ValidationResult
  Validator
  ErrorHandler
  FallbackContent
  ErrorSlide
  RetryHandler
  ErrorBoundary
  Logger
  ErrorLogger
  AuditLogger
  Errors
  createSlide
  createSlides
}
