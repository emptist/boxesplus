#!/usr/bin/env coffee

# C01课程图表 - 修复版测试
# 使用startOnLoad: true自动渲染Mermaid

{ 
  开始绘图简化HTML, 开始绘图HTML, 完成绘图
  创建流程图, 创建时序图, 创建类图, 创建状态图 
} = require "../api/mermaid-enhanced-fixed.coffee"

# ============================================
# 定义图表
# ============================================

PDCA图 = 创建流程图 "PDCA循环", [
  { id: "P", label: "PLAN（计划）" }
  { id: "D", label: "DO（执行）" }
  { id: "C", label: "CHECK（检查）" }
  { id: "A", label: "ACTION（处理）" }
], [
  { from: "P", to: "D" }
  { from: "D", to: "C" }
  { from: "C", to: "A" }
  { from: "A", to: "P", label: "持续改进" }
]

体系图 = 创建流程图 "医疗质量管理体系", [
  { id: "方针", label: "质量方针", group: "顶层设计" }
  { id: "目标", label: "质量目标", group: "顶层设计" }
  { id: "文化", label: "质量文化", group: "顶层设计" }
  { id: "组织", label: "质量组织", group: "组织保障" }
  { id: "制度", label: "质量制度", group: "组织保障" }
  { id: "流程", label: "质量流程", group: "组织保障" }
  { id: "控制", label: "质量控制", group: "执行控制" }
  { id: "保证", label: "质量保证", group: "执行控制" }
  { id: "改进", label: "质量改进", group: "执行控制" }
], [
  { from: "方针", to: "组织" }
  { from: "目标", to: "制度" }
  { from: "文化", to: "流程" }
  { from: "组织", to: "控制" }
  { from: "制度", to: "保证" }
  { from: "流程", to: "改进" }
]

闭环图 = 创建流程图 "不良事件闭环管理", [
  { id: "报告", label: "1.事件报告", shape: "parallelogram" }
  { id: "调查", label: "2.初步调查" }
  { id: "分析", label: "3.根本原因分析", shape: "diamond" }
  { id: "改进", label: "4.改进措施" }
  { id: "评估", label: "5.效果评估" }
  { id: "标准", label: "6.标准化", shape: "cylinder" }
], [
  { from: "报告", to: "调查" }
  { from: "调查", to: "分析" }
  { from: "分析", to: "改进" }
  { from: "改进", to: "评估" }
  { from: "评估", to: "标准" }
]

危急值图 = 创建时序图 "危急值管理流程", [
  { name: "检验科", note: "检测到危急值" }
  { name: "临床科室", note: "确认接收" }
  { name: "质控部门", note: "审核确认" }
], [
  { from: "检验科", to: "临床科室", message: "检测到危急值" }
  { from: "临床科室", to: "检验科", message: "确认接收", type: "dashed" }
  { from: "临床科室", to: "质控部门", message: "上报处理措施" }
  { from: "质控部门", to: "临床科室", message: "审核确认", type: "dashed" }
]

组织架构图 = 创建类图 "质量管理组织架构", [
  {
    name: "质量委员会"
    properties: ["主席", "委员"]
    methods: ["制定方针()", "审核目标()"]
  }
  {
    name: "质控部门"
    properties: ["主任", "质控员"]
    methods: ["日常监督()", "数据分析()"]
  }
  {
    name: "科室质控组"
    properties: ["组长", "成员"]
    methods: ["科室自查()", "问题整改()"]
  }
  {
    name: "全院职工"
    properties: ["医师", "护士"]
    methods: ["执行规范()", "报告事件()"]
  }
], [
  { from: "质量委员会", to: "质控部门" }
  { from: "质控部门", to: "科室质控组" }
  { from: "科室质控组", to: "全院职工" }
]

风险管理图 = 创建状态图 "患者安全风险管理", [
  { name: "正常" }
  { name: "风险评估" }
  { name: "高风险" }
  { name: "干预措施" }
  { name: "安全", type: "end" }
], [
  { from: "正常", to: "风险评估", label: "定期评估" }
  { from: "风险评估", to: "高风险", label: "发现风险" }
  { from: "高风险", to: "干预措施", label: "启动干预" }
  { from: "干预措施", to: "安全", label: "风险消除" }
  { from: "安全", to: "正常", label: "恢复常态" }
]

# ============================================
# 生成简化HTML（修复版）
# ============================================

console.log "\n========================================"
console.log "生成简化HTML（修复版）"
console.log "========================================\n"

绘图简化HTML = 开始绘图简化HTML "C01医疗质量与安全管理课程图表（修复版）"

绘图简化HTML.添加图表 PDCA图
绘图简化HTML.添加图表 体系图
绘图简化HTML.添加图表 闭环图
绘图简化HTML.添加图表 危急值图
绘图简化HTML.添加图表 组织架构图
绘图简化HTML.添加图表 风险管理图

完成绘图 "../output/C01课程图表-修复版-简化HTML.html"

# ============================================
# 生成HTML（RevealJS修复版）
# ============================================

console.log "\n========================================"
console.log "生成HTML（RevealJS修复版）"
console.log "========================================\n"

绘图HTML = 开始绘图HTML "C01医疗质量与安全管理课程图表（RevealJS修复版）"

绘图HTML.添加图表 PDCA图
绘图HTML.添加图表 体系图
绘图HTML.添加图表 闭环图
绘图HTML.添加图表 危急值图
绘图HTML.添加图表 组织架构图
绘图HTML.添加图表 风险管理图

完成绘图 "../output/C01课程图表-修复版-HTML.html"

console.log "\n========================================"
console.log "✅ 全部完成！"
console.log "========================================"
console.log "生成的文件："
console.log "  1. 简化HTML: C01课程图表-修复版-简化HTML.html"
console.log "  2. RevealJS HTML: C01课程图表-修复版-HTML.html"
console.log "\n关键修复："
console.log "  • 使用startOnLoad: true让Mermaid自动渲染"
console.log "  • 简化HTML：独立页面，自动加载"
console.log "  • RevealJS HTML：先初始化Mermaid，再初始化RevealJS"
