# BoxesPlus - 同一内容，不同风格演示
# 展示"换衣服"概念：同样的数据，不同的展示方式

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, CardSlide,
  ComparisonSlide, ProcessSlide, TimelineSlide, QuoteSlide,
  Section, Presentation
} = require "../api/declarative-api.coffee"

# ============================================
# 同一数据，不同展示
# ============================================

# 品牌建设核心内容
品牌数据 =
  定位: "明确品牌定位，确立差异化竞争优势"
  传播: "制定传播策略，持续传递品牌价值"
  管理: "建立品牌管理体系，确保一致性"
  评估: "定期评估效果，持续改进优化"

# 方式1: ContentSlide - 列表形式
class 品牌建设列表 extends ContentSlide
  @定位: 品牌数据.定位
  @传播: 品牌数据.传播
  @管理: 品牌数据.管理
  @评估: 品牌数据.评估

# 方式2: QuoteSlide - 引用形式
class 品牌建设引用 extends QuoteSlide
  @品牌专家: "品牌是企业最重要的无形资产"

# 方式3: ComparisonSlide - 对比形式
class 方式对比 extends ComparisonSlide
  @传统方式: "手动制作 PPT\n耗时 2-3 小时\n格式不统一"
  @BoxesPlus: "代码生成 PPT\n耗时 5 分钟\n风格统一"

# 章节定义
class 第一章 extends Section
  @slides: -> [品牌建设列表]

class 第二章 extends Section
  @slides: -> [品牌建设引用]

class 第三章 extends Section
  @slides: -> [方式对比]

# 演示文稿
class 同一内容不同风格 extends Presentation
  @sections: -> [
    第一章
    第二章
    第三章
  ]
  
  @now: @newPresentation()

console.log "✅ 同一内容不同风格演示准备就绪!"
