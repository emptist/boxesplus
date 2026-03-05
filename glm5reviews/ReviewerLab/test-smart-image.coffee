# BoxesPlus - 智能图片处理实验
# 测试各种图片布局和功能

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, Section, Presentation
} = require "./declarative-pptx-api/index"

{ 
  SmartImage, ImageLayout, ImageGrid, ImageComparison, ImageCarousel, ImageWithText
} = require "./smart-image"

class 欢迎页 extends TitleSlide
  @subtitle: "BoxesPlus 智能图片处理实验"

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

class ImageLayout说明 extends ContentSlide
  @单图布局: "ImageLayout 用于单张图片的布局"
  @灵活配置: "可以配置布局、位置、适配模式"
  @标题支持: "支持图片标题和 alt 文本"
  @懒加载: "支持懒加载优化性能"

class ImageGrid说明 extends ContentSlide
  @网格布局: "ImageGrid 用于多张图片的网格布局"
  @列数控制: "可以控制列数和间距"
  @标题支持: "支持每张图片的标题"
  @PPTX导出: "支持 PPTX 导出"

class ImageComparison说明 extends ContentSlide
  @前后对比: "ImageComparison 用于图片前后对比"
  @滑块控制: "支持滑块控制对比程度"
  @标签支持: "支持修改前和修改后标签"
  @并排显示: "支持并排显示模式"

class ImageCarousel说明 extends ContentSlide
  @图片轮播: "ImageCarousel 用于图片轮播"
  @自动播放: "支持自动播放和手动切换"
  @间隔控制: "可以控制切换间隔"
  @指示器: "支持指示器显示当前图片"

class ImageWithText说明 extends ContentSlide
  @图文混排: "ImageWithText 用于图文混排"
  @位置控制: "可以控制图片和文字的位置"
  @比例控制: "可以控制图片和文字的比例"
  @PPTX导出: "支持 PPTX 导出"

class 应用场景 extends ContentSlide
  @产品展示: "使用 ImageLayout 展示产品图片"
  @相册展示: "使用 ImageGrid 展示相册"
  @效果对比: "使用 ImageComparison 展示效果对比"
  @轮播展示: "使用 ImageCarousel 展示轮播图片"
  @图文介绍: "使用 ImageWithText 展示图文介绍"

class 结束页 extends ContentSlide
  @感谢: "感谢使用 BoxesPlus 智能图片处理!"
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
    ImageLayout说明
    ImageGrid说明
    ImageComparison说明
  ]

class 第四章 extends Section
  @slides: -> [
    ImageCarousel说明
    ImageWithText说明
    应用场景
    结束页
  ]

class 智能图片处理实验 extends Presentation
  @theme: "green"
  @sections: -> [
    第一章
    第二章
    第三章
    第四章
  ]
  
  @now: @newPresentation()

console.log "✅ 智能图片处理实验准备就绪!"
console.log "📐 布局类型:", Object.keys(SmartImage.layouts)
console.log "📍 位置控制:", Object.keys(SmartImage.positions)
console.log "🎨 适配模式:", Object.keys(SmartImage.fitModes)
