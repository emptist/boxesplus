# BoxesPlus - 快捷方式演示
# 展示最简洁的使用方式

{ Slide, Section, Presentation, MermaidSlide, ListSlide, TitleSlide, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# 方式1: 最简洁 - 类名即标题
# 类名: 医疗质量管理 -> 幻灯片标题: "医疗质量管理"
# ============================================

# 直接继承,类名就是标题
class PDCA循环 extends MermaidSlide
  @scale: "0.85"

class 柏拉图 extends MermaidSlide
  @scale: "0.85"

class 事件闭环 extends MermaidSlide
  @scale: "0.85"

class 质量体系 extends MermaidSlide
  @scale: "0.85"

# 列表
class 课程目标 extends ListSlide
  constructor: ->
    super("课程目标", ["目标一", "目标二", "目标三"])

# 章节: 类名自动作为章节标题
class 质量管理章节 extends Section
  constructor: ->
    super()
    @add(new PDCA循环())
    @add(new 柏拉图())
    @add(new 课程目标())

class 流程管理章节 extends Section
  constructor: ->
    super()
    @add(new 事件闭环())
    @add(new 质量体系())

# 演示文稿: 类名自动作为文稿标题
class 医疗质量课程 extends Presentation
  @sections: [质量管理章节, 流程管理章节]
  
  constructor: ->
    super()
    @addSlide(new TitleSlide("医疗质量与安全管理", "Class-as-Slide 简洁演示"))
    for s in @constructor.sections
      @addSection(new s())

# ============================================
# 方式2: 使用 @cso 类侧数据准备
# ============================================

class 数据驱动章节 extends Section
  @data: [
    { title: "数据采集", items: ["问卷", "系统", "人工"] }
    { title: "数据分析", items: ["趋势", "对比", "预测"] }
    { title: "数据应用", items: ["决策", "评价", "改进"] }
  ]
  
  constructor: ->
    super("数据驱动章节")
    for item in @constructor.data
      @add(new ListSlide(item.title, item.items))

# ============================================
# 方式3: 批量创建
# ============================================

批量创建 = ->
  slides = []
  charts = ["Pdca", "EventLoop", "QualitySystem", "Pareto", "DataLifecycle"]
  for chartName in charts
    slides.push(new MermaidSlide(chartName, CHARTS[chartName], "0.8"))
  slides

# ============================================
# 使用
# ============================================

console.log "=== 快捷方式演示 ==="

课程 = new 医疗质量课程()

# 添加数据驱动章节
课程.add(new 数据驱动章节())

# 批量添加
for slide in 批量创建()
  课程.addSlide(slide)

console.log "幻灯片总数: #{课程.getAllSlides().length}"
console.log "\n幻灯片列表:"
for slide, i in 课程.getAllSlides()
  console.log "  #{i+1}. #{slide.getTitle()} (#{slide.layout})"

console.log "\n🚀 生成中..."
await 课程.generate("quick-demo")

console.log "✅ 快捷方式演示完成!"
