# C01 医疗质量与安全管理 - 完整示例
fs = require "fs"
{ generateHtml } = require "../api/elegant"

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
      "教学方法：理论讲授、方法演练、案例分析"
    ]}
    
    # 课程目标
    { type: "cards", title: "课程目标", cards: [
      { title: "知识目标", content: "掌握质量管理体系\n熟悉管理工具\n了解安全目标", color: "#ebf8ff" }
      { title: "能力目标", content: "建立质量管理体系\n运用管理工具\n处理安全事件", color: "#f0fff4" }
      { title: "素质目标", content: "培养安全意识\n提升管理能力", color: "#fffaf0" }
    ]}
    
    # 章节
    { type: "section", title: "第一章", subtitle: "医疗质量管理概述" }
    
    # 医疗质量内涵 - 带边框内容框
    { type: "box", title: "医疗质量内涵", content: "医疗质量是指医疗服务在满足患者及其家属健康需求方面所达到的程度，包括医疗技术质量和服务质量。\n狭义：诊疗质量\n广义：技术+服务+管理+环境", color: "#f7fafc" }
    
    # 医疗质量维度
    { type: "comparison", title: "医疗质量维度", headers: ["维度", "内容"], rows: [
      ["结构质量", "人员、设备、制度、环境"]
      ["过程质量", "诊疗流程、操作规范"]
      ["结果质量", "诊疗效果、患者结局"]
    ]}
    
    # 章节
    { type: "section", title: "第二章", subtitle: "质量管理体系" }
    
    # 体系要素
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
    { type: "swot", title: "质量管理体系SWOT分析",
      strengths: ["体系完善", "基础扎实"]
      weaknesses: ["执行难", "信息化弱"]
      opportunities: ["政策支持", "需求增长"]
      threats: ["竞争激烈", "成本上升"]
    }
    
    # 章节
    { type: "section", title: "第三章", subtitle: "患者安全管理" }
    
    # 患者安全目标
    { type: "cards", title: "患者安全目标", cards: [
      { title: "身份识别", content: "正确识别患者身份", color: "#fed7d7" }
      { title: "手术安全", content: "确保手术患者安全", color: "#bee3f8" }
      { title: "用药安全", content: "保障用药安全", color: "#c6f6d5" }
      { title: "跌倒防范", content: "预防患者跌倒", color: "#feebc8" }
    ]}
    
    # 不良事件管理
    { type: "flowchart", title: "不良事件管理", steps: [
      { text: "事件报告", color: "#e53e3e" }
      { text: "原因分析", color: "#d69e2e" }
      { text: "整改措施", color: "#38a169" }
      { text: "效果评价", color: "#3182ce" }
    ]}
    
    # 章节
    { type: "section", title: "第四章", subtitle: "质量持续改进" }
    
    # 质量指标体系
    { type: "cards", title: "质量指标体系", cards: [
      { title: "结构指标", content: "资源配置", color: "#ebf8ff" }
      { title: "过程指标", content: "服务流程", color: "#f0fff4" }
      { title: "结果指标", content: "治疗效果", color: "#fffaf0" }
    ]}
    
    # 时间线
    { type: "timeline", title: "课程安排", events: [
      { title: "上午", desc: "质量管理理论", color: "#3182ce" }
      { title: "下午", desc: "工具演练+案例", color: "#38a169" }
      { title: "第二天", desc: "实操练习", color: "#d69e2e" }
    ]}
    
    # 章节
    { type: "section", title: "第五章", subtitle: "案例分析" }
    
    # 案例 - 带边框内容
    { type: "box", title: "案例一：手术部位错误", content: "事件：患者张三因左膝关节手术被错误切除右膝\n\n原因分析：\n1. 手术部位标识不规范\n2. 核对制度执行不严\n3. 手术团队沟通不足\n\n整改措施：\n1. 完善手术部位标识制度\n2. 严格执行Time-out核对\n3. 加强手术安全培训", color: "#fed7d7" }
    
    # 案例二
    { type: "box", title: "案例二：患者跌倒事件", content: "事件：住院患者夜间跌倒致头部外伤\n\n原因分析：\n1. 陪护人员不在现场\n2. 病房光线不足\n3. 患者服用安眠药\n\n整改措施：\n1. 评估跌倒风险\n2. 做好防跌倒宣教\n3. 改善病房环境", color: "#feebc8" }
    
    # 章节
    { type: "section", title: "核心要点", subtitle: "质量管理原则" }
    
    # 质量原则
    { type: "comparison", title: "质量管理原则", headers: ["原则", "说明"], rows: [
      ["患者安全", "首要原则，一切以患者安全为中心"]
      ["持续改进", "PDCA循环，不断优化"]
      ["全员参与", "质量是每个员工的责任"]
      ["数据驱动", "用数据说话，科学管理"]
    ]}
    
    # 金句
    { type: "quote", title: "质量箴言", quote: "质量不是检验出来的，而是设计和生产出来的。", author: "朱兰" }
    
    # 结束
    { type: "end", title: "谢谢!", subtitle: "医院管理培训中心" }
  ]

generateHtml 课程, "outputs/C01-完整版.html"
console.log "✅ Created: outputs/C01-完整版.html"
console.log "Slides: #{课程.slides.length}"
