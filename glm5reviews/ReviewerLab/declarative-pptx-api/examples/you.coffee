# 用户文件：you.coffee
# 测试：使用函数延迟解析

# 引入框架
{ Slide, Section, Chapter, Presentation } = require "./framework-v2"

# 用户定义的演示文稿（放在最前面）
class 你的幻灯片 extends Presentation
    @sections: ->    # 使用函数延迟解析！
        [学科平台定义]
    
    # CoffeeScript 独特特性：类定义时执行代码
    @nowYou: @newPresentation()

# 用户定义的章（放在中间）
class 学科平台定义 extends Chapter
    @节: ->    # 使用函数延迟解析！
        [国际学科平台定义]

# 用户定义的节（放在中间）
class 国际学科平台定义 extends Section
    @幻灯片: ->    # 使用函数延迟解析！
        [AI革命前教学平台定义, AI革命后教学平台定义]

# 用户定义的幻灯片（放在最后）
class AI革命前教学平台定义 extends Slide
    @AI革命前: "那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
    @AI革命后: "AI革命后，教学平台发生了翻天覆地的变化。"

class AI革命后教学平台定义 extends Slide
    @核心观点: "AI革命后，教学平台发生了翻天覆地的变化。"
    @关键特征: "智能化、个性化、数据驱动"

# 完成！
# 用户只需要运行：coffee you.coffee
# 所有幻灯片都会自动生成
