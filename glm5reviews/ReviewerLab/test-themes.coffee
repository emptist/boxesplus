# BoxesPlus - 主题系统实验
# 测试各种主题效果

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, Section, Presentation
} = require "./declarative-pptx-api/index"

{ 
  Theme, Themes, getTheme, createCustomTheme, getThemeColors, getThemePptxConfig
} = require "./themes"

class 欢迎页 extends TitleSlide
  @subtitle: "BoxesPlus 主题系统实验"

class 主题列表 extends ListSlide
  @default: "默认主题 - 蓝色主调"
  @blue: "蓝色主题 - 清新蓝色"
  @green: "绿色主题 - 自然绿色"
  @purple: "紫色主题 - 优雅紫色"
  @orange: "橙色主题 - 活力橙色"
  @dark: "暗色主题 - 深色模式"
  @corporate: "企业主题 - 商务风格"
  @medical: "医疗主题 - 专业医疗"

class 主题特点 extends ContentSlide
  @自动调整: "每个主题都支持智能布局，自动调整字体大小"
  @统一风格: "统一的视觉风格，专业配色方案"
  @快速切换: "一键切换不同主题"
  @企业形象: "符合企业形象，企业主题、医院主题等"
  @专业配色: "预定义的颜色方案，专业配色"

class 颜色方案 extends ContentSlide
  @primary: "主色调 - 主要强调色"
  @secondary: "次要色 - 辅助强调色"
  @accent: "强调色 - 特殊强调"
  @danger: "危险色 - 警告和错误"
  @background: "背景色 - 页面背景"
  @text: "文本色 - 主要文本"
  @muted: "弱化色 - 次要文本"
  @lightBg: "浅色背景 - 浅色区域"
  @darkBg: "深色背景 - 深色区域"

class 字体配置 extends ContentSlide
  @title: "标题字体 - 标题和副标题"
  @body: "正文字体 - 正文内容"
  @mono: "等宽字体 - 代码和数字"

class 字体大小 extends ContentSlide
  @titleFontSize: "标题字体大小 - 44px"
  @headingFontSize: "标题字体大小 - 32px"
  @bodyFontSize: "正文字体大小 - 18px"
  @smallFontSize: "小字体大小 - 14px"

class PPTX配置 extends ContentSlide
  @titleColor: "标题颜色 - PPTX 标题文本颜色"
  @titleFill: "标题填充 - PPTX 标题背景颜色"
  @headingColor: "标题颜色 - PPTX 标题文本颜色"
  @bodyColor: "正文颜色 - PPTX 正文文本颜色"
  @backgroundColor: "背景颜色 - PPTX 页面背景颜色"

class 自定义主题 extends ContentSlide
  @创建主题: "使用 createCustomTheme 创建自定义主题"
  @颜色定制: "可以自定义所有颜色"
  @字体定制: "可以自定义字体和字体大小"
  @PPTX定制: "可以自定义 PPTX 配置"

class 应用场景 extends ContentSlide
  @企业演示: "使用 corporate 主题"
  @医疗演示: "使用 medical 主题"
  @技术演示: "使用 blue 或 purple 主题"
  @环保演示: "使用 green 主题"
  @活力演示: "使用 orange 主题"
  @夜间演示: "使用 dark 主题"

class 结束页 extends ContentSlide
  @感谢: "感谢使用 BoxesPlus 主题系统!"
  @探索: "发现更多主题效果"

class 第一章 extends Section
  @slides: -> [
    欢迎页
    主题列表
  ]

class 第二章 extends Section
  @slides: -> [
    主题特点
    颜色方案
  ]

class 第三章 extends Section
  @slides: -> [
    字体配置
    字体大小
    PPTX配置
  ]

class 第四章 extends Section
  @slides: -> [
    自定义主题
    应用场景
    结束页
  ]

class 主题系统实验 extends Presentation
  @theme: "purple"
  @sections: -> [
    第一章
    第二章
    第三章
    第四章
  ]
  
  @now: @newPresentation()

console.log "✅ 主题系统实验准备就绪!"
console.log "🎨 可用主题:", Object.keys(Themes)
console.log "🌈 主题颜色示例:"
for themeName of Themes
  colors = getThemeColors(themeName)
  console.log "  #{themeName}:", colors.primary
console.log "📊 PPTX 配置示例:"
for themeName of Themes
  pptxConfig = getThemePptxConfig(themeName)
  console.log "  #{themeName}:", pptxConfig.titleFill
