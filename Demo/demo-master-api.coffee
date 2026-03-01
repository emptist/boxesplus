# BoxesPlus - Slide Master Demo (API approach)
# Using defineMaster and masterSlide

PptxGenJS = require "pptxgenjs"
{ titleSlide, defineMaster, masterSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# Define a master
defineMaster pres,
  name: "BlueTheme"
  background: { color: THEME.primary }
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

# Title slide (regular)
titleSlide pres, title: "Slide Master Demo", subtitle: "Using API", gradient: "blue"

# Use master
masterSlide pres,
  masterName: "BlueTheme"
  title: "Master 幻灯片 1"
  body: "这是第一张使用 Master 的幻灯片"

masterSlide pres,
  masterName: "BlueTheme"
  title: "Master 幻灯片 2"
  body: "这是第二张使用 Master 的幻灯片"

# Save
pres.writeFile({ fileName: "outputs/demo-master-api.pptx" })
  .then -> console.log "✅ Created: outputs/demo-master-api.pptx"
  .catch (err) -> console.error err
