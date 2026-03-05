# BoxesPlus - 智能图片演示

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, Section, Presentation,
  ImageLayout, ImageGrid, ImageComparison, ImageWithText
} = require "../api/declarative-api.coffee"

class 欢迎页 extends TitleSlide
  @subtitle: "BoxesPlus 智能图片处理"

class 布局类型 extends ListSlide
  @Full: "100% 宽度，全屏展示"
  @Half: "50% 宽度，半屏显示"
  @Third: "33% 宽度，三分之一"
  @Quarter: "25% 宽度，四分之一"
  @Left: "60% 宽度，左侧主图"
  @Right: "40% 宽度，右侧主图"

class 位置控制 extends ListSlide
  @Center: "居中显示"
  @Left: "靠左对齐"
  @Right: "靠右对齐"
  @Top: "顶部对齐"
  @Bottom: "底部对齐"

class 适配模式 extends ListSlide
  @Cover: "覆盖整个容器"
  @Contain: "完整显示在容器内"
  @Fill: "拉伸填充"
  @ScaleDown: "缩小适应"

class 功能特点 extends ContentSlide
  @自动计算: "根据容器尺寸计算最佳显示"
  @懒加载: "支持图片懒加载优化性能"
  @PPT导出: "自动适配 PPTX 尺寸"
  @对比功能: "支持图片前后对比"
  @网格布局: "支持多图网格排列"
  @图文混排: "支持图片文字组合"

class 结束页 extends ContentSlide
  @感谢: "感谢使用 BoxesPlus!"
  @探索: "发现更多智能功能"

class 第一章 extends Section
  @slides: -> [
    欢迎页
    布局类型
  ]

class 第二章 extends Section
  @slides: -> [
    位置控制
    适配模式
    功能特点
  ]

class 第三章 extends Section
  @slides: -> [
    结束页
  ]

class 智能图片演示 extends Presentation
  @theme: "blue"
  @sections: -> [
    第一章
    第二章
    第三章
  ]
  
  @now: @newPresentation()

console.log "✅ 智能图片演示准备就绪!"
