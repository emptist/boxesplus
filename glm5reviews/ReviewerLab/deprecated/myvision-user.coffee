# myvision.coffee - 用户视角
# 只需要这一行，引入框架
{ Slide, Section, Chapter, Presentation, generate } = require "./declarative-framework"

# ============================================
# 用户定义幻灯片（内容层）
# ============================================

class AI革命前教学平台定义 extends Slide
    @AI革命前: "那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
    @AI革命后: "AI革命后，教学平台发生了翻天覆地的变化。"
    @插图: "AI革命前教学平台定义.png"

class AI革命后教学平台定义 extends Slide
    @图文: {
        图: "AI革命后教学平台定义.png"
        文: "那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
    }

class 国际学科平台定义 extends Section
    @幻灯片: [
        AI革命前教学平台定义
        AI革命后教学平台定义
    ]

class 国际教学平台定义 extends Section
    @幻灯片: [
        AI革命前教学平台定义
        AI革命后教学平台定义
    ]

class 学科平台定义 extends Chapter
    @节: [
        国际学科平台定义
    ]

class 教学平台定义 extends Chapter
    @节: [
        国际教学平台定义
    ]

class 教学平台建设 extends Chapter
    @章: [
        教学平台定义
    ]

class 学科平台建设 extends Chapter
    @章: [
        学科平台定义
    ]

class 我的幻灯片 extends Presentation
    @sections: [
        学科平台建设
        教学平台建设
    ]

# ============================================
# 自动生成（用户不需要修改）
# ============================================

generate 我的幻灯片, "outputs/my-vision.pptx"
