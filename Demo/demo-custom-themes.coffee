# BoxesPlus - 自定义主题演示

{ 
  Slide, TitleSlide, ContentSlide, ListSlide,
  Section, Presentation,
  createCustomTheme, getThemeColors, getThemePptxConfig
} = require "../api/declarative-api.coffee"

# 创建自定义主题
CustomCorpTheme = createCustomTheme
  name: "custom-corp"
  primary: "#1e3a8a"
  secondary: "#3b82f6"
  accent: "#f59e0b"
  danger: "#ef4444"
  background: "#f8fafc"
  text: "#1e293b"
  muted: "#64748b"
  lightBg: "#e2e8f0"
  darkBg: "#0f172a"
  titleFontSize: 48
  headingFontSize: 36
  bodyFontSize: 20
  titleColor: "FFFFFF"
  titleFill: "1e3a8a"

# 创建渐变风格主题
GradientTheme = createCustomTheme
  name: "gradient"
  primary: "#667eea"
  secondary: "#764ba2"
  accent: "#f093fb"
  danger: "#f5576c"
  background: "#fafafa"
  text: "#2d3748"
  muted: "#718096"
  lightBg: "#f3f4f6"
  darkBg: "#1a202c"

class 欢迎页 extends TitleSlide
  @subtitle: "BoxesPlus 自定义主题演示"

class 自定义主题 extends ContentSlide
  @定义: "使用 createCustomTheme 创建"
  @颜色: "可自定义所有颜色值"
  @字号: "可自定义字体大小"
  @导出: "支持 HTML 和 PPTX"

class 企业主题 extends ContentSlide
  @主色调: "深蓝色 #1e3a8a"
  @辅色调: "蓝色 #3b82f6"
  @点缀色: "橙色 #f59e0b"
  @适用: "企业介绍、商务演示"

class 渐变主题 extends ContentSlide
  @风格: "现代渐变风格"
  @主色: "紫色系 #667eea → #764ba2"
  @效果: "时尚、年轻、有活力"
  @适用: "创意展示、个人品牌"

class 使用方法 extends ListSlide
  @步骤一: "导入 createCustomTheme"
  @步骤二: "定义主题颜色和字号"
  @步骤三: "赋值给 Presentation"
  @步骤四: "调用生成方法"

class 结束页 extends ContentSlide
  @感谢: "感谢使用 BoxesPlus!"
  @探索: "尝试创建自己的主题"
  @主题: "8种预设 + 无限自定义"

class 第一章 extends Section
  @slides: -> [
    欢迎页
    自定义主题
  ]

class 第二章 extends Section
  @slides: -> [
    企业主题
    渐变主题
  ]

class 第三章 extends Section
  @slides: -> [
    使用方法
    结束页
  ]

# 使用预设主题
class 演示一 extends Presentation
  @theme: "blue"
  @sections: -> [第一章]
  @now: @newPresentation()

# 使用自定义主题
class 企业演示 extends Presentation
  @theme: CustomCorpTheme
  @sections: -> [第一章]
  @now: @newPresentation()

# 使用渐变主题
class 创意演示 extends Presentation
  @theme: GradientTheme
  @sections: -> [第一章]
  @now: @newPresentation()

console.log "✅ 自定义主题演示准备就绪!"
