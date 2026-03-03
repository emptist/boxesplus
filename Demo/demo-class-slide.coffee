# BoxesPlus - Class-as-Slide 模式演示
# 展示类的继承和 OOP 能力

{ Slide, Section, Presentation, MermaidSlide, ListSlide, TitleSlide, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# 示例 1: 简单继承 - 自定义幻灯片
# ============================================

# 定义一个自定义图表幻灯片
class QualityChartSlide extends MermaidSlide
  @title: "质量图表"
  @scale: "0.85"

# 继承并指定具体图表
class PdcaSlide extends QualityChartSlide
  @title: "PDCA 循环"
  constructor: ->
    super("PDCA 循环", CHARTS.pdca, "0.9")

class EventLoopSlide extends QualityChartSlide
  @title: "事件闭环"
  constructor: ->
    super("不良事件闭环", CHARTS.eventLoop, "0.9")

# ============================================
# 示例 2: 带数据的幻灯片 (类似 @cso 模式)
# ============================================

class DataListSlide extends ListSlide
  @title: "数据列表"
  
  # 构造函数可以处理数据
  constructor: (title, items, @_metadata = {}) ->
    super(title, items)
  
  # 可覆盖 toData 添加额外数据
  toData: ->
    data = super()
    data.metadata = @_metadata
    data

# 使用类侧初始化器
class ConfigurableSlide extends Slide
  @layout: "list"
  @title: "可配置幻灯片"
  
  # 类方法: 定义数据准备方法
  @dataPrepare: (config) ->
    title: config.title or @title
    items: config.items or []
  
  constructor: (config = {}) ->
    prepared = ConfigurableSlide.dataPrepare(config)
    super(prepared)

# ============================================
# 示例 3: Section 继承
# ============================================

class BaseSection extends Section
  @title: "基础章节"
  @description: "基类章节"
  
  # 类方法: 准备数据
  @prepareData: (topic) ->
    {
      title: "#{topic}管理"
      charts: CHARTS[topic.toLowerCase()] || CHARTS.pdca
    }

# 继承创建具体章节
class QualitySection extends BaseSection
  @title: "质量管理"
  
  constructor: ->
    super("质量管理")
    @add(new PdcaSlide())
    @add(new EventLoopSlide())

class SafetySection extends Section
  @title: "安全管理"
  
  constructor: ->
    super("安全管理")
    @add(new MermaidSlide("患者安全目标", CHARTS.patientSafety, "0.85"))

# ============================================
# 示例 4: 数据驱动的 Section
# ====================================

class DataDrivenSection extends Section
  @title: "数据驱动章节"
  
  # 类方法: 从数据创建幻灯片
  @createSlides: (dataArray) ->
    slides = []
    for data in dataArray
      slides.push(new ListSlide(data.title, data.items))
    slides
  
  constructor: (title, dataArray) ->
    super(title)
    slides = @constructor.createSlides(dataArray)
    for slide in slides
      @add(slide)

# ============================================
# 示例 5: 完整 Presentation
# ============================================

class CoursePresentation extends Presentation
  @title: "医疗质量与安全管理"
  @author: "BoxesPlus"
  
  # 类侧定义章节
  @sections: [QualitySection, SafetySection]
  
  constructor: (topic) ->
    super(topic or "医疗质量课程")
    @_init()
  
  _init: ->
    # 使用类侧定义的章节
    for sectionClass in @constructor.sections
      @addSection(new sectionClass())

# ============================================
# 使用方式 1: 手动组合
# ============================================

console.log "=== 方式 1: 手动组合 ==="

课程1 = new Presentation("手动组合演示")

# 直接添加实例
课程1.addSlide(new TitleSlide("欢迎", "手动组合方式"))
课程1.addSlide(new PdcaSlide())
课程1.addSlide(new ListSlide("核心要点", ["继承", "多态", "封装"]))

# 添加章节
质量章节 = new QualitySection()
课程1.addSection(质量章节)

console.log "幻灯片数: #{课程1.getAllSlides().length}"

# ============================================
# 使用方式 2: 类侧继承
# ============================================

console.log "\n=== 方式 2: 类侧继承 ==="

课程2 = new CoursePresentation("继承演示")

console.log "幻灯片数: #{课程2.getAllSlides().length}"
for slide in 课程2.getAllSlides()
  console.log "  - #{slide.title} (#{slide.layout})"

# ============================================
# 使用方式 3: 数据驱动
# ============================================

console.log "\n=== 方式 3: 数据驱动 ==="

目标数据 = [
  { title: "短期目标", items: ["提高治愈率", "降低感染率"] }
  { title: "中期目标", items: ["优化流程", "提升效率"] }
  { title: "长期目标", items: ["学科建设", "品牌提升"] }
]

目标章节 = new DataDrivenSection("发展目标", 目标数据)

console.log "目标章节幻灯片数: #{目标章节.count()}"
for slide in 目标章节.getSlides()
  console.log "  - #{slide.title}: #{slide._data.items?.join(', ')}"

# ============================================
# 生成
# ============================================

console.log "\n🚀 开始生成..."

# 生成手动组合的演示
await 课程1.generate("class-demo")

console.log "✅ Class-as-Slide 演示完成!"
