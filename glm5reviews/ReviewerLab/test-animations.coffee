# BoxesPlus - 动画系统实验
# 测试各种动画效果

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, Section, Presentation
} = require "./declarative-pptx-api/index"

{ Animation, SlideAnimation } = require "./animations"

class 欢迎页 extends TitleSlide
  @subtitle: "BoxesPlus 动画系统实验"

class 动画类型 extends ListSlide
  @fade: "淡入 - 从透明到不透明"
  @slide: "滑入 - 从侧面滑入"
  @bounce: "弹跳 - 弹跳效果"
  @zoom: "缩放 - 从小到大"
  @flip: "翻转 - 3D 翻转"
  @shake: "抖动 - 左右抖动"
  @pulse: "脉动 - 缩放脉动"
  @slideUp: "上滑 - 从下方滑入"
  @slideDown: "下滑 - 从上方滑入"
  @slideLeft: "左滑 - 从右侧滑入"
  @slideRight: "右滑 - 从左侧滑入"

class 动画速度 extends ListSlide
  @fast: "快速 - 0.2 秒"
  @normal: "正常 - 0.5 秒"
  @slow: "慢速 - 1 秒"
  @verySlow: "非常慢 - 2 秒"

class 缓动函数 extends ListSlide
  @linear: "线性 - 匀速运动"
  @ease: "缓动 - 缓慢开始和结束"
  @easeIn: "缓入 - 缓慢开始"
  @easeOut: "缓出 - 缓慢结束"
  @easeInOut: "缓入缓出 - 缓慢开始和结束"
  @bounce: "弹跳 - 弹跳效果"

class CSS动画生成 extends ContentSlide
  @自动生成: "自动生成 CSS 动画代码"
  @PPTX导出: "支持 PPTX 动画效果"
  @动画序列: "支持多个动画组合"
  @交错动画: "列表项依次出现，增强节奏感"

class 动画特性 extends ContentSlide
  @类型丰富: "10 种动画类型"
  @速度控制: "4 种速度选项"
  @缓动函数: "5 种缓动函数"
  @灵活组合: "可以自由组合类型、速度、缓动"

class 应用场景 extends ContentSlide
  @标题动画: "标题可以使用淡入或缩放"
  @列表动画: "列表可以使用滑入或弹跳"
  @强调动画: "重要内容可以使用抖动或脉动"
  @过渡动画: "页面切换可以使用翻转或缩放"

class 结束页 extends ContentSlide
  @感谢: "感谢使用 BoxesPlus 动画系统!"
  @探索: "发现更多动画效果"

class 第一章 extends Section
  @slides: -> [
    欢迎页
    动画类型
  ]

class 第二章 extends Section
  @slides: -> [
    动画速度
    缓动函数
    CSS动画生成
  ]

class 第三章 extends Section
  @slides: -> [
    动画特性
    应用场景
    结束页
  ]

class 动画系统实验 extends Presentation
  @theme: "blue"
  @sections: -> [
    第一章
    第二章
    第三章
  ]
  
  @now: @newPresentation()

console.log "✅ 动画系统实验准备就绪!"
console.log "📊 动画类型:", Object.keys(Animation.types)
console.log "⏱️  动画速度:", Object.keys(Animation.durations)
console.log "🎨 缓动函数:", Object.keys(Animation.easings)
