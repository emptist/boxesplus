# 快速测试：用优雅API写一个课程
fs = require "fs"
{ generateHtml } = require "./api/elegant"

课程 = 
  title: "测试课程"
  subtitle: "C01 医疗质量"
  slides: [
    { type: "title", title: "医院医疗质量与安全管理", subtitle: "C01 课程" }
    { type: "cards", title: "课程目标", cards: [
      { title: "知识目标", content: "掌握质量管理理论", color: "#ebf8ff" }
      { title: "能力目标", content: "建立质量管理体系", color: "#f0fff4" }
    ]}
    { type: "section", title: "第一章", subtitle: "质量管理体系" }
    { type: "pdca", title: "PDCA循环" }
    { type: "swot", title: "SWOT分析", strengths: ["体系完善"], weaknesses: ["执行难"], opportunities: ["政策支持"], threats: ["竞争"] }
    { type: "timeline", title: "实施计划", events: [
      { title: "第一阶段", desc: "调研诊断", color: "#3182ce" }
      { title: "第二阶段", desc: "体系建设", color: "#38a169" }
    ]}
    { type: "end", title: "谢谢!", subtitle: "BoxesPlus" }
  ]

generateHtml 课程, "outputs/test-elegant-course.html"
console.log "Done! Open outputs/test-elegant-course.html"
