#!/usr/bin/env coffee

# JSON to PPTX Generator
# Reads JSON course definition and generates PPTX using boxesplus-artist API

fs = require "fs"
path = require "path"
PptxGenJS = require "pptxgenjs"
{
  titleSlide, listSlide, cardSlide, tableSlide, quoteSlide,
  comparisonSlide, timelineSlide, endSlide, sectionSlide,
  chartSlide, barChartSlide, pieChartSlide,
  THEME, GRADIENTS
} = require "../api/boxesplus-artist.coffee"

# Slide type handlers
slideHandlers =
  title: (pres, opts) ->
    titleSlide pres, opts
  
  list: (pres, opts) ->
    listSlide pres, opts
  
  card: (pres, opts) ->
    cardSlide pres, opts
  
  table: (pres, opts) ->
    tableSlide pres, opts
  
  quote: (pres, opts) ->
    quoteSlide pres, opts
  
  comparison: (pres, opts) ->
    comparisonSlide pres, opts
  
  timeline: (pres, opts) ->
    timelineSlide pres, opts
  
  section: (pres, opts) ->
    sectionSlide pres, opts
  
  end: (pres, opts) ->
    endSlide pres, opts
  
  barChart: (pres, opts) ->
    barChartSlide pres, opts
  
  pieChart: (pres, opts) ->
    pieChartSlide pres, opts
  
  chart: (pres, opts) ->
    chartSlide pres, opts

# Generate PPTX from JSON
generateFromJSON = (jsonPath, outputPath) ->
  # Read JSON file
  unless fs.existsSync(jsonPath)
    console.error "❌ JSON file not found: #{jsonPath}"
    process.exit 1
  
  content = fs.readFileSync(jsonPath, "utf-8")
  
  try
    course = JSON.parse(content)
  catch err
    console.error "❌ Invalid JSON: #{err.message}"
    process.exit 1
  
  # Create presentation
  pres = new PptxGenJS()
  pres.layout = "LAYOUT_16x9"
  
  # Set metadata
  if course.meta
    pres.title = course.meta.title || "Course"
    pres.author = course.meta.author || ""
    pres.subject = course.meta.subtitle || ""
  
  # Process slides
  slides = course.slides || []
  totalSlides = slides.length
  
  console.log "📄 Processing #{totalSlides} slides..."
  
  for slide, index in slides
    type = slide.type
    handler = slideHandlers[type]
    
    if handler
      console.log "  [#{index + 1}/#{totalSlides}] #{type}: #{slide.title || 'Untitled'}"
      handler(pres, slide)
    else
      console.warn "  ⚠️ Unknown slide type: #{type}"
  
  # Save file
  outputPath = outputPath || jsonPath.replace(".json", ".pptx")
  
  pres.writeFile({ fileName: outputPath })
    .then ->
      console.log "✅ Created: #{outputPath}"
      console.log "   Total slides: #{totalSlides}"
    .catch (err) ->
      console.error "❌ Error: #{err.message}"
      process.exit 1

# CLI usage
main = ->
  args = process.argv.slice(2)
  
  if args.length == 0
    console.log "Usage: coffee json-to-pptx.coffee <input.json> [output.pptx]"
    console.log ""
    console.log "Examples:"
    console.log "  coffee json-to-pptx.coffee course.json"
    console.log "  coffee json-to-pptx.coffee course.json output.pptx"
    process.exit 0
  
  jsonPath = args[0]
  outputPath = args[1] || null
  
  generateFromJSON(jsonPath, outputPath)

main()
