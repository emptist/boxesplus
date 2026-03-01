# BoxesPlus - Slide Master Demo
# Exploring defineSlideMaster

PptxGenJS = require "pptxgenjs"
{ titleSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# Define a slide master
pres.defineSlideMaster
  title: "MyMaster"
  background: { color: THEME.primary }
  slideNumber: { x: "95%", y: "95%", fontSize: 10, color: "ffffff" }
  objects: [
    {
      placeholder:
        options:
          name: "title"
          type: "title"
          x: 0.5, y: 0.3, w: 9, h: 0.8
          fontSize: 32, color: "ffffff", bold: true
    }
    {
      placeholder:
        options:
          name: "body"
          type: "body"
          x: 0.5, y: 1.3, w: 9, h: 4
          fontSize: 18, color: "ffffff"
    }
  ]

# Use master - slide with masterName
slide1 = pres.addSlide({ masterName: "MyMaster" })
slide1.addText "使用 Slide Master 的标题", options: { name: "title" }
slide1.addText "这是正文内容，使用了Master的样式", options: { name: "body" }

# Regular slide without master
titleSlide pres, title: "普通幻灯片", subtitle: "不使用Master", gradient: "blue"

# Another master slide
slide2 = pres.addSlide({ masterName: "MyMaster" })
slide2.addText "第二张 Master 幻灯片", options: { name: "title" }
slide2.addText "内容区域可以自定义", options: { name: "body" }

# Save
pres.writeFile({ fileName: "outputs/demo-slide-master.pptx" })
  .then -> console.log "✅ Created: outputs/demo-slide-master.pptx"
  .catch (err) -> console.error err
