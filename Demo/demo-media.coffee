# BoxesPlus - Media Demo
# Exploring addMedia for video/audio

PptxGenJS = require "pptxgenjs"
{ titleSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "Media Demo", subtitle: "Video in PPTX", gradient: "blue"

# Video slide
slide2 = pres.addSlide()
slide2.addText "Video 示例", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# Add video from resources
slide2.addMedia
  type: "video"
  path: "./resources/media_sample.mp4"
  x: 1
  y: 1
  w: 8
  h: 4

# Save
pres.writeFile({ fileName: "outputs/demo-media.pptx" })
  .then -> console.log "✅ Created: outputs/demo-media.pptx"
  .catch (err) -> console.error err
