# BoxesPlus - Media API Demo
# Using mediaSlide function

PptxGenJS = require "pptxgenjs"
{ titleSlide, mediaSlide, imageSlide } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "Media API Demo", subtitle: "Video & Image", gradient: "blue"

# Video slide
mediaSlide pres,
  title: "视频示例"
  path: "./resources/media_sample.mp4"
  type: "video"
  x: 1, y: 1, w: 8, h: 4

# Image slide
imageSlide pres,
  title: "图片示例"
  path: "./resources/1.png"
  x: 0.5, y: 0.8, w: 9, h: 4

# Save
pres.writeFile({ fileName: "outputs/demo-media-api.pptx" })
  .then -> console.log "✅ Created: outputs/demo-media-api.pptx"
  .catch (err) -> console.error err
