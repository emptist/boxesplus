# BoxesPlus - More Shapes Demo
# Exploring available shapes in PptxGenJS

PptxGenJS = require "pptxgenjs"
{ titleSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "More Shapes Demo", subtitle: "Available shapes", gradient: "blue"

# Basic shapes
slide2 = pres.addSlide()
slide2.addText "Basic Shapes", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

basicShapes = [
  { type: pres.ShapeType.rect, x: 0.5, name: "rect" }
  { type: pres.ShapeType.roundRect, x: 2, name: "roundRect" }
  { type: pres.ShapeType.ellipse, x: 3.5, name: "ellipse" }
  { type: pres.ShapeType.diamond, x: 5, name: "diamond" }
  { type: pres.ShapeType.triangle, x: 6.5, name: "triangle" }
]

for s in basicShapes
  slide2.addShape s.type,
    x: s.x, y: 1.2, w: 1.5, h: 1.5
    fill: { color: THEME.accent }

# Arrows
slide3 = pres.addSlide()
slide3.addText "Arrow Shapes", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

arrows = [
  { type: pres.ShapeType.rightArrow, name: "rightArrow" }
  { type: pres.ShapeType.leftArrow, name: "leftArrow" }
  { type: pres.ShapeType.upArrow, name: "upArrow" }
  { type: pres.ShapeType.downArrow, name: "downArrow" }
  { type: pres.ShapeType.bentArrow, name: "bentArrow" }
  { type: pres.ShapeType.quadArrow, name: "quadArrow" }
]

for a, i in arrows
  col = i % 3
  row = Math.floor(i / 3)
  slide3.addShape a.type,
    x: 0.5 + col * 3, y: 1.2 + row * 1.8, w: 2.5, h: 1.2
    fill: { color: THEME.success }

# Stars
slide4 = pres.addSlide()
slide4.addText "Star Shapes", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

stars = [
  { type: pres.ShapeType.star4, name: "star4" }
  { type: pres.ShapeType.star5, name: "star5" }
  { type: pres.ShapeType.star6, name: "star6" }
  { type: pres.ShapeType.star8, name: "star8" }
  { type: pres.ShapeType.pentagon, name: "pentagon" }
  { type: pres.ShapeType.hexagon, name: "hexagon" }
]

for s, i in stars
  col = i % 3
  row = Math.floor(i / 3)
  slide4.addShape s.type,
    x: 0.5 + col * 3, y: 1.2 + row * 1.8, w: 2.5, h: 1.5
    fill: { color: THEME.warning }

# Save
pres.writeFile({ fileName: "outputs/demo-shapes.pptx" })
  .then -> console.log "✅ Created: outputs/demo-shapes.pptx"
  .catch (err) -> console.error err
