# C01 医疗质量与安全管理 - 优雅版
# 使用 elegant API

fs = require "fs"
{ generateHtml } = require "./api/elegant"

课程 = 
  title: "医院医疗质量与安全管理"
  subtitle: "C01 课程详细教案"
  slides: [
    # 封面
    { type: "title", title: "医院医疗质量与安全管理", subtitle: "课程详细教案" }
    
    # 课程信息
    { type: "list", title: "课程信息", items: [
      "课程名称：医院医疗质量与安全管理"
      "课程定位：医院管理核心模块课程"
      "课程时长：12小时（2天）"
      "课程对象：院长、副院长、质控部主任等"
    ]}
    
    # 课程目标
    { type: "cards", title: "课程目标", cards: [
      { title: "知识目标", content: "掌握质量管理体系\n熟悉管理工具\n了解安全目标", color: "#ebf8ff" }
      { title: "能力目标", content: "建立质量管理体系\n运用管理工具\n处理安全事件", color: "#f0fff4" }
      { title: "素质目标", content: "培养安全意识\n提升管理能力", color: "#fffaf0" }
    ]}
    
    # 章节
    { type: "section", title: "第一章", subtitle: "质量管理体系概述" }
    
    # 质量管理体系架构
    { type: "cards", title: "质量管理体系要素", cards: [
      { title: "组织架构", content: "质量管理组织体系", color: "#ebf8ff" }
      { title: "制度规范", content: "质量管理制度文件", color: "#f0fff4" }
      { title: "流程管理", content: "核心业务流程优化", color: "#fffaf0" }
      { title: "监测评价", content: "质量监测与评价", color: "#faf5ff" }
    ]}
    
    # PDCA
    { type: "pdca", title: "PDCA循环" }
    
    # 质量管理工具
    { type: "flowchart", title: "质量管理工具", steps: [
      { text: "鱼骨图", color: "#3182ce" }
      { text: "柏拉图", color: "#38a169" }
      { text: "流程图", color: "#d69e2e" }
      { text: "检查表", color: "#e53e3e" }
    ]}
    
    # SWOT
    { type: "swot", title: "质量管理体系SWOT分析", strengths: ["体系完善", "基础扎实"], weaknesses: ["执行难", "信息化弱"], opportunities: ["政策支持", "需求增长"], threats: ["竞争激烈", "成本上升"] }
    
    # 时间线
    { type: "timeline", title: "课程安排", events: [
      { title: "上午", desc: "质量管理理论", color: "#3182ce" }
      { title: "下午", desc: "工具演练", color: "#38a169" }
      { title: "第二天", desc: "案例分析", color: "#d69e2e" }
    ]}
    
    # 对比
    { type: "comparison", title: "传统vs现代质量管理", headers: ["维度", "传统模式", "现代模式"], rows: [
      ["数据收集", "手工统计", "信息系统"]
      ["分析方法", "经验判断", "数据驱动"]
      ["改进方式", "事后改进", "持续改进"]
    ]}
    
    # 章节
    { type: "section", title: "第二章", subtitle: "患者安全管理" }
    
    # 患者安全目标
    { type: "cards", title: "患者安全目标", cards: [
      { title: "身份识别", content: "正确识别患者身份", color: "#fed7d7" }
      { title: "手术安全", content: "确保手术患者安全", color: "#bee3f8" }
      { title: "用药安全", content: "保障用药安全", color: "#c6f6d5" }
      { title: "跌倒防范", content: "预防患者跌倒", color: "#feebc8" }
    ]}
    
    # 不良事件
    { type: "flowchart", title: "不良事件管理", steps: [
      { text: "事件报告", color: "#e53e3e" }
      { text: "原因分析", color: "#d69e2e" }
      { text: "整改措施", color: "#38a169" }
      { text: "效果评价", color: "#3182ce" }
    ]}
    
    # 章节
    { type: "section", title: "第三章", subtitle: "质量持续改进" }
    
    # 质量指标
    { type: "cards", title: "质量指标体系", cards: [
      { title: "结构指标", content: "资源配置", color: "#ebf8ff" }
      { title: "过程指标", content: "服务流程", color: "#f0fff4" }
      { title: "结果指标", content: "治疗效果", color: "#fffaf0" }
    ]}
    
    # 结束
    { type: "end", title: "谢谢!", subtitle: "医院管理培训中心" }
  ]

generateHtml 课程, "outputs/C01-优雅版.html"
console.log "Done! Open outputs/C01-优雅版.html"
