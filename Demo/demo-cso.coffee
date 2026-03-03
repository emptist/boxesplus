# BoxesPlus - @cso 模式演示
# 展示类侧初始化的强大能力

{ Slide, Section, Presentation, MermaidSlide, ListSlide, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# @cso 模式: 类侧初始化器
# ============================================

# 方式1: 使用 @cso 定义类侧初始化
class TopicSlide extends Slide
  @layout: "mermaid"
  @scale: "0.85"
  
  # @cso 接收配置,返回幻灯片数据
  @cso: (topicName) ->
    title: "#{topicName}流程"
    chart: CHARTS[topicName.toLowerCase()] or CHARTS.pdca

# 使用 @cso
slide1 = TopicSlide.cso("EventLoop")  # 类侧调用
slide2 = TopicSlide.cso("DataLifecycle")

# 方式2: 使用 @dataPrepare (更明确的命名)
class PreparedSlide extends Slide
  @layout: "list"
  
  @dataPrepare: (config) ->
    title: config.title
    items: config.items
    metadata: config.metadata
  
  constructor: (config) ->
    # 覆盖 toData 以包含 metadata
    data = PreparedSlide.dataPrepare(config)
    super(data)

# 方式3: 子类继承 + 构造函数
class InheritedSlide extends MermaidSlide
  @title: "默认标题"
  
  constructor: (title, chart, scale = "0.9") ->
    super(InheritedSlide.title, chart, scale)

# ============================================
# Section 的 @cso 模式
# ============================================

class TopicSection extends Section
  @title: "主题章节"
  @topics: []
  
  # 类方法: 从主题列表创建幻灯片
  @cso: (topics) ->
    for topic in topics
      new MermaidSlide("#{topic}流程", CHARTS[topic.toLowerCase()], "0.85")

# 使用 Section 的 @cso
章节数据 = ["EventLoop", "DataLifecycle", "QualitySystem"]
章节 = TopicSection.cso(章节数据)

# ============================================
# Presentation 的 @cso 模式
# ============================================

class TemplatePresentation extends Presentation
  @title: "模板演示"
  
  # 类侧定义章节
  @sections: [
    class Quality extends Section
      @title: "质量管理"
      constructor: ->
        super("质量管理")
        @add(MermaidSlide.cso("Pdca"))
        @add(MermaidSlide.cso("EventLoop"))
    
    class Safety extends Section
      @title: "安全管理"
      constructor: ->
        super("安全管理")
        @add(MermaidSlide.cso("PatientSafety"))
  ]

# ============================================
# 完整示例
# ============================================

console.log "=== @cso 模式演示 ==="

# 使用继承的幻灯片
pdca = new InheritedSlide("PDCA循环", CHARTS.pdca)
eventLoop = new InheritedSlide("事件闭环", CHARTS.eventLoop)

# 创建演示文稿
课程 = new Presentation("@cso 模式演示")
课程
  .addSlide(new Slide({title: "欢迎", layout: "title", subtitle: "类侧初始化演示"}))
  .addSlide(pdca)
  .addSlide(eventLoop)
  .add(章节)

# 或者使用类侧
模板 = new TemplatePresentation()
console.log "模板演示幻灯片: #{模板.getAllSlides().length}"

# 生成
console.log "\n🚀 开始生成..."
await 课程.generate("cso-demo")

console.log "✅ @cso 演示完成!"
