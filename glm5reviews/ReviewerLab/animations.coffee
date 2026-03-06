# BoxesPlus - 动画系统
# 幻灯片动画效果

class Animation
  @types:
    fade: "fadeIn"
    slide: "slideIn"
    bounce: "bounce"
    zoom: "zoomIn"
    flip: "flip"
    shake: "shake"
    pulse: "pulse"
    slideUp: "slideUp"
    slideDown: "slideDown"
    slideLeft: "slideLeft"
    slideRight: "slideRight"

  @durations:
    fast: "0.2s"
    normal: "0.5s"
    slow: "1s"
    verySlow: "2s"

  @easings:
    linear: "linear"
    ease: "ease"
    easeIn: "ease-in"
    easeOut: "ease-out"
    easeInOut: "ease-in-out"
    bounce: "cubic-bezier(0.68, -0.55, 0.265, 1.55)"

  @getAnimation: (type, duration = "normal", easing = "ease") ->
    animType = @types[type] or "fadeIn"
    dur = @durations[duration] or "0.5s"
    ease = @easings[easing] or "ease"
    
    name: animType
    duration: dur
    timing: ease

  @getCss: (type, direction = "left") ->
    dir = if direction is 'right' then '100%' else '-100%'
    animations = {
      fadeIn: """
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        .fadeIn { animation: fadeIn @duration @timing forwards; }
      """,
      slideIn: """
        @keyframes slideIn {
          from { transform: translateX(#{dir}); opacity: 0; }
          to { transform: translateX(0); opacity: 1; }
        }
        .slideIn { animation: slideIn @duration @timing forwards; }
      """,
      slideLeft: """
        @keyframes slideLeft {
          from { transform: translateX(-100%); opacity: 0; }
          to { transform: translateX(0); opacity: 1; }
        }
        .slideLeft { animation: slideLeft @duration @timing forwards; }
      """,
      slideRight: """
        @keyframes slideRight {
          from { transform: translateX(100%); opacity: 0; }
          to { transform: translateX(0); opacity: 1; }
        }
        .slideRight { animation: slideRight @duration @timing forwards; }
      """,
      slideUp: """
        @keyframes slideUp {
          from { transform: translateY(100%); opacity: 0; }
          to { transform: translateY(0); opacity: 1; }
        }
        .slideUp { animation: slideUp @duration @timing forwards; }
      """,
      slideDown: """
        @keyframes slideDown {
          from { transform: translateY(-100%); opacity: 0; }
          to { transform: translateY(0); opacity: 1; }
        }
        .slideDown { animation: slideDown @duration @timing forwards; }
      """,
      zoomIn: """
        @keyframes zoomIn {
          from { transform: scale(0); opacity: 0; }
          to { transform: scale(1); opacity: 1; }
        }
        .zoomIn { animation: zoomIn @duration @timing forwards; }
      """,
      bounce: """
        @keyframes bounce {
          0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
          40% { transform: translateY(-30px); }
          60% { transform: translateY(-15px); }
        }
        .bounce { animation: bounce @duration @timing forwards; }
      """,
      flip: """
        @keyframes flip {
          from { transform: perspective(400px) rotateY(0); }
          to { transform: perspective(400px) rotateY(360deg); }
        }
        .flip { animation: flip @duration @timing forwards; }
      """,
      shake: """
        @keyframes shake {
          0%, 100% { transform: translateX(0); }
          10%, 30%, 50%, 70%, 90% { transform: translateX(-10px); }
          20%, 40%, 60%, 80% { transform: translateX(10px); }
        }
        .shake { animation: shake @duration @timing forwards; }
      """,
      pulse: """
        @keyframes pulse {
          0% { transform: scale(1); }
          50% { transform: scale(1.05); }
          100% { transform: scale(1); }
        }
        .pulse { animation: pulse @duration @timing infinite; }
      """
    }
    
    animName = @types[type] or "fadeIn"
    (animations[animName] or animations.fadeIn)
      .replace(/@duration/g, @durations.normal)
      .replace(/@timing/g, @easings.ease)

  @generateAllCss: ->
    css = ""
    for type of @types
      css += @getCss(type) + "\n"
    css

class Transition
  @types:
    fade: "opacity"
    slide: "transform"
    zoom: "transform"
    color: "color"
    background: "background-color"

  @getTransition: (property = "all", duration = "0.3s", easing = "ease") ->
    prop = @types[property] or property
    "#{prop} #{duration} #{easing}"

  @getCss: (options = {}) ->
    property = options.property or "all"
    duration = options.duration or "0.3s"
    easing = options.easing or "ease"
    delay = options.delay or "0s"
    
    prop = @types[property] or property
    
    """
    transition: #{prop} #{duration} #{easing};
    transition-delay: #{delay};
    """

class SlideAnimation
  constructor: (options = {}) ->
    @enter = options.enter or "fade"
    @exit = options.exit or "fade"
    @duration = options.duration or "normal"
    @delay = options.delay or 0
    @stagger = options.stagger or 0.1

  toHtml: (options = {}) ->
    enterAnim = Animation.getAnimation(@enter, @duration)
    delay = @delay + (options.index or 0) * @stagger
    
    "style=\"animation-delay: #{delay}s;\""

  getPptxOptions: ->
    pptxAnimations = {
      fade: "fade"
      slide: "slide"
      zoom: "zoom"
      bounce: "bounce"
      flip: "flip"
    }
    
    durationMs = {
      fast: 200
      normal: 500
      slow: 1000
      verySlow: 2000
    }
    
    {
      type: pptxAnimations[@enter] or "fade"
      duration: durationMs[@duration] or 500
      delay: @delay * 1000
    }

class AnimationSequence
  constructor: (animations = []) ->
    @animations = animations

  add: (anim) ->
    @animations.push(anim)
    this

  toHtml: ->
    @animations.map((a, i) -> 
      "<div class=\"anim-#{i}\" #{a.toHtml({index: i})}>#{a.html or ''}</div>"
    ).join("")

class AnimatedSlide
  @animation: null
  @transition: null
  
  @setAnimation: (type, duration = "normal", delay = 0) ->
    @animation = new SlideAnimation({ enter: type, duration, delay })
  
  @setTransition: (property = "all", duration = "0.3s") ->
    @transition = new Transition({ property, duration })

  @getAnimationCss: ->
    return "" unless @animation
    Animation.getCss(@animation.enter)

module.exports = {
  Animation
  Transition
  SlideAnimation
  AnimationSequence
  AnimatedSlide
}
