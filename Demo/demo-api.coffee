# BoxesPlus - 使用 Mermaid API

{ generateHtml, CHARTS } = require "../api/mermaid-slides.coffee"

课程 =
  title: "医疗质量与安全管理"
  slides: [
    { type: "title", title: "医疗质量与安全管理" }
    { type: "mermaid", title: "1. PDCA 循环", content: CHARTS.pdca }
    { type: "mermaid", title: "2. 柏拉图", content: CHARTS.pareto }
    { type: "mermaid", title: "3. 质量管理体系", content: CHARTS.qualitySystem, scale: 0.85 }
    { type: "mermaid", title: "4. 不良事件闭环", content: CHARTS.eventLoop, scale: 0.85 }
    { type: "mermaid", title: "5. 数据生命周期", content: CHARTS.dataLifecycle }
    { type: "mermaid", title: "6. 品牌金字塔", content: CHARTS.brandPyramid }
  ]

generateHtml 课程, "outputs/api-demo.html"
console.log "✅ Created: outputs/api-demo.html"
