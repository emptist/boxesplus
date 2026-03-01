# BoxesPlus - Advanced Chart Options Demo
# Exploring chart customization

PptxGenJS = require "pptxgenjs"
{ titleSlide, chartSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "Advanced Chart Options", subtitle: "Legend, Colors, Grid", gradient: "blue"

# Chart with legend
slide2 = pres.addSlide()
slide2.addText "Chart with Legend", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

data = [
  { name: "内科", values: [85, 88, 92, 90], labels: ["Q1", "Q2", "Q3", "Q4"] }
  { name: "外科", values: [82, 85, 89, 94] }
  { name: "妇产科", values: [90, 91, 93, 95] }
]

slide2.addChart pres.ChartType.BAR, data,
  x: 0.5, y: 1, w: 9, h: 4
  title: "With Legend (default)"
  showLegend: true
  legendPos: "b"

# Chart without legend
slide3 = pres.addSlide()
slide3.addText "Chart without Legend", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

slide3.addChart pres.ChartType.BAR, data,
  x: 0.5, y: 1, w: 9, h: 4
  title: "No Legend"
  showLegend: false

# Chart with vertical bar
slide4 = pres.addSlide()
slide4.addText "Horizontal Bar Chart", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

slide4.addChart pres.ChartType.BAR, data,
  x: 0.5, y: 1, w: 9, h: 4
  title: "Horizontal Bars"
  barDir: "bar"

# Line chart with markers
slide5 = pres.addSlide()
slide5.addText "Line Chart Options", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

lineData = [
  { name: "2023", values: [75, 78, 82, 85], labels: ["Q1", "Q2", "Q3", "Q4"] }
  { name: "2024", values: [80, 84, 88, 92] }
]

slide5.addChart pres.ChartType.LINE, lineData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "With Data Labels"
  showLabel: true
  showLegend: true

# Save
pres.writeFile({ fileName: "outputs/demo-chart-options.pptx" })
  .then -> console.log "✅ Created: outputs/demo-chart-options.pptx"
  .catch (err) -> console.error err
