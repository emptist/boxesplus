# BoxesPlus - Layout & Theme Demo
# Exploring defineLayout and Theme

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# Custom layout (16x9 is default, can define custom)
pres.defineLayout({ name: 'Custom', width: 13.33, height: 7.5 })
pres.layout = 'Custom'

titleSlide pres, title: "Custom Layout", subtitle: "13.33 x 7.5", gradient: "blue"

# Slide with slide number
slide3 = pres.addSlide()
slide3.addText "Slide Number 示例", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true
slide3.addText "右下角页码", x: 0.5, y: 2, w: 9, h: 0.5, fontSize: 16
slide3.slideNumber = { x: "95%", y: "95%", fontSize: 10, color: "666666" }

# Using transparency
slide4 = pres.addSlide()
slide4.addText "Transparency 示例", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

slide4.addShape pres.ShapeType.rect,
  x: 0.5, y: 1.2, w: 3, h: 2
  fill: { color: THEME.accent, transparency: 0 }  # 不透明

slide4.addShape pres.ShapeType.rect,
  x: 4, y: 1.2, w: 3, h: 2
  fill: { color: THEME.accent, transparency: 30 }  # 30% 透明

slide4.addShape pres.ShapeType.rect,
  x: 7.5, y: 1.2, w: 2, h: 2
  fill: { color: THEME.accent, transparency: 60 }  # 60% 透明

slide4.addText "透明度: 0% / 30% / 60%", x: 0.5, y: 3.5, w: 9, h: 0.5

# Save
pres.writeFile({ fileName: "outputs/demo-layout.pptx" })
  .then -> console.log "✅ Created: outputs/demo-layout.pptx"
  .catch (err) -> console.error err
