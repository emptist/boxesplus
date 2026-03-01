# BoxesPlus - Media Demo
# Exploring addMedia for video/audio

PptxGenJS = require "pptxgenjs"
{ titleSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "Media Demo", subtitle: "Exploring addMedia", gradient: "blue"

# Media slide
slide2 = pres.addSlide()
slide2.addText "Media 示例", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# Syntax from pptxgenjs:
# slide.addMedia({
#   type: "video" | "audio"
#   path: "path/to/file.mp4"  # or url
#   x: 1, y: 1, w: 8, h: 4
# })

slide2.addText "addMedia 支持视频和音频", x: 1, y: 2, w: 8, h: 0.5, fontSize: 16
slide2.addText "用法: slide.addMedia({ type: 'video', path: 'video.mp4', x: 1, y: 1, w: 8, h: 4 })", 
  x: 1, y: 2.8, w: 8, h: 0.8, fontSize: 12, color: "666666"

# Save
pres.writeFile({ fileName: "outputs/demo-media.pptx" })
  .then -> console.log "✅ Created: outputs/demo-media.pptx"
  .catch (err) -> console.error err
