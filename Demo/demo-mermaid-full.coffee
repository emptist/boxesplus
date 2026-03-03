# BoxesPlus - 完整 Mermaid 图表示例

{ generateMermaidHtml, mermaidSlide, pdcaDiagram, paretoDiagram, dataLifecycleDiagram, brandPyramidDiagram, eventLoopDiagram, qualitySystemDiagram, surgeryFlowDiagram, patientSafetyDiagram, swotDiagram, brandMatrixDiagram, evaluationDiagram } = require "../api/mermaid-api.coffee"
{ exportPdf, exportHtmlToPptx } = require "../api/export-pdf.coffee"

# ============ 定义课程数据 ============
课程 = 
  title: "医疗质量与安全管理"
  subtitle: "Mermaid 完整图表演示"
  slides: [
    { 
      type: "mermaid"
      title: "PDCA 持续改进循环"
      diagram: pdcaDiagram
    }
    {
      type: "mermaid"
      title: "柏拉图 - 二八法则"
      diagram: paretoDiagram
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
      title: "围手术期安全管理"
      diagram: surgeryFlowDiagram
    }
    {
      type: "mermaid"
      title: "患者安全目标"
      diagram: patientSafetyDiagram
    }
    {
      type: "mermaid"
      title: "SWOT 分析"
      diagram: swotDiagram
    }
    {
      type: "mermaid"
      title: "学科评估指标体系"
      diagram: evaluationDiagram
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
      type: "mermaid"
      title: "品牌传播矩阵"
      diagram: brandMatrixDiagram
    }
    {
      type: "list"
      title: "Mermaid 图表类型"
      items: [
        "flowchart - 流程图"
        "pie - 饼图"
        "sequenceDiagram - 时序图"
        "classDiagram - 类图"
        "stateDiagram - 状态图"
        "erDiagram - ER图"
        "gantt - 甘特图"
        "timeline - 时间线"
      ]
    }
    {
      type: "end"
      title: "谢谢!"
    }
  ]

# ============ 生成 ============
generateMermaidHtml 课程, "outputs/mermaid-full.html"
console.log "✅ HTML 已生成"

exportPdf("outputs/mermaid-full.html", "outputs/mermaid-full.pdf")
  .then -> console.log "✅ PDF 导出完成"
  .catch (err) -> console.error "PDF 导出失败:", err

exportHtmlToPptx("outputs/mermaid-full.html", "outputs/mermaid-full.pptx")
  .then -> console.log "✅ PPTX 导出完成"
  .catch (err) -> console.error "PPTX 导出失败:", err
