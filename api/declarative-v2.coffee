# BoxesPlus - Declarative API v2
# 5-level hierarchy: Presentation -> Section -> Chapter -> Node -> Slide
# Unified @including array, class name as title

{ generateHtml, htmlToPdf, htmlToPptx, CHARTS } = require "./hybrid-generator.coffee"
{ Theme, Themes, getTheme, createCustomTheme } = require "./themes.coffee"
{ SmartImage, ImageLayout, ImageGrid, ImageComparison, ImageCarousel, ImageWithText } = require "./smart-image.coffee"
{ Animation, Transition, SlideAnimation } = require "./animations.coffee"
{ PdfConfig, PdfHeader, PdfFooter, PdfWatermark, PdfExport } = require "./pdf-config.coffee"
{ ValidationError, ValidationResult, Validator, ErrorHandler, FallbackContent, ErrorSlide, RetryHandler, ErrorBoundary } = require "./error-handling.coffee"
{ Logger, ErrorLogger, AuditLogger } = require "./logging.coffee"
Errors = require "./error-types.coffee"

# ============================================
# Base Item - 所有级别的基类
# ============================================

class Item
  @layout: "default"
  @style: "default"
  @including: []
  @theme: "default"
  
  @getTitle: -> @name or @constructor.name
  
  @toData: ->
    type: @layout
    title: @getTitle()
    style: @style

  @getIncluding: ->
    if typeof @including is 'function' then @including() else @including ? []

  @flatten: (items = []) ->
    including = @getIncluding()
    for item in (including ? [])
      hasGetIncluding = item?.getIncluding?
      hasToData = item?.toData?
      
      # Check if item has nested content
      if hasGetIncluding
        nestedIncluding = item.getIncluding()
        if nestedIncluding and nestedIncluding.length > 0
          # Has nested content, recurse
          item.flatten(items)
        else
          # No nested content, treat as slide
          if hasToData
            items.push(item)
      else if hasToData
        items.push(item)
    items

# ============================================
# Slide - 最小级别
# ============================================

class Slide extends Item
  @layout: "content"
  @content: {}
  
  @toData: ->
    props = @getProperties()
    type: @layout
    title: @getTitle()
    style: @style
    items: Object.values(props)
    properties: props

  @getProperties: ->
    props = {}
    for key, value of this
      unless key in ['name', 'length', 'prototype', 'toData', 'getProperties', 'getTitle', 'getIncluding', 'flatten', 'layout', 'style', 'including', 'theme', 'content', 'chart']
        props[key] = value
    props

# ============================================
# Node - 可以包含 Slide
# ============================================

class Node extends Item
  @layout: "node"
  @style: "card"

# ============================================
# Chapter - 可以包含 Node 或 Slide
# ============================================

class Chapter extends Item
  @layout: "chapter"
  @style: "section"

# ============================================
# Section - 可以包含 Chapter, Node 或 Slide
# ============================================

class Section extends Item
  @layout: "section"
  @style: "section"

# ============================================
# Presentation - 最高级别，可以包含任何
# ============================================

class Presentation extends Item
  @layout: "presentation"
  @style: "presentation"
  @theme: "default"
  @author: ""
  @date: ""
  
  @generate: (baseName) ->
    name = baseName or @name or @constructor.name
    
    htmlPath = "outputs/#{name}.html"
    pdfPath = "outputs/#{name}.pdf"
    pptxPath = "outputs/#{name}.pptx"
    
    console.log "\n🚀 Generating: #{name}\n"
    
    Logger.info "Starting presentation generation", { name, theme: @theme }
    
    # 获取所有内容并展平为幻灯片
    allItems = []
    @flatten(allItems)
    
    slidesData = for item in allItems
      item.toData()
    
    theme = getTheme(@theme)
    
    data = {
      title: name
      theme: theme
      author: @author
      date: @date
      slides: slidesData
    }
    
    # 生成各格式
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
    AuditLogger.log "presentation_generated", { name, formats: ["html", "pdf", "pptx"], slideCount: slidesData.length }
  
  @newPresentation: ->
    setImmediate => @generate()

# ============================================
# 预设样式 Slide 子类
# ============================================

class TitleSlide extends Slide
  @layout: "title"
  @style: "title"
  @subtitle: ""

class ContentSlide extends Slide
  @layout: "content"
  @style: "content"

class ListSlide extends Slide
  @layout: "list"
  @style: "list"

class TwoColSlide extends Slide
  @layout: "two-col"
  @style: "two-col"
  @leftTitle: "左侧"
  @rightTitle: "右侧"
  @leftItems: []
  @rightItems: []

class ComparisonSlide extends Slide
  @layout: "comparison"
  @style: "comparison"

class QuoteSlide extends Slide
  @layout: "quote"
  @style: "quote"

class ImageSlide extends Slide
  @layout: "image"
  @style: "image"

class CardSlide extends Slide
  @layout: "card"
  @style: "card"

class TableSlide extends Slide
  @layout: "table"
  @style: "table"

# ============================================
# Mermaid 图表 Slide
# ============================================

class MermaidSlide extends Slide
  @layout: "mermaid"
  @style: "mermaid"
  @scale: "0.9"
  @chart: null

class FlowchartSlide extends MermaidSlide
  @chart: null

class PDCA extends MermaidSlide
  @layout: "pdca"
  @chart: CHARTS.pdca

class Pareto extends MermaidSlide
  @layout: "pareto"
  @chart: CHARTS.pareto

class SWOT extends MermaidSlide
  @layout: "swot"
  @chart: CHARTS.swot

class Timeline extends MermaidSlide
  @layout: "timeline"
  @chart: CHARTS.timeline

class Gantt extends MermaidSlide
  @layout: "gantt"
  @chart: CHARTS.ganttSimple

class Mindmap extends MermaidSlide
  @layout: "mindmap"
  @chart: CHARTS.mindmap

class EventLoop extends MermaidSlide
  @layout: "eventLoop"
  @chart: CHARTS.eventLoop

class DataLifecycle extends MermaidSlide
  @layout: "dataLifecycle"
  @chart: CHARTS.dataLifecycle

class BrandPyramid extends MermaidSlide
  @layout: "brandPyramid"
  @chart: CHARTS.brandPyramid

class QualitySystem extends MermaidSlide
  @layout: "qualitySystem"
  @chart: CHARTS.qualitySystem

class PatientSafety extends MermaidSlide
  @layout: "patientSafety"
  @chart: CHARTS.patientSafety

class Surgery extends MermaidSlide
  @layout: "surgery"
  @chart: CHARTS.surgery

class Evaluation extends MermaidSlide
  @layout: "evaluation"
  @chart: CHARTS.evaluation

class HospitalReview extends MermaidSlide
  @layout: "hospitalReview"
  @chart: CHARTS.hospitalReview

class DoctorPatient extends MermaidSlide
  @layout: "doctorPatient"
  @chart: CHARTS.doctorPatient

class Performance extends MermaidSlide
  @layout: "performance"
  @chart: CHARTS.performance

class Training extends MermaidSlide
  @layout: "training"
  @chart: CHARTS.training

class Research extends MermaidSlide
  @layout: "research"
  @chart: CHARTS.research

class TalentTeam extends MermaidSlide
  @layout: "talentTeam"
  @chart: CHARTS.talentTeam

class Decision extends MermaidSlide
  @layout: "decision"
  @chart: CHARTS.decision

class Architecture extends MermaidSlide
  @layout: "architecture"
  @chart: CHARTS.architecture

# ============================================
# 便捷函数
# ============================================

createItems = (itemClass, dataArray) ->
  for data in dataArray
    class extends itemClass
      for key, value of data
        Object.defineProperty @prototype, key,
          get: -> value

# ============================================
# 导出
# ============================================

module.exports = {
  Item
  Slide
  Node
  Chapter
  Section
  Presentation
  TitleSlide
  ContentSlide
  ListSlide
  TwoColSlide
  ComparisonSlide
  QuoteSlide
  ImageSlide
  CardSlide
  TableSlide
  MermaidSlide
  FlowchartSlide
  PDCA
  Pareto
  SWOT
  Timeline
  Gantt
  Mindmap
  EventLoop
  DataLifecycle
  BrandPyramid
  QualitySystem
  PatientSafety
  Surgery
  Evaluation
  HospitalReview
  DoctorPatient
  Performance
  Training
  Research
  TalentTeam
  Decision
  Architecture
  CHARTS
  Theme
  Themes
  getTheme
  createCustomTheme
  createItems
  Logger
  ErrorLogger
  AuditLogger
  Errors
  Validator
  ErrorHandler
  FallbackContent
}
