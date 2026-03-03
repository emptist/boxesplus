# BoxesPlus - Mermaid 图表 API 使用示例

{ generateMermaidHtml, mermaidSlide, pdcaDiagram, dataLifecycleDiagram, brandPyramidDiagram, eventLoopDiagram, qualitySystemDiagram } = require "../api/mermaid-api.coffee"
{ exportPdf, exportHtmlToPptx } = require "../api/export-pdf.coffee"

# ============ 定义课程数据 ============
课程 = 
  title: "医疗质量与安全管理"
  subtitle: "Mermaid 图表演示"
  slides: [
    { 
      type: "mermaid"
      title: "PDCA 持续改进循环"
      diagram: pdcaDiagram
    }
    {
      type: "mermaid"
      title: "医疗质量管理体系"
      diagram: qualitySystemDiagram
    }
    {
      type: "mermaid"
      title: "不良事件闭环管理"
      diagram: eventLoopDiagram
    }
    {
      type: "mermaid"
      title: "数据资产生命周期"
      diagram: dataLifecycleDiagram
    }
    {
      type: "mermaid"
      title: "医院品牌金字塔"
      diagram: brandPyramidDiagram
    }
    {
      type: "list"
      title: "Mermaid 图表优势"
      items: [
        "声明式语法 - 专注内容而非布局"
        "自动布局 - 节点位置智能计算"
        "丰富样式 - 颜色、形状、边框"
        "多种类型 - 流程图、时序图、类图等"
        "导出方便 - HTML/PNG/SVG"
      ]
    }
    {
      type: "end"
      title: "谢谢!"
    }
  ]

# ============ 生成 HTML ============
generateMermaidHtml 课程, "outputs/mermaid-course.html"
console.log "✅ HTML 已生成"

# ============ 导出 PDF ============
exportPdf("outputs/mermaid-course.html", "outputs/mermaid-course.pdf")
  .then -> console.log "✅ PDF 导出完成"
  .catch (err) -> console.error "PDF 导出失败:", err

# ============ 导出 PPTX ============
exportHtmlToPptx("outputs/mermaid-course.html", "outputs/mermaid-course.pptx")
  .then -> console.log "✅ PPTX 导出完成"
  .catch (err) -> console.error "PPTX 导出失败:", err
