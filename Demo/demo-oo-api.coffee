# BoxesPlus OO API 演示
# 展示高级面向对象设计

{ Slide, Section, Presentation, createSlidesFromData, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# 示例 1: 类侧模板定义 - 定义一次，使用多次
# ============================================

# 定义 PDCA 幻灯片模板（类侧）
class PdcSlide extends Slide
  @title: "PDCA 循环"
  @layout: "mermaid"
  @content: CHARTS.pdca
  @scale: "0.9"

# 定义柏拉图模板
class ParetoSlide extends Slide
  @title: "柏拉图分析"
  @layout: "mermaid"
  @content: CHARTS.pareto
  @scale: "0.9"

# ============================================
# 示例 2: 实例侧数据驱动 - 从数据创建幻灯片
# ============================================

# 数据数组
质量目标数据 = [
  { title: "提高治愈率", content: "从 85% 提升到 95%" }
  { title: "降低感染率", content: "从 3% 降低到 1%" }
  { title: "患者满意度", content: "从 90% 提升到 98%" }
]

# 创建幻灯片集合
目标Slides = for data in 质量目标数据
  new Slide({
    title: data.title
    layout: "list"
    content: [data.content]
  })

# ============================================
# 示例 3: Section - 章节组合
# ============================================

# 基础质量管理章节
class QualitySection extends Section
  @title: "质量管理基础"
  @description: "质量管理基本概念与方法"

  constructor: ->
    super("质量管理基础")
    @add(new PdcSlide())
    @add(new ParetoSlide())

# 实际数据章节（从数据驱动）
class DataDrivenSection extends Section
  constructor: (sectionTitle, dataArray) ->
    super(sectionTitle)
    for data in dataArray
      @addSlide(data.title, data.layout || "list", data.content)

# ============================================
# 示例 4: 完整演示文稿 - 组合所有
# ============================================

# 创建演示文稿
课程 = new Presentation("医疗质量与安全管理 - OO版")

# 添加章节 1: 理论基础（使用类侧模板）
理论章节 = new QualitySection()
课程.addSection(理论章节)

# 添加章节 2: 目标管理（使用实例侧数据）
目标章节 = new Section("目标管理")
目标章节.addMultiple(目标Slides)
课程.addSection(目标章节)

# 添加章节 3: 不良事件（动态创建）
事件章节 = new Section("不良事件管理")
事件章节
  .add(new Slide({ title: "事件闭环", layout: "mermaid", content: CHARTS.eventLoop, scale: "0.9" }))
  .addSlide("报告流程", "list", ["事件发现", "初步评估", "原因分析", "整改措施", "效果评价"])
课程.addSection(事件章节)

# 添加章节 4: 数据驱动方式
数据章节 = new DataDrivenSection("数据资产管理", [
  { title: "数据采集", content: ["问卷调查", "系统提取", "人工录入"], layout: "list" }
  { title: "数据分析", content: ["趋势分析", "对比分析", "预测分析"], layout: "list" }
  { title: "数据应用", content: ["决策支持", "绩效评价", "质量改进"], layout: "list" }
])
课程.addSection(数据章节)

# ============================================
# 示例 5: 直接添加幻灯片（便捷方法）
# ============================================

课程.addSlide("总结", "list", [
  "质量管理是医院核心竞争力的基础"
  "PDCA 循环是持续改进的方法论"
  "数据驱动是科学管理的保障"
])

# ============================================
# 生成
# ============================================

console.log "📊 幻灯片统计:"
console.log "   章节数: #{课程._sections.length}"
for section, i in 课程._sections
  console.log "   章节#{i+1}: #{section.title} - #{section.count()} 张"

console.log "\n🚀 开始生成..."
await 课程.generate("oo-demo")
