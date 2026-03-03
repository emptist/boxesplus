# BoxesPlus - 双侧编程演示
# 探索 CoffeeScript 类侧 (@) vs 实例侧 的使用场景

{ Slide, Section, Presentation, MermaidSlide, ListSlide, TitleSlide, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# CoffeeScript 双侧编程
# 
# @ 属性 = 类侧 (class-side) = 所有实例共享
# this 属性 = 实例侧 (instance-side) = 每个实例独立
# 
# 何时用类侧:
#   - 模板定义 (默认标题、布局、缩放)
#   - 共享配置
#   - 静态数据
# 
# 何时用实例侧:
#   - 具体数据 (每个幻灯片内容不同)
#   - 运行时状态
# ============================================

# ============================================
# 1. 类侧 - 模板定义
# ============================================

# 类侧: 定义此类所有实例的默认属性
class ChartSlide extends MermaidSlide
  @layout: "mermaid"
  @scale: "0.85"
  @theme: "default"

# 类侧: 共享配置
class ConfiguredSection extends Section
  @title: "默认章节"
  @maxSlides: 10
  @theme: "blue"

# ============================================
# 2. 实例侧 - 具体数据
# ============================================

# 构造函数中定义实例侧属性
class DataSlide extends Slide
  @layout: "list"
  
  constructor: (title, items, @_metadata = {}) ->  # @_metadata 是实例侧
    super({title, items})

# ============================================
# 3. 双侧结合: 模板 + 数据
# ============================================

class 模板幻灯片 extends MermaidSlide
  @scale: "0.85"  # 类侧: 默认缩放
  
  # 实例侧: 动态获取图表
  getChart: -> CHARTS.pdca  # 子类可覆盖

# ============================================
# 4. 类方法 vs 实例方法
# ============================================

class SmartSection extends Section
  # 类方法: 创建实例集合
  @createFromArray: (dataArray) ->
    section = new SmartSection()
    for data in dataArray
      section.add(new ListSlide(data.title, data.items))
    section
  
  # 类方法: 批量创建
  @createMany: (slideClass, count, config) ->
    section = new SmartSection()
    for i in [0...count]
      section.add(new slideClass(config))
    section
  
  # 实例方法: 添加多个
  addMultiple: (slides) ->
    @_slides.push(...slides)
    this

# ============================================
# 5. @cso: 类侧初始化器模式
# ============================================

class CsoSlide extends Slide
  @layout: "list"
  
  # 类侧: 数据准备方法
  @prepare: (data) ->
    title: data.title
    items: data.items
    metadata: data.meta
  
  constructor: (data) ->
    prepared = CsoSlide.prepare(data)
    super(prepared)

# ============================================
# 6. 继承中的双侧
# ============================================

class BaseSlide extends Slide
  @layout: "default"
  @defaultScale: "1.0"
  
  # 实例方法: 子类可覆盖
  transform: (data) -> data

class EnhancedSlide extends BaseSlide
  @layout: "mermaid"  # 覆盖类侧
  @defaultScale: "0.9"
  
  transform: (data) ->  # 覆盖实例方法
    data.chart = CHARTS[data.chartName] if data.chartName
    super(data)

# ============================================
# 使用示例
# ============================================

console.log "=== 双侧编程演示 ==="

# 1. 类侧模板
console.log "\n1. 类侧模板:"
console.log "   ChartSlide.scale:", ChartSlide.scale
console.log "   ConfiguredSection.maxSlides:", ConfiguredSection.maxSlides

# 2. 实例侧数据
console.log "\n2. 实例侧数据:"
data1 = new DataSlide("目标1", ["A", "B"], { author: "John" })
data2 = new DataSlide("目标2", ["C", "D"], { author: "Jane" })
console.log "   data1._metadata:", data1._metadata
console.log "   data2._metadata:", data2._metadata

# 3. 类方法
console.log "\n3. 类方法创建:"
目标数据 = [
  { title: "短期目标", items: ["提高治愈率"] }
  { title: "中期目标", items: ["优化流程"] }
]
目标章节 = SmartSection.createFromArray(目标数据)
console.log "   目标章节 幻灯片数:", 目标章节.count()

# 4. @cso 模式
console.log "\n4. @cso 模式:"
csoData = { title: "测试标题", items: ["项1", "项2"], meta: { version: 1 } }
csoSlide = new CsoSlide(csoData)
console.log "   csoSlide.title:", csoSlide.title

# 5. 类侧继承
console.log "\n5. 类侧继承:"
console.log "   EnhancedSlide.layout:", EnhancedSlide.layout
console.log "   EnhancedSlide.defaultScale:", EnhancedSlide.defaultScale

# 6. 创建完整演示文稿
console.log "\n6. 创建演示文稿:"

class 演示 extends Presentation
  constructor: ->
    super("双侧编程演示")
    @addSlide(new TitleSlide("双侧编程", "类侧 vs 实例侧"))
    @add(章节1)

await (new 演示()).generate("dual-side-demo")

console.log "\n✅ 双侧编程演示完成!"
