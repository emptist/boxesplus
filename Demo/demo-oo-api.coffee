# BoxesPlus OO API 演示
# 展示高级面向对象设计

{ Slide, TitleSlide, MermaidSlide, ListSlide, Section, Presentation, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# 示例 1: 使用预定义幻灯片类
# ============================================

# 创建标题页
封面 = new TitleSlide("医疗质量与安全管理", "医院管理核心课程")

# 创建 Mermaid 图表页
pdcaSlide = new MermaidSlide("PDCA循环", CHARTS.pdca, "0.9")
paretoSlide = new MermaidSlide("柏拉图分析", CHARTS.pareto, "0.9")

# 创建列表页
目标Slide = new ListSlide("课程目标", [
  "掌握质量管理基本概念"
  "熟悉PDCA循环方法"
  "学会使用质量管理工具"
])

# ============================================
# 示例 2: 创建章节
# ============================================

# 第一章：质量管理基础
第一章 = new Section("质量管理基础")
第一章.add(封面)
第一章.add(pdcaSlide)
第一章.add(paretoSlide)

# 第二章：目标管理
第二章 = new Section("目标管理")
第二章.add(目标Slide)
第二章.add(new ListSlide("质量目标", [
  "提高治愈率：从 85% 提升到 95%"
  "降低感染率：从 3% 降低到 1%"
  "患者满意度：从 90% 提升到 98%"
]))

# 第三章：不良事件管理
第三章 = new Section("不良事件管理")
第三章.add(new MermaidSlide("事件闭环", CHARTS.eventLoop, "0.9"))
第三章.add(new ListSlide("报告流程", [
  "事件发现"
  "初步评估"
  "原因分析"
  "整改措施"
  "效果评价"
]))

# ============================================
# 示例 3: 创建演示文稿
# ============================================

课程 = new Presentation("医疗质量与安全管理 - OO版")
课程.addSection(第一章)
课程.addSection(第二章)
课程.addSection(第三章)

# 添加直接幻灯片
课程.addSlide(new ListSlide("总结", [
  "质量管理是医院核心竞争力的基础"
  "PDCA 循环是持续改进的方法论"
  "数据驱动是科学管理的保障"
]))

# ============================================
# 生成
# ============================================

console.log "📊 幻灯片统计:"
console.log "   章节数: #{课程._sections.length}"
for section, i in 课程._sections
  console.log "   章节#{i+1}: #{section.title} - #{section.count()} 张"
console.log "   直接幻灯片: #{课程._slides.length}"

console.log "\n🚀 开始生成..."
await 课程.generate("oo-demo")
