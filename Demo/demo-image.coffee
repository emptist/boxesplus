# BoxesPlus - Image Demo
# Exploring addImage functionality

PptxGenJS = require "pptxgenjs"
{ titleSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "Image Demo", subtitle: "Exploring addImage", gradient: "blue"

# Image slide
slide2 = pres.addSlide()
slide2.addText "Image 示例", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# Try adding image - requires actual image file
# slide2.addImage({ path: "path/to/image.png", x: 1, y: 1, w: 8, h: 4 })

slide2.addText "addImage 需要实际图片文件", x: 1, y: 2, w: 8, h: 0.5, fontSize: 16, color: "666666", align: "center"

# Syntax from pptxgenjs:
# slide.addImage({
#   path: "image.png",           # file path
#   x: 1, y: 1, w: 8, h: 4,    # position and size
#   sizing: { type: "contain", w: 8, h: 4 }  # optional sizing
# })

# Save (without actual image for now)
pres.writeFile({ fileName: "outputs/demo-image.pptx" })
  .then -> console.log "✅ Created: outputs/demo-image.pptx"
  .catch (err) -> console.error err
