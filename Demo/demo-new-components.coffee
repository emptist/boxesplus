# 组件测试 - 新增 pyramid, verticalFlow, matrix
fs = require "fs"
{ generateHtml } = require "../api/elegant"

课程 = 
  title: "组件测试"
  slides: [
    { type: "title", title: "新组件测试" }
    
    # 金字塔
    { type: "pyramid", title: "品牌层次金字塔", levels: [
      { text: "文化品牌", color: "#1a365d" }
      { text: "服务品牌", color: "#2c5282" }
      { text: "技术品牌", color: "#3182ce" }
      { text: "标识品牌", color: "#4299e1" }
    ]}
    
    # 垂直流程
    { type: "verticalFlow", title: "数据生命周期", steps: [
      { text: "数据采集", color: "#3182ce" }
      { text: "数据存储", color: "#38a169" }
      { text: "数据处理", color: "#d69e2e" }
      { text: "数据分析", color: "#e53e3e" }
      { text: "数据应用", color: "#805ad5" }
    ]}
    
    # 矩阵
    { type: "matrix", title: "数据资产矩阵", rows: [
      { topLeft: "核心数据\n高价值低风险", topRight: "战略数据\n高价值高风险" }
      { bottomLeft: "基础数据\n低价值低风险", bottomRight: "风险数据\n低价值高风险" }
    ]}
    
    # 原有组件
    { type: "pdca", title: "PDCA循环" }
    { type: "swot", title: "SWOT分析", strengths: ["优势"], weaknesses: ["劣势"], opportunities: ["机会"], threats: ["威胁"] }
    { type: "flowchart", title: "流程", steps: [{text:"A",color:"#3182ce"},{text:"B",color:"#38a169"},{text:"C",color:"#d69e2e"}] }
    { type: "org", title: "组织架构", levels: [{text:"院长",color:"#1a365d"},{text:["副1","副2"],color:"#2b6cb0"}] }
    { type: "end", title: "谢谢!" }
  ]

generateHtml 课程, "outputs/components-test.html"
console.log "Done! Open outputs/components-test.html"
