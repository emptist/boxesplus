# BoxesPlus - @cso: @dataPrepare?() 模式演示
# 类定义时自动运行数据准备

{ Slide, Section, Presentation, MermaidSlide, ListSlide, TitleSlide, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# @cso: @dataPrepare?() 模式
# 
# 含义:
#   @cso = @dataPrepare?()
#   1. 类定义时自动调用 @dataPrepare()
#   2. ?() 表示可选,不存在不报错
#   3. 结果存储在 @cso 供后续使用
# 
# 用途:
#   - 批量定义幻灯片
#   - 条件生成内容
#   - 依赖注入(如 mermaid -> png)
# ============================================

# ============================================
# 示例1: Slide 类 - 静态数据
# ============================================

class PDCA模板 extends MermaidSlide
  @scale: "0.85"
  
  @dataPrepare: ->
    chart: CHARTS.pdca
  
  constructor: (title) ->
    chartData = PDCA模板.cso?.chart or CHARTS.pdca
    super(title or PDCA模板.name, chartData, PDCA模板.scale)

# ============================================
# 示例2: Section 类 - 批量幻灯片
# ============================================

class 质量管理章节 extends Section
  @dataPrepare: ->
    slides: [
      { type: MermaidSlide, title: "PDCA循环", chart: CHARTS.pdca }
      { type: MermaidSlide, title: "柏拉图", chart: CHARTS.pareto }
      { type: MermaidSlide, title: "质量体系", chart: CHARTS.qualitySystem }
    ]
  
  constructor: ->
    super(质量管理章节.name)
    data = 质量管理章节.cso?.slides or []
    for slideData in data
      @add(new slideData.type(slideData.title, slideData.chart))

# ============================================
# 示例3: 动态内容
# ============================================

class 动态章节 extends Section
  @dataPrepare: ->
    enabled: true
    slides: [
      { type: ListSlide, title: "核心目标", items: ["目标1", "目标2"] }
      { type: MermaidSlide, title: "流程图", chart: CHARTS.eventLoop }
    ]
  
  constructor: ->
    super(动态章节.name)
    data = 动态章节.cso?.slides or []
    for slideData in data
      if slideData.type is ListSlide
        @add(new ListSlide(slideData.title, slideData.items))
      else if slideData.type is MermaidSlide
        @add(new MermaidSlide(slideData.title, slideData.chart))

# ============================================
# 示例4: Mermaid -> PNG 自动化
# (伪代码,实际需要 puppeteer)
# ============================================

class 图表导出章节 extends Section
  @dataPrepare: ->
    # 模拟: 类定义时自动将 mermaid 导出为 PNG
    charts: [
      { name: "pdca", mermaid: CHARTS.pdca, png: "outputs/charts/pdca.png" }
      { name: "eventLoop", mermaid: CHARTS.eventLoop, png: "outputs/charts/eventLoop.png" }
    ]
  
  constructor: ->
    super(图表导出章节.name)
    data = 图表导出章节.cso?.charts or []
    for chartData in data
      # 实际使用时可引用 PNG 路径
      @add(new MermaidSlide(chartData.name, chartData.mermaid, "0.8"))

# ============================================
# 测试 @cso
# ============================================

console.log "=== @cso: @dataPrepare?() 演示 ==="

console.log "\n1. PDCA模板.cso (类定义时生成):"
console.log "   ", PDCA模板.cso

console.log "\n2. 质量管理章节.cso:"
console.log "   幻灯片数:", 质量管理章节.cso?.slides?.length

console.log "\n3. 动态章节.cso:"
console.log "   enabled:", 动态章节.cso?.enabled

console.log "\n4. 图表导出章节.cso:"
console.log "   图表数:", 图表导出章节.cso?.charts?.length

# ============================================
# 创建实例
# ============================================

console.log "\n5. 创建实例:"

章节1 = new 质量管理章节()
console.log "   质量管理章节 幻灯片数:", 章节1.count()

章节2 = new 动态章节()
console.log "   动态章节 幻灯片数:", 章节2.count()

章节3 = new 图表导出章节()
console.log "   图表导出章节 幻灯片数:", 章节3.count()

# ============================================
# 生成
# ============================================

课程 = new Presentation("@cso 模式演示")
课程.addSlide(new TitleSlide("@cso 模式", "类定义时自动准备数据"))
课程.add(章节1)
课程.add(章节2)
课程.add(章节3)

console.log "\n🚀 生成中..."
await 课程.generate("cso-pattern-demo")

console.log "\n✅ @cso 模式演示完成!"
