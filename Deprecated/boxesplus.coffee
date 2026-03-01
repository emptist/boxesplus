# BoxesPlus - Convert Markdown to PPTX with styled boxes
# Using CoffeeScript + pptxgenjs

PptxGenJS = require "pptxgenjs"
fs = require "fs"

# Parse markdown and extract ASCII boxes
extractBoxes = (markdown) ->
  boxes = []
  pattern = /```\s*\n([\s\S]*?)\n```/g
  while match = pattern.exec markdown
    block = match[1]
    boxChars = {'┌', '┐', '└', '┘', '│', '─', '├', '┤', '┬', '┴', '┼'}
    hasBox = false
    for c in block
      if c of boxChars
        hasBox = true
        break
    if hasBox
      boxes.push block
  boxes

# Extract title from box content
extractTitle = (boxContent) ->
  lines = boxContent.split('\n')
  for line in lines
    clean = line.replace(/[│├┤]/g, '').trim()
    if clean and clean.length < 40
      return clean
  "内容"

# Create a slide with title
createTitleSlide = (pres, title) ->
  slide = pres.addSlide()
  slide.addText title,
    x: 0.5, y: 2, w: 9, h: 1
    fontSize: 36, color: "1a365d", align: "center"
  slide

# Create styled box on slide
createBoxSlide = (pres, boxContent, index) ->
  slide = pres.addSlide()
  
  title = extractTitle boxContent
  
  # Header bar
  slide.addShape pres.ShapeType.rect,
    x: 0.5, y: 0.5, w: 9, h: 0.8
    fill: { color: "2c5282" }
  
  slide.addText title,
    x: 0.7, y: 0.65, w: 8.6, h: 0.5
    fontSize: 20, color: "ffffff", bold: true
  
  # Content box
  slide.addShape pres.ShapeType.rect,
    x: 0.5, y: 1.5, w: 9, h: 4
    fill: { color: "f7fafc" }
    line: { color: "2c5282", width: 2 }
  
  # Extract and display content
  lines = boxContent.split('\n')
  yPos = 1.8
  for line in lines
    clean = line.replace(/[│├┤]/g, '').trim()
    if clean
      slide.addText clean,
        x: 0.8, y: yPos, w: 8.4, h: 0.4
        fontSize: 14, color: "2d3748"
      yPos += 0.5
      if yPos > 5
        break
  
  slide

# Main conversion function
convertToPptx = (inputFile, outputFile) ->
  # Read markdown file
  content = fs.readFileSync(inputFile, "utf-8")
  
  # Extract title
  titleMatch = content.match(/^# (.+)$/m)
  title = if titleMatch then titleMatch[1] else "Document"
  
  # Create presentation
  pres = new PptxGenJS()
  
  # Add title slide
  createTitleSlide pres, title
  
  # Extract and add boxes
  boxes = extractBoxes content
  console.log "Found #{boxes.length} boxes"
  
  for box in boxes
    createBoxSlide pres, box
  
  # Save
  pres.writeFile({ fileName: outputFile })
    .then -> console.log "Created: #{outputFile}"
    .catch (err) -> console.error err

# Export for use
module.exports = { extractBoxes, extractTitle, createTitleSlide, createBoxSlide, convertToPptx }

# Test if run directly
if require.main is module
  console.log "BoxesPlus CoffeeScript ready!"
  convertToPptx 'sources/C01医疗质量与安全管理课程详细教案.md', 'outputs/pptxgenjs/C01_coffee.pptx'
