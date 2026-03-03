# BoxesPlus - @cso: @dataPrepare?() 模式演示
# 每个类定义自己的 @dataPrepare 和 @cso

{ Slide, Section, Presentation, MermaidSlide, ListSlide, TitleSlide, CHARTS } = require "../api/oo-api.coffee"

# ============================================
# @cso: @dataPrepare?() 用法
# 
# 1. 定义 @dataPrepare 方法
# 2. 在其后定义 @cso: @dataPrepare?()
# 3. 类加载时自动执行,结果存 @cso
# ============================================

# ============================================
# 示例1: 基础用法
# ============================================

class PDCA幻灯片 extends MermaidSlide
  @scale: "0.85"
  @dataPrepare: ->
    chart: CHARTS.pdca
  @cso: @dataPrepare?()
  
  constructor: ->
    super(PDCA幻灯片.name, PDCA幻灯片.cso?.chart, PDCA幻灯片.scale)

# ============================================
# 示例2: Section 批量定义
# ============================================

class 质量管理章节 extends Section
  @dataPrepare: ->
    slides: [
      { type: MermaidSlide, title: "PDCA循环", chart: CHARTS.pdca }
      { type: MermaidSlide, title: "柏拉图", chart: CHARTS.pareto }
      { type: ListSlide, title: "质量目标", items: ["目标1", "目标2"] }
    ]
  @cso: @dataPrepare?()
  
  constructor: ->
    super(质量管理章节.name)
    data = 质量管理章节.cso?.slides or []
    for sd in data
      if sd.type is MermaidSlide
        @add(new MermaidSlide(sd.title, sd.chart))
      else if sd.type is ListSlide
        @add(new ListSlide(sd.title, sd.items))

# ============================================
# 示例3: 动态内容
# ============================================

class 动态章节 extends Section
  @dataPrepare: ->
    # 直接定义,不使用 @enabled
    slides: [
      { type: ListSlide, title: "核心要点", items: ["要点A", "要点B"] }
      { type: MermaidSlide, title: "流程", chart: CHARTS.eventLoop }
    ]
  @cso: @dataPrepare?()
  
  constructor: ->
    super(动态章节.name)
    data = 动态章节.cso?.slides or []
    for sd in data
      if sd.type is ListSlide
        @add(new ListSlide(sd.title, sd.items))
      else if sd.type is MermaidSlide
        @add(new MermaidSlide(sd.title, sd.chart))

# ============================================
# 测试
# ============================================

console.log "=== @cso: @dataPrepare?() 演示 ==="

console.log "\n1. PDCA幻灯片.cso:"
console.log "   ", PDCA幻灯片.cso

console.log "\n2. 质量管理章节.cso:"
console.log "   幻灯片数:", 质量管理章节.cso?.slides?.length

console.log "\n3. 动态章节.cso:"
console.log "   enabled:", 动态章节.cso?.enabled
console.log "   幻灯片数:", 动态章节.cso?.slides?.length

# ============================================
# 创建实例
# ============================================

console.log "\n4. 创建实例:"

章节1 = new 质量管理章节()
console.log "   质量管理章节:", 章节1.count(), "张"

章节2 = new 动态章节()
console.log "   动态章节:", 章节2.count(), "张"

# ============================================
# 生成
# ============================================

课程 = new Presentation("@cso 演示")
课程.addSlide(new TitleSlide("@cso 模式", "类定义时自动准备数据"))
课程.add(章节1)
课程.add(章节2)

console.log "\n🚀 生成中..."
await 课程.generate("cso-demo-fixed")

console.log "\n✅ 完成!"
