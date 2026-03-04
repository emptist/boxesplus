# E02品牌建设课程 - 多版本演示
# 综合运用声明式框架的所有技术

# 引入框架
{ Slide, ContentSlide, CardSlide, TableSlide, Section, Chapter, Presentation } = require "./framework-v2"

# ============================================
# 第一版：普通Slide
# ============================================

class E02品牌建设课程第一版 extends Presentation
    @sections: -> [
        课程信息章第一版
    ]
    @nowYou: @newPresentation()

class 课程信息章第一版 extends Chapter
    @节: -> [
        课程信息节第一版
    ]

class 课程信息节第一版 extends Section
    @幻灯片: -> [
        课程名称第一版
        课程定位第一版
    ]

class 课程名称第一版 extends Slide
    @课程名称: "医院品牌建设与传播管理"
    @课程定位: "医院管理核心模块课程"
    @课程时长: "12小时（2天）"

class 课程定位第一版 extends Slide
    @教学方法: "理论讲授、方法演练、案例分析、课堂讨论、实操练习"

# ============================================
# 第二版：ContentSlide（列表形式）
# ============================================

class E02品牌建设课程第二版 extends Presentation
    @sections: -> [
        课程信息章第二版
    ]
    @nowYou: @newPresentation()

class 课程信息章第二版 extends Chapter
    @节: -> [
        课程信息节第二版
    ]

class 课程信息节第二版 extends Section
    @幻灯片: -> [
        课程名称第二版
        课程定位第二版
    ]

class 课程名称第二版 extends ContentSlide
    @课程名称: "医院品牌建设与传播管理"
    @课程定位: "医院管理核心模块课程"
    @课程时长: "12小时（2天）"

class 课程定位第二版 extends ContentSlide
    @教学方法: "理论讲授、方法演练、案例分析、课堂讨论、实操练习"

# ============================================
# 第三版：CardSlide（卡片形式）
# ============================================

class E02品牌建设课程第三版 extends Presentation
    @sections: -> [
        课程信息章第三版
    ]
    @nowYou: @newPresentation()

class 课程信息章第三版 extends Chapter
    @节: -> [
        课程信息节第三版
    ]

class 课程信息节第三版 extends Section
    @幻灯片: -> [
        课程名称第三版
        课程定位第三版
    ]

class 课程名称第三版 extends CardSlide
    @课程名称: "医院品牌建设与传播管理"
    @课程定位: "医院管理核心模块课程"
    @课程时长: "12小时（2天）"

class 课程定位第三版 extends CardSlide
    @教学方法: "理论讲授、方法演练、案例分析、课堂讨论、实操练习"

# ============================================
# 第四版：TableSlide（表格形式）
# ============================================

class E02品牌建设课程第四版 extends Presentation
    @sections: -> [
        课程信息章第四版
    ]
    @nowYou: @newPresentation()

class 课程信息章第四版 extends Chapter
    @节: -> [
        课程信息节第四版
    ]

class 课程信息节第四版 extends Section
    @幻灯片: -> [
        课程名称第四版
        课程定位第四版
    ]

class 课程名称第四版 extends TableSlide
    @课程名称: "医院品牌建设与传播管理"
    @课程定位: "医院管理核心模块课程"
    @课程时长: "12小时（2天）"

class 课程定位第四版 extends TableSlide
    @教学方法: "理论讲授、方法演练、案例分析、课堂讨论、实操练习"

# ============================================
# 完成！
# ============================================
