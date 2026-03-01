# BoxesPlus - PptxGenJS Exploration Notes

## What We Have

### Already Working (in api/boxesplus-artist.coffee)
- `titleSlide` - title slide with gradient
- `listSlide` - numbered list
- `cardSlide` - multi-column cards
- `flowSlide` - process steps
- `tableSlide` - data tables
- `quoteSlide` - quote/cite
- `comparisonSlide` - left/right comparison
- `timelineSlide` - event timeline
- `endSlide` - closing slide

### Verified Working (explore-features.coffee)

#### Shapes (pres.ShapeType)
- rect, roundRect, ellipse, diamond, triangle, rightArrow

#### Charts (pres.ChartType)
- BAR, LINE, PIE, RADAR, SCATTER

#### Tables
- Standard array-of-arrays format with header

## Correct Syntax

### Chart
```coffee
chartData = [
  {
    name: "Series 1"
    values: [10, 20, 30]
    labels: ["A", "B", "C"]  # optional, for first series
  }
  {
    name: "Series 2"
    values: [15, 25, 35]
  }
]

slide.addChart pres.ChartType.BAR, chartData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "Chart Title"
```

### Shape
```coffee
slide.addShape pres.ShapeType.rect,
  x: 0.5, y: 1, w: 2, h: 1
  fill: { color: "3182ce" }
```

### Table
```coffee
tableData = [
  ["Header1", "Header2", "Header3"]
  ["Row1Col1", "Row1Col2", "Row1Col3"]
]

slide.addTable tableData,
  x: 0.5, y: 1.2, w: 9, h: 3
  fontSize: 14
  headerFill: "1e3a5f"
  headerColor: "ffffff"
```

## Now Also Verified

### Text Formatting
- bold: true
- italic: true
- underline: true
- color: "hex"
- align: "left" | "center" | "right"

### Background
- slide.background = { color: "hex" }

### Transparency
- fill: { color: "hex", transparency: 30 }

### Outline
- line: { color: "hex", width: 3 }

### Slide Number
- slide.slideNumber = { x: "95%", y: "95%", fontSize: 10, color: "666666" }

## Not Yet Explored
- addImage (needs actual image file)
- Slide Masters (defineSlideMaster)
- addMedia (video/audio)
- SVG support
- HTML-to-PPTX conversion
- DOUGHNUT chart

## Reference
- hqcoffee cases/goodhospital2021/self.coffee - complex example
- pptxgenjs README.md - full documentation
