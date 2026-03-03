# BoxesPlus - Class Name 自动推断演示
# 展示 getTitle() 方法获取类名

{ Slide, Section, Presentation, MermaidSlide, ListSlide, TitleSlide, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# 使用 getTitle() 获取类名作为标题
# ============================================

class 医疗质量管理 extends MermaidSlide
  @scale: "0.85"

class 不良事件管理 extends MermaidSlide
  @scale: "0.85"

class 数据资产管理 extends MermaidSlide
  @scale: "0.85"

class 品牌建设 extends MermaidSlide
  @scale: "0.85"

class 课程目标 extends ListSlide
  constructor: ->
    super("课程目标", [
      "掌握质量管理体系的构成"
      "熟悉质量管理工具与方法"
      "了解患者安全目标与措施"
    ])

class 核心要点 extends ListSlide
  constructor: ->
    super("核心要点", ["要点1", "要点2", "要点3"])

# ============================================
# Section
# ============================================

class 质量管理章节 extends Section
  constructor: ->
    super("质量管理")
    @add(new 医疗质量管理())
    @add(new 不良事件管理())
    @add(new 课程目标())

class 资产管理章节 extends Section
  constructor: ->
    super("资产管理")
    @add(new 数据资产管理())
    @add(new 核心要点())

# ============================================
# Presentation
# ============================================

class 医疗质量课程 extends Presentation
  @sections: [质量管理章节, 资产管理章节]
  
  constructor: ->
    super("医疗质量与安全管理")
    @addSlide(new TitleSlide("医疗质量与安全管理", "Class-as-Slide 演示"))
    for sectionClass in @constructor.sections
      @addSection(new sectionClass())

# ============================================
# 使用
# ============================================

console.log "=== Class-as-Slide 演示 ==="

课程 = new 医疗质量课程()

console.log "\n幻灯片列表:"
for slide in 课程.getAllSlides()
  console.log "  - #{slide.getTitle()} (#{slide.layout})"

console.log "\n🚀 生成中..."
await 课程.generate("class-name-demo")

console.log "✅ 完成!"
