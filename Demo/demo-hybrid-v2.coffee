# BoxesPlus - 混合生成器演示（优化版）

{ CourseGenerator, generate, CHARTS } = require "../api/hybrid-generator.coffee"

# 创建课程
课程 = new CourseGenerator("医疗质量与安全管理")

课程
  .addTitle("医疗质量与安全管理", "Mermaid 图表 - 优化版")
  .addMermaid("1. PDCA 持续改进循环", CHARTS.pdca)
  .addMermaid("2. 柏拉图 - 二八法则", CHARTS.pareto)
  .addMermaid("3. 医疗质量管理体系", CHARTS.qualitySystem, "0.9")
  .addMermaid("4. 不良事件闭环管理", CHARTS.eventLoop, "0.9")
  .addMermaid("5. 数据资产生命周期", CHARTS.dataLifecycle)
  .addMermaid("6. 医院品牌金字塔", CHARTS.brandPyramid, "0.9")
  .addMermaid("7. 患者安全目标", CHARTS.patientSafety, "0.9")
  .addMermaid("8. SWOT 分析", CHARTS.swot, "0.9")
  .addMermaid("9. 围手术期管理", CHARTS.surgery, "0.85")
  .addMermaid("10. 学科评估指标体系", CHARTS.evaluation, "0.75")
  .addList("课程目标", [
    "掌握质量管理体系的构成"
    "熟悉质量管理工具与方法"
    "了解患者安全目标与措施"
  ])

# 生成所有格式
await generate(课程, "hybrid-demo-v2")
console.log "🎉 演示完成!"
