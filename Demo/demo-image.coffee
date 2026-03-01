# BoxesPlus - Image Demo
# Using resources folder

PptxGenJS = require "pptxgenjs"
{ titleSlide, imageSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "Image Demo", subtitle: "Using resourses folder", gradient: "blue"

# Use images from resources folder (1, 10, 11, 12, 13, 14, 15 available)
imageSlide pres,
  title: "图片 1"
  path: "./resources/1.png"
  x: 0.5, y: 0.8, w: 9, h: 4

imageSlide pres,
  title: "图片 10"
  path: "./resources/10.png"
  x: 0.5, y: 0.8, w: 9, h: 4

imageSlide pres,
  title: "图片 11"
  path: "./resources/11.png"
  x: 0.5, y: 0.8, w: 9, h: 4

# Save
pres.writeFile({ fileName: "outputs/demo-image.pptx" })
  .then -> console.log "✅ Created: outputs/demo-image.pptx"
  .catch (err) -> console.error err
