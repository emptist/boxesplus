# BoxesPlus Artist v3 - 修复图表格式

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

# 柱状图
barChartSlide = (pres, opts) ->
  { title, categories, series } = opts
  
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.2, w: 9, h: 0.6
    fontSize: 24, color: THEME.primary, bold: true
  
  # 正确的格式
  chartData = [
    {
      name: "2023年"
      labels: categories
      values: series[0].values
    }
    {
      name: "2024年"
      labels: categories  
      values: series[1].values
    }
  ]
  
  slide.addChart pres._charts.BAR,
    chartData
    x: 0.5, y: 1, w: 9, h: 4.5
    chartColors: [THEME.accent, THEME.success]
    showLegend: true
    showValue: true

  slide

# 饼图
pieChartSlide = (pres, opts) ->
  { title, values, labels } = opts
  
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.2, w: 9, h: 0.6
    fontSize: 24, color: THEME.primary, bold: true
  
  chartData = [
    name: "收入"
    labels: labels
    values: values
  ]
  
  slide.addChart pres._charts.PIE,
    chartData
    x: 2, y: 1, w: 6, h: 4
    chartColors: [THEME.primary, THEME.accent, THEME.success, THEME.warning, THEME.danger]
    showPercent: true

  slide

# 折线图
lineChartSlide = (pres, opts) ->
  { title, categories, series } = opts
  
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.2, w: 9, h: 0.6
    fontSize: 24, color: THEME.primary, bold: true
  
  chartData = series.map (s, i) ->
    {
      name: s.name
      labels: categories
      values: s.values
    }
  
  slide.addChart pres._charts.LINE,
    chartData
    x: 0.5, y: 1, w: 9, h: 4.5
    showLegend: true
    showValue: true

  slide

# 雷达图
radarChartSlide = (pres, opts) ->
  { title, categories, series } = opts
  
  slide = pres.addSlide()
  
  slide.addText title,
    x: 0.5, y: 0.2, w: 9, h: 0.6
    fontSize: 24, color: THEME.primary, bold: true
  
  chartData = series.map (s) ->
    {
      name: s.name
      labels: categories
      values: s.values
    }
  
  slide.addChart pres._charts.RADAR,
    chartData
    x: 2, y: 1, w: 6, h: 4
    showLegend: true

  slide

# 标题页
titleSlide = (pres, opts) ->
  { title, subtitle, gradient } = opts
  slide = pres.addSlide()
  
  colors = { blue: THEME.primary, green: THEME.success, purple: THEME.danger }
  bg = colors[gradient] || THEME.dark
  
  slide.background = { type: "solid", color: bg }
  
  if title
    slide.addText title,
      x: 0.5, y: 2.5, w: 9, h: 1.5
      fontSize: 44, color: "ffffff", bold: true, align: "center"
  
  if subtitle
    slide.addText subtitle,
      x: 1, y: 4, w: 8, h: 0.8
      fontSize: 20, color: "ffffff", align: "center"

  slide

# 列表
listSlide = (pres, opts) ->
  { title, items } = opts
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

  slide

# 结束
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
  barChartSlide, pieChartSlide, lineChartSlide, radarChartSlide
  titleSlide, listSlide, endSlide, THEME
}
