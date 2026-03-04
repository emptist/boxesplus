# BoxesPlus - Declarative API 演示
# 结合声明式设计 + Mermaid图表

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, MermaidSlide,
  Section, Presentation, CHARTS,
  PDCA, SWOT, Timeline
} = require "../api/declarative-api.coffee"

# ============================================
# 方式1: 直接使用类属性定义数据
# ============================================

# 定义幻灯片 - 类名就是标题
class 品牌定义 extends ContentSlide
  @定义: "品牌是一个名称、术语、符号或设计"
  @公式: "品牌 = 产品功能 + 情感价值 + 品牌认知"

class 品牌要素 extends ListSlide
  @要素1: "品牌定位 - 在消费者心智中的独特位置"
  @要素2: "品牌价值 - 超越功能价值的情感认同"
  @要素3: "品牌传播 - 持续、一致的品牌信息"

# ============================================
# 方式2: 使用 Mermaid 图表
# ============================================

class PDCA循环 extends MermaidSlide
  @chart: CHARTS.pdca

class 质量体系 extends MermaidSlide
  @chart: CHARTS.qualitySystem
  @scale: "0.85"

class 品牌金字塔 extends MermaidSlide
  @chart: CHARTS.brandPyramid

# ============================================
# 方式3: 函数延迟解析 (声明式核心!)
# ============================================

class 第一章 extends Section
  @slides: -> [
    品牌定义
    品牌要素
    PDCA循环
  ]

class 第二章 extends Section
  @slides: -> [
    质量体系
    品牌金字塔
  ]

# ============================================
# 方式4: 自动生成 (声明式核心!)
# ============================================

class DeclarativeDemo extends Presentation
  @sections: -> [
    第一章
    第二章
  ]
  
  # 自动运行！
  @now: @newPresentation()

console.log "✅ Declarative API demo ready!"
