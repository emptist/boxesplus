# BoxesPlus - 动画效果演示

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, Section, Presentation,
  Animation, Transition, AnimatedSlide
} = require "../api/declarative-api.coffee"

class 欢迎页 extends TitleSlide
  @subtitle: "BoxesPlus 动画效果"

class 淡入淡出 extends ContentSlide
  @效果: "fade - 最常用的淡入效果"
  @特点: "平滑过渡，不突兀"
  @适用: "所有类型的幻灯片"
  @duration: "normal 默认0.5秒"

class 滑入效果 extends ListSlide
  @slideLeft: "从左侧滑入"
  @slideRight: "从右侧滑入"
  @slideUp: "从底部上升"
  @slideDown: "从顶部下降"

class 缩放效果 extends ContentSlide
  @zoom: "从中心缩放出现"
  @特点: "有冲击力，吸引注意力"
  @适用: "重点内容、强调展示"
  @bounce: "弹跳效果更有趣"

class 特殊效果 extends ListSlide
  @flip: "3D翻转效果"
  @shake: "左右抖动"
  @pulse: "脉动缩放"
  @bounce: "弹跳入场"

class 速度控制 extends ListSlide
  @fast: "0.2秒 - 快速过渡"
  @normal: "0.5秒 - 默认速度"
  @slow: "1秒 - 慢速优雅"
  @verySlow: "2秒 - 非常缓慢"

class 交错动画 extends ContentSlide
  @特点: "列表项依次出现"
  @效果: "增强节奏感"
  @自动: "无需额外设置"
  @延迟: "每项延迟0.1秒"

class 悬停效果 extends ContentSlide
  @鼠标悬停: "轻微放大"
  @阴影: "添加投影效果"
  @过渡: "0.3秒平滑过渡"
  @交互: "增强用户体验"

class 结束页 extends ContentSlide
  @感谢: "感谢使用 BoxesPlus!"
  @动画: "让演示更生动"
  @探索: "发现更多效果"

class 第一章 extends Section
  @slides: -> [
    欢迎页
  ]

class 第二章 extends Section
  @slides: -> [
    淡入淡出
    滑入效果
  ]

class 第三章 extends Section
  @slides: -> [
    缩放效果
    特殊效果
  ]

class 第四章 extends Section
  @slides: -> [
    速度控制
    交错动画
    悬停效果
  ]

class 第五章 extends Section
  @slides: -> [
    结束页
  ]

class 动画演示 extends Presentation
  @theme: "purple"
  @sections: -> [
    第一章
    第二章
    第三章
    第四章
    第五章
  ]
  
  @now: @newPresentation()

console.log "✅ 动画演示准备就绪!"
