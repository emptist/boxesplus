# BoxesPlus - PDF 导出配置
# 支持高质量、自定义边距、页眉页脚等

class PdfConfig
  @presets:
    default:
      quality: "high"
      format: "letter"
      landscape: true
      margin: "10mm"
      printBackground: true
    
    high:
      quality: "high"
      format: "letter"
      landscape: true
      margin: "5mm"
      printBackground: true
    
    low:
      quality: "medium"
      format: "letter"
      landscape: true
      margin: "15mm"
      printBackground: false
    
    a4:
      quality: "high"
      format: "a4"
      landscape: true
      margin: "10mm"
      printBackground: true
    
    a4portrait:
      quality: "high"
      format: "a4"
      landscape: false
      margin: "15mm"
      printBackground: true
    
    presentation:
      quality: "high"
      format: "letter"
      landscape: true
      margin: "0mm"
      printBackground: true
    
    draft:
      quality: "low"
      format: "letter"
      landscape: true
      margin: "20mm"
      printBackground: false

  @formats:
    letter: { width: "8.5in", height: "11in" }
    legal: { width: "8.5in", height: "14in" }
    a4: { width: "210mm", height: "297mm" }
    a3: { width: "297mm", height: "420mm" }
    tabloid: { width: "11in", height: "17in" }

  @qualities:
    low: { scale: 1 }
    medium: { scale: 1.5 }
    high: { scale: 2 }
    ultra: { scale: 3 }

  @getPreset: (name) ->
    @presets[name] or @presets.default

  @mergeOptions: (presetName, overrides = {}) ->
    preset = @getPreset(presetName)
    { ...preset, ...overrides }

  @getFormatSize: (format, landscape = true) ->
    size = @formats[format] or @formats.letter
    if landscape
      { width: size.height, height: size.width }
    else
      size

  @getScale: (quality) ->
    @qualities[quality]?.scale or 1

class PdfHeader
  constructor: (options = {}) ->
    @text = options.text or ""
    @fontSize = options.fontSize or 10
    @color = options.color or "#666666"
    @align = options.align or "center"
    @margin = options.margin or "5mm"
    @showPageNumber = options.showPageNumber ? true
    @height = options.height or "15mm"

  toHtml: (title = "") ->
    pageNum = '<span class="page-number"></span>'
    text = @text.replace("{title}", title)
    
    """
    <div class="pdf-header" style="height: #{@height}; font-size: #{@fontSize}px; color: #{@color}; text-align: #{@align}; padding: #{@margin}; border-bottom: 1px solid #eee;">
      #{text}
      #{if @showPageNumber then pageNum else ""}
    </div>
    """

class PdfFooter
  constructor: (options = {}) ->
    @text = options.text or ""
    @fontSize = options.fontSize or 10
    @color = options.color or "#666666"
    @align = options.align or "center"
    @margin = options.margin or "5mm"
    @showPageNumber = options.showPageNumber ? true
    @height = options.height or "15mm"

  toHtml: (title = "") ->
    pageNum = '<span class="page-number"></span>'
    text = @text.replace("{title}", title)
    
    """
    <div class="pdf-footer" style="height: #{@height}; font-size: #{@fontSize}px; color: #{@color}; text-align: #{@align}; padding: #{@margin}; border-top: 1px solid #eee;">
      #{if @showPageNumber then pageNum else ""}
      #{text}
    </div>
    """

class PdfWatermark
  constructor: (options = {}) ->
    @text = options.text or ""
    @fontSize = options.fontSize or 40
    @color = options.color or "#eeeeee"
    @angle = options.angle or -45
    @opacity = options.opacity or 0.3
    @position = options.position or "center"

  toHtml: ->
    return "" unless @text
    
    """
    <div class="pdf-watermark" style="
      position: fixed;
      #{@position}: 50%;
      transform: translate(-50%, -50%) rotate(#{@angle}deg);
      font-size: #{@fontSize}px;
      color: #{@color};
      opacity: #{@opacity};
      pointer-events: none;
      z-index: 9999;
      white-space: nowrap;
    ">
      #{@text}
    </div>
    """

class PdfExport
  @config: (preset = "default", overrides = {}) ->
    PdfConfig.mergeOptions(preset, overrides)

  @header: (options = {}) ->
    new PdfHeader(options)

  @footer: (options = {}) ->
    new PdfFooter(options)

  @watermark: (options = {}) ->
    new PdfWatermark(options)

  @generateOptions: (config = {}) ->
    format = PdfConfig.getFormatSize(config.format, config.landscape)
    scale = PdfConfig.getScale(config.quality)
    
    options = {
      path: config.outputPath
      width: format.width
      height: format.height
      scale: scale
      printBackground: config.printBackground
      margin: config.margin or "0"
      displayHeaderFooter: config.showHeaderFooter ? false
      headerTemplate: config.headerHtml or ""
      footerTemplate: config.footerHtml or ""
    }

module.exports = {
  PdfConfig
  PdfHeader
  PdfFooter
  PdfWatermark
  PdfExport
}
