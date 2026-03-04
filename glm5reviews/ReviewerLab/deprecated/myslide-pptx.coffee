# 用户文件：myslide.coffee
# 用户只需要定义类，然后调用 generate()

# 引入框架
{ Slide, Section, Chapter, Presentation } = require "./declarative-framework-pptx"

# 用户定义的幻灯片
class AI革命前教学平台定义 extends Slide
    @AI革命前: "那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
    @AI革命后: "AI革命后，教学平台发生了翻天覆地的变化。"

class AI革命后教学平台定义 extends Slide
    @核心观点: "AI革命后，教学平台发生了翻天覆地的变化。"
    @关键特征: "智能化、个性化、数据驱动"

# 用户定义的节
class 国际学科平台定义 extends Section
    @幻灯片: [
        AI革命前教学平台定义
        AI革命后教学平台定义
    ]

# 用户定义的章
class 学科平台定义 extends Chapter
    @节: [
        国际学科平台定义
    ]

# 用户定义的演示文稿
class 我的幻灯片 extends Presentation
    @sections: [
        学科平台定义
    ]

# 生成 PPTX
我的幻灯片.generate()
