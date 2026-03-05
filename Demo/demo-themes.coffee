# BoxesPlus - 主题演示
# 展示不同主题的效果

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, MermaidSlide,
  Section, Presentation, CHARTS,
  PDCA, Timeline, ComparisonSlide,
  Theme, Themes, getTheme
} = require "../api/declarative-api.coffee"

class 欢迎页 extends TitleSlide
  @subtitle: "BoxesPlus 主题系统演示"

class 主题介绍 extends ContentSlide
  @主题定义: "预定义颜色方案和样式"
  @可用主题: "default, blue, green, purple, orange, dark, corporate, medical"
  @使用方法: "@theme: '主题名'"

class 蓝色主题 extends ContentSlide
  @布局: "自动调整字体大小"
  @颜色: "蓝色系 #3182ce"
  @优势: "专业、冷静、商务"

class 绿色主题 extends ContentSlide
  @布局: "自动调整字体大小"
  @颜色: "绿色系 #38a169"
  @优势: "自然、健康、成长"

class 紫色主题 extends ContentSlide
  @布局: "自动调整字体大小"
  @颜色: "紫色系 #805ad5"
  @优势: "创意、优雅、高端"

class 橙色主题 extends ContentSlide
  @布局: "自动调整字体大小"
  @颜色: "橙色系 #dd6b20"
  @优势: "活力、热情、温暖"

class 医院主题 extends ContentSlide
  @适用场景: "医疗培训、学术报告"
  @颜色: "蓝色 #2b6cb0 + 绿色 #38a169"
  @专业感: "权威、专业、可信"

class 企业主题 extends ContentSlide
  @适用场景: "商务演示、公司介绍"
  @颜色: "深蓝 #002b5c + 橙色 #ff9900"
  @风格: "稳重、现代、国际"

class PDCA示例 extends PDCA

class 时间线示例 extends Timeline

class 对比示例 extends ComparisonSlide
  @有主题: "统一的视觉风格\n专业的颜色搭配\n提升品牌形象"
  @无主题: "默认样式\n缺乏特色\n千篇一律"

class 主题优势 extends ListSlide
  @一致性: "统一幻灯片风格"
  @效率: "快速切换主题"
  @品牌: "符合企业形象"
  @专业: "专业配色方案"

class 结束页 extends ContentSlide
  @感谢: "感谢使用 BoxesPlus!"
  @下一: "选择适合你的主题"
  @联系: "欢迎反馈和建议"

class 第一章 extends Section
  @slides: -> [
    欢迎页
    主题介绍
  ]

class 第二章 extends Section
  @slides: -> [
    蓝色主题
    绿色主题
    紫色主题
    橙色主题
  ]

class 第三章 extends Section
  @slides: -> [
    医院主题
    企业主题
    对比示例
  ]

class 第四章 extends Section
  @slides: -> [
    PDCA示例
    时间线示例
  ]

class 第五章 extends Section
  @slides: -> [
    主题优势
    结束页
  ]

class 主题演示 extends Presentation
  @theme: "blue"
  @sections: -> [
    第一章
    第二章
    第三章
    第四章
    第五章
  ]
  
  @now: @newPresentation()

console.log "✅ 主题演示准备就绪!"
