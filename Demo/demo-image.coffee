# BoxesPlus - Image Demo
# Exploring addImage functionality

PptxGenJS = require "pptxgenjs"
{ titleSlide, imageSlide, chartSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "Image Demo", subtitle: "Exploring addImage", gradient: "blue"

# Image slide using API - use correct path from boxesplus/
imageSlide pres,
  title: "图片示例"
  path: "../pngs/上海市同仁医院战略规划（12.24）_slide_002.png"
  x: 0.5
  y: 1
  w: 9
  h: 4

# Another image
imageSlide pres,
  title: "第二张图片"
  path: "../pngs/苍南县人民医院品牌建设诊断报告-打印版_slide_001.png"
  x: 1
  y: 1
  w: 8
  h: 4

# Save
pres.writeFile({ fileName: "outputs/demo-image.pptx" })
  .then -> console.log "✅ Created: outputs/demo-image.pptx"
  .catch (err) -> console.error err
