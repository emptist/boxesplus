# BoxesPlus - 主题系统
# 预设主题和颜色方案

class Theme
  @name: "default"
  @colors:
    primary: "#3182ce"
    secondary: "#38a169"
    accent: "#d69e2e"
    danger: "#e53e3e"
    background: "#ffffff"
    text: "#1a202c"
    muted: "#718096"
    lightBg: "#f7fafc"
    darkBg: "#2d3748"

  @fonts:
    title: "Arial, sans-serif"
    body: "Arial, sans-serif"
    mono: "Consolas, monospace"

  @sizes:
    titleFontSize: 44
    headingFontSize: 32
    bodyFontSize: 18
    smallFontSize: 14

  @pptx:
    titleColor: "FFFFFF"
    titleFill: "3182ce"
    headingColor: "1a202c"
    bodyColor: "4a5568"
    backgroundColor: "FFFFFF"

class BlueTheme extends Theme
  @name: "blue"
  @colors:
    primary: "#3182ce"
    secondary: "#63b3ed"
    accent: "#90cdf4"
    danger: "#fc8181"
    background: "#ebf8ff"
    text: "#2c5282"
    muted: "#4a5568"
    lightBg: "#bee3f8"
    darkBg: "#1a365d"

class GreenTheme extends Theme
  @name: "green"
  @colors:
    primary: "#38a169"
    secondary: "#68d391"
    accent: "#9ae6b4"
    danger: "#fc8181"
    background: "#f0fff4"
    text: "#22543d"
    muted: "#4a5568"
    lightBg: "#c6f6d5"
    darkBg: "#1c4532"

class PurpleTheme extends Theme
  @name: "purple"
  @colors:
    primary: "#805ad5"
    secondary: "#b794f4"
    accent: "#d6bcfa"
    danger: "#fc8181"
    background: "#faf5ff"
    text: "#44337a"
    muted: "#4a5568"
    lightBg: "#e9d8fd"
    darkBg: "#1a202c"

class OrangeTheme extends Theme
  @name: "orange"
  @colors:
    primary: "#dd6b20"
    secondary: "#ed8936"
    accent: "#f6ad55"
    danger: "#fc8181"
    background: "#fffaf0"
    text: "#7b341e"
    muted: "#4a5568"
    lightBg: "#feebc8"
    darkBg: "#7b341e"

class DarkTheme extends Theme
  @name: "dark"
  @colors:
    primary: "#63b3ed"
    secondary: "#68d391"
    accent: "#f6e05e"
    danger: "#fc8181"
    background: "#1a202c"
    text: "#f7fafc"
    muted: "#a0aec0"
    lightBg: "#2d3748"
    darkBg: "#171923"

  @pptx:
    titleColor: "FFFFFF"
    titleFill: "1a365d"
    headingColor: "f7fafc"
    bodyColor: "e2e8f0"
    backgroundColor: "1a202c"

class CorporateTheme extends Theme
  @name: "corporate"
  @colors:
    primary: "#002b5c"
    secondary: "#0066cc"
    accent: "#ff9900"
    danger: "#cc0000"
    background: "#f5f5f5"
    text: "#333333"
    muted: "#666666"
    lightBg: "#e6e6e6"
    darkBg: "#001a33"

  @pptx:
    titleColor: "FFFFFF"
    titleFill: "002b5c"
    headingColor: "002b5c"
    bodyColor: "333333"
    backgroundColor: "FFFFFF"

class MedicalTheme extends Theme
  @name: "medical"
  @colors:
    primary: "#2b6cb0"
    secondary: "#38a169"
    accent: "#3182ce"
    danger: "#e53e3e"
    background: "#f7fafc"
    text: "#2d3748"
    muted: "#718096"
    lightBg: "#bee3f8"
    darkBg: "#1a365d"

  @pptx:
    titleColor: "FFFFFF"
    titleFill: "2b6cb0"
    headingColor: "2b6cb0"
    bodyColor: "2d3748"
    backgroundColor: "FFFFFF"

Themes =
  default: Theme
  blue: BlueTheme
  green: GreenTheme
  purple: PurpleTheme
  orange: OrangeTheme
  dark: DarkTheme
  corporate: CorporateTheme
  medical: MedicalTheme

getTheme = (name) ->
  Themes[name] or Theme

createCustomTheme = (options = {}) ->
  class CustomTheme extends Theme
    @name: options.name or "custom"
    @colors:
      primary: options.primary or Theme.colors.primary
      secondary: options.secondary or Theme.colors.secondary
      accent: options.accent or Theme.colors.accent
      danger: options.danger or Theme.colors.danger
      background: options.background or Theme.colors.background
      text: options.text or Theme.colors.text
      muted: options.muted or Theme.colors.muted
      lightBg: options.lightBg or Theme.colors.lightBg
      darkBg: options.darkBg or Theme.colors.darkBg

    @fonts:
      title: options.titleFont or Theme.fonts.title
      body: options.bodyFont or Theme.fonts.body
      mono: options.monoFont or Theme.fonts.mono

    @sizes:
      titleFontSize: options.titleFontSize or Theme.sizes.titleFontSize
      headingFontSize: options.headingFontSize or Theme.sizes.headingFontSize
      bodyFontSize: options.bodyFontSize or Theme.sizes.bodyFontSize
      smallFontSize: options.smallFontSize or Theme.sizes.smallFontSize

    @pptx:
      titleColor: options.titleColor or Theme.pptx.titleColor
      titleFill: options.titleFill or Theme.pptx.titleFill
      headingColor: options.headingColor or Theme.pptx.headingColor
      bodyColor: options.bodyColor or Theme.pptx.bodyColor
      backgroundColor: options.backgroundColor or Theme.pptx.backgroundColor

  CustomTheme

getThemeColors = (themeName) ->
  theme = getTheme(themeName)
  theme.colors

getThemePptxConfig = (themeName) ->
  theme = getTheme(themeName)
  theme.pptx

module.exports = { Theme, Themes, getTheme, createCustomTheme, getThemeColors, getThemePptxConfig }
