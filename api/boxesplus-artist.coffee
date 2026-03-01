# BoxesPlus Artist v2 - 艺术 PPTX 生成器

PptxGenJS = require "pptxgenjs"

THEME =
  primary: "1a365d"
  secondary: "2c5282"
  accent: "3182ce"
  success: "38a169"
  warning: "d69e2e"
  danger: "e53e3e"
  light: "f7fafc"
  dark: "1a202c"
  text: "2d3748"
  muted: "718096"

GRADIENTS =
  blue: ["#2c5282", "#1a365d"]
  green: ["#38a169", "#276749"]
  purple: ["#805ad5", "#553c9a"]

titleSlide = (pres, opts) ->
  { title, subtitle, gradient, slideNumber } = opts
  slide = pres.addSlide()
  
  if gradient
    [c1] = GRADIENTS[gradient] || [THEME.dark]
    slide.background = { type: "solid", color: c1 }
  
  if title
    slide.addText title,
      x: 0.5, y: 2, w: 9, h: 1.5
      fontSize: 44, color: "ffffff", bold: true, align: "center"
  
  if subtitle
    slide.addText subtitle,
      x: 1, y: 4, w: 8, h: 0.8
      fontSize: 20, color: "ffffff", align: "center", transparency: 20

  if slideNumber isnt false
    slide.slideNumber = { x: "95%", y: "95%", fontSize: 10, color: "ffffff" }
  
  slide

listSlide = (pres, opts) ->
  { title, items, slideNumber } = opts
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, color: THEME.primary, bold: true
  
  y = 1.2
  for item, i in items
    slide.addShape pres.ShapeType.rect,
      x: 0.6, y: y, w: 0.4, h: 0.4
      fill: { color: THEME.secondary }
    
    slide.addText "#{i + 1}",
      x: 0.6, y: y + 0.05, w: 0.4, h: 0.3
      fontSize: 12, color: "ffffff", align: "center"
    
    slide.addText item,
      x: 1.2, y: y, w: 8, h: 0.5
      fontSize: 16, color: THEME.text
    
    y += 0.6

  if slideNumber isnt false
    slide.slideNumber = { x: "95%", y: "95%", fontSize: 10, color: "666666" }
  
  slide

listSlide = (pres, opts) ->
  { title, items } = opts
  slide = pres.addSlide()
  
  # 标题
  slide.addText title,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, color: THEME.primary, bold: true
  
  y = 1.2
  for item, i in items
    slide.addShape pres.ShapeType.rect,
      x: 0.6, y: y, w: 0.4, h: 0.4
      fill: { color: THEME.secondary }
    
    slide.addText "#{i + 1}",
      x: 0.6, y: y + 0.05, w: 0.4, h: 0.3
      fontSize: 12, color: "ffffff", align: "center"
    
    slide.addText item,
      x: 1.2, y: y, w: 8, h: 0.5
      fontSize: 16, color: THEME.text
    
    y += 0.6
  
  slide

cardSlide = (pres, opts) ->
  { title, cards, columns: cols = 2, slideNumber } = opts
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, color: THEME.primary, bold: true
  
  cardW = 4.2
  cardH = 2.5
  gap = 0.3
  startX = 0.5
  startY = 1.2
  
  for card, i in cards
    col = i % cols
    row = Math.floor(i / cols)
    
    x = startX + col * (cardW + gap)
    y = startY + row * (cardH + gap)
    
    slide.addShape pres.ShapeType.rect,
      x: x, y: y, w: cardW, h: cardH
      fill: { color: THEME.light }
      line: { color: THEME.secondary, width: 1 }
    
    if card.title
      slide.addText card.title,
        x: x + 0.2, y: y + 0.3, w: cardW - 0.4, h: 0.5
        fontSize: 16, bold: true, color: THEME.primary
    
    if card.content
      slide.addText card.content,
        x: x + 0.2, y: y + 0.9, w: cardW - 0.4, h: cardH - 1.2
        fontSize: 12, color: THEME.text

  slide

tableSlide = (pres, opts) ->
  { title, headers, rows } = opts
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, color: THEME.primary, bold: true
  
  return unless headers and headers.length > 0
  
  x = 0.5
  y = 1.2
  colW = 9 / headers.length
  rowH = 0.5
  
  # 表头
  slide.addShape pres.ShapeType.rect,
    x: x, y: y, w: 9, h: rowH
    fill: { color: THEME.secondary }
  
  for header, i in headers
    slide.addText header,
      x: x + i * colW + 0.1, y: y + 0.1, w: colW - 0.2, h: rowH - 0.2
      fontSize: 14, color: "ffffff", bold: true
  
  y += rowH
  
  # 数据行
  for row, ri in rows
    bgColor = if ri % 2 == 0 then THEME.light else "ffffff"
    
    slide.addShape pres.ShapeType.rect,
      x: x, y: y, w: 9, h: rowH
      fill: { color: bgColor }
    
    for cell, i in row
      slide.addText cell,
        x: x + i * colW + 0.1, y: y + 0.1, w: colW - 0.2, h: rowH - 0.2
        fontSize: 12, color: THEME.text
    
    y += rowH

  slide

quoteSlide = (pres, opts) ->
  { quote, author } = opts
  slide = pres.addSlide()
  
  slide.addShape pres.ShapeType.rect,
    x: 0, y: 0, w: 10, h: 5.5
    fill: { color: THEME.primary }
  
  slide.addText '"' + quote + '"',
    x: 1, y: 1.8, w: 8, h: 2
    fontSize: 24, color: "ffffff", italic: true, align: "center"
  
  if author
    slide.addText "— #{author}",
      x: 1, y: 4, w: 8, h: 0.5
      fontSize: 16, color: "ffffff", align: "right"

  slide

comparisonSlide = (pres, opts) ->
  { title, left, right } = opts
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, color: THEME.primary, bold: true
  
  # 左侧
  slide.addShape pres.ShapeType.rect,
    x: 0.3, y: 1.2, w: 4.5, h: 4
    fill: { color: THEME.light }
    line: { color: THEME.secondary, width: 2 }
  
  slide.addText left.title || "优点",
    x: 0.5, y: 1.4, w: 4, h: 0.5
    fontSize: 18, color: THEME.success, bold: true
  
  if left.items
    y = 2
    for item in left.items
      slide.addText "✓ #{item}",
        x: 0.5, y: y, w: 4, h: 0.4
        fontSize: 14, color: THEME.text
      y += 0.5
  
  # 右侧
  slide.addShape pres.ShapeType.rect,
    x: 5.2, y: 1.2, w: 4.5, h: 4
    fill: { color: THEME.light }
    line: { color: THEME.danger, width: 2 }
  
  slide.addText right.title || "缺点",
    x: 5.4, y: 1.4, w: 4, h: 0.5
    fontSize: 18, color: THEME.danger, bold: true
  
  if right.items
    y = 2
    for item in right.items
      slide.addText "✗ #{item}",
        x: 5.4, y: y, w: 4, h: 0.4
        fontSize: 14, color: THEME.text
      y += 0.5

  slide

timelineSlide = (pres, opts) ->
  { title, events } = opts
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.3, w: 9, h: 0.7
    fontSize: 28, color: THEME.primary, bold: true
  
  y = 1.5
  for event, i in events
    slide.addShape pres.ShapeType.rect,
      x: 1, y: y, w: 0.4, h: 0.4
      fill: { color: THEME.accent }
    
    if i < events.length - 1
      slide.addShape pres.ShapeType.rect,
        x: 1.2, y: y + 0.4, w: 0.05, h: 0.8
        fill: { color: THEME.accent }
    
    if event.date
      slide.addText event.date,
        x: 1.6, y: y, w: 2, h: 0.3
        fontSize: 12, color: THEME.muted
    
    if event.title
      slide.addText event.title,
        x: 1.6, y: y + 0.3, w: 7, h: 0.4
        fontSize: 16, bold: true, color: THEME.primary
    
    if event.desc
      slide.addText event.desc,
        x: 1.6, y: y + 0.7, w: 7, h: 0.5
        fontSize: 12, color: THEME.text
    
    y += 1.3

  slide

# ============ Chart Functions ============

# Generic chart slide - takes chart type as parameter
chartSlide = (pres, opts) ->
  { title, subtitle, data, type = "BAR", slideNumber } = opts
  slide = pres.addSlide()
  
  if title
    slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: THEME.primary, bold: true
  
  chartType = pres.ChartType[type] ? pres.ChartType.BAR
  
  if type is "PIE" or type is "DOUGHNUT"
    slide.addChart chartType, data, x: 1.5, y: 1, w: 7, h: 4, title: subtitle ? ""
  else if type is "RADAR"
    slide.addChart chartType, data, x: 1, y: 1, w: 8, h: 4, title: subtitle ? ""
  else
    slide.addChart chartType, data, x: 0.5, y: 1, w: 9, h: 4, title: subtitle ? ""

  if slideNumber isnt false
    slide.slideNumber = { x: "95%", y: "95%", fontSize: 10, color: "666666" }

  slide

barChartSlide = (pres, opts) ->
  { title, data, subtitle } = opts
  slide = pres.addSlide()
  
  if title
    slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: THEME.primary, bold: true
  
  slide.addChart pres.ChartType.BAR, data,
    x: 0.5, y: 1, w: 9, h: 4
    title: subtitle ? ""

  slide

lineChartSlide = (pres, opts) ->
  { title, data, subtitle } = opts
  slide = pres.addSlide()
  
  if title
    slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: THEME.primary, bold: true
  
  slide.addChart pres.ChartType.LINE, data,
    x: 0.5, y: 1, w: 9, h: 4
    title: subtitle ? ""

  slide

pieChartSlide = (pres, opts) ->
  { title, data, subtitle } = opts
  slide = pres.addSlide()
  
  if title
    slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: THEME.primary, bold: true
  
  slide.addChart pres.ChartType.PIE, data,
    x: 1.5, y: 1, w: 7, h: 4
    title: subtitle ? ""

  slide

radarChartSlide = (pres, opts) ->
  { title, data, subtitle } = opts
  slide = pres.addSlide()
  
  if title
    slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: THEME.primary, bold: true
  
  slide.addChart pres.ChartType.RADAR, data,
    x: 1, y: 1, w: 8, h: 4
    title: subtitle ? ""

  slide

# Image slide function
imageSlide = (pres, opts) ->
  { title, path, x: imgX = 1, y: imgY = 1, w: imgW = 8, h: imgH = 4 } = opts
  slide = pres.addSlide()
  
  if title
    slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: THEME.primary, bold: true
  
  if path
    slide.addImage
      path: path
      x: imgX
      y: imgY
      w: imgW
      h: imgH

  slide

# ============ Media Functions ============

mediaSlide = (pres, opts) ->
  { title, path, type = "video", x: imgX = 1, y: imgY = 1, w: imgW = 8, h: imgH = 4 } = opts
  slide = pres.addSlide()
  
  if title
    slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: THEME.primary, bold: true
  
  if path
    slide.addMedia
      type: type
      path: path
      x: imgX
      y: imgY
      w: imgW
      h: imgH

  slide

# ============ Master Slide Functions ============

defineMaster = (pres, opts) ->
  { name, background, slideNumber, objects } = opts
  pres.defineSlideMaster
    title: name
    background: background ? { color: THEME.primary }
    slideNumber: slideNumber ? { x: "95%", y: "95%", fontSize: 10, color: "ffffff" }
    objects: objects

masterSlide = (pres, opts) ->
  { masterName, title, body } = opts
  slide = pres.addSlide({ masterName: masterName })
  
  if title
    slide.addText title, options: { name: "title" }
  if body
    slide.addText body, options: { name: "body" }
  
  slide

endSlide = (pres, opts) ->
  { title, subtitle } = opts
  slide = pres.addSlide()
  slide.background = { type: "solid", color: THEME.dark }
  
  if title
    slide.addText title,
      x: 0.5, y: 2, w: 9, h: 1
      fontSize: 40, color: "ffffff", bold: true, align: "center"
  
  if subtitle
    slide.addText subtitle,
      x: 0.5, y: 3.2, w: 9, h: 0.6
      fontSize: 18, color: "ffffff", align: "center"

  slide

module.exports = {
  titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, comparisonSlide, timelineSlide, endSlide
  chartSlide, barChartSlide, lineChartSlide, pieChartSlide, radarChartSlide
  imageSlide, mediaSlide
  defineMaster, masterSlide
  THEME, GRADIENTS
}
