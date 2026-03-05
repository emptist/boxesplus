# BoxesPlus - 错误处理与验证系统
# 统一的错误处理、验证和回退机制

class ValidationError extends Error
  constructor: (message, field, value) ->
    super message
    @name = "ValidationError"
    @field = field
    @value = value
    @timestamp = new Date().toISOString()

class ValidationResult
  constructor: ->
    @errors = []
    @warnings = []
    @valid = true

  addError: (message, field, value) ->
    @errors.push({ message, field, value })
    @valid = false
    this

  addWarning: (message, field, value) ->
    @warnings.push({ message, field, value })
    this

  isValid: -> @valid

  hasErrors: -> @errors.length > 0

  hasWarnings: -> @warnings.length > 0

  getErrorMessages: -> @errors.map (e) -> e.message

  getWarningMessages: -> @warnings.map (w) -> w.message

  toString: ->
    parts = []
    parts.push("Errors: #{@errors.length}") if @errors.length > 0
    parts.push("Warnings: #{@warnings.length}") if @warnings.length > 0
    parts.join(", ")

class Validator
  @validateSlide: (slide) ->
    result = new ValidationResult()
    
    unless slide
      result.addError("Slide is undefined or null", "slide", slide)
      return result

    unless slide.type
      result.addWarning("Slide type not specified, defaulting to 'content'", "type", undefined)
      slide.type = "content"

    unless slide.title
      result.addWarning("Slide title is empty", "title", "")

    result

  @validatePresentation: (presentation) ->
    result = new ValidationResult()
    
    unless presentation
      result.addError("Presentation is undefined or null", "presentation", presentation)
      return result

    unless presentation.sections
      result.addWarning("No sections defined, creating empty presentation", "sections", undefined)
      presentation.sections = []

    unless presentation.sections.length > 0
      result.addWarning("Presentation has no sections", "sections", [])

    for section, i in (presentation.sections ? [])
      unless section.getSlides
        result.addError("Section #{i} is invalid - missing getSlides method", "section", section)
      else
        slides = section.getSlides()
        unless slides?.length > 0
          result.addWarning("Section #{i} has no slides", "slides", [])

    result

  @validateImage: (imagePath) ->
    result = new ValidationResult()
    return result unless imagePath

    validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg']
    ext = imagePath.toLowerCase().substring(imagePath.lastIndexOf('.'))
    
    unless ext in validExtensions
      result.addWarning("Image format may not be supported: #{ext}", "imagePath", imagePath)

    if imagePath.startsWith('http') or imagePath.startsWith('https')
      result.addWarning("Remote image - may fail if network unavailable", "imagePath", imagePath)

    result

  @validateMermaid: (chart) ->
    result = new ValidationResult()
    return result unless chart

    unless typeof chart is 'string'
      result.addError("Mermaid chart must be a string", "chart", typeof chart)
      return result

    if chart.trim().length < 10
      result.addWarning("Mermaid chart content is very short", "chart", chart)

    invalidKeywords = ['<script', 'javascript:', 'onerror', 'onclick']
    for keyword in invalidKeywords
      if chart.toLowerCase().includes(keyword)
        result.addError("Mermaid chart contains potentially unsafe content: #{keyword}", "chart", keyword)

    result

  @validateText: (text, options = {}) ->
    result = new ValidationResult()
    return result unless text

    minLength = options.minLength or 0
    maxLength = options.maxLength or Infinity

    if text.length < minLength
      result.addError("Text too short (min: #{minLength})", "text", text)

    if text.length > maxLength
      result.addWarning("Text too long, may be truncated (max: #{maxLength})", "text", text.substring(0, 100))

    result

  @validateTheme: (themeName) ->
    result = new ValidationResult()
    
    validThemes = ['default', 'blue', 'green', 'purple', 'orange', 'dark', 'corporate', 'medical']
    
    unless themeName
      result.addWarning("No theme specified, using default", "theme", themeName)
      return result

    unless themeName in validThemes
      result.addWarning("Unknown theme '#{themeName}', using default", "theme", themeName)

    result

class ErrorHandler
  @handlers: {}

  @registerHandler: (errorType, handler) ->
    @handlers[errorType] = handler

  @handle: (error, context = {}) ->
    console.error "❌ Error: #{error.message}"
    console.error "   Context:", context

    handler = @handlers[error.name] or @handlers.default
    
    if handler
      return handler(error, context)
    
    @logError(error, context)
    null

  @logError: (error, context) ->
    timestamp = new Date().toISOString()
    console.error """
    ╔═══════════════════════════════════════╗
    ║         ERROR REPORT                   ║
    ╠═══════════════════════════════════════╣
    ║ Time: #{timestamp}
    ║ Type: #{error.name}
    ║ Message: #{error.message}
    ║ Context: #{JSON.stringify(context)}
    ╚═══════════════════════════════════════╝
    """

  @registerDefaultHandler: (handler) ->
    @handlers.default = handler

class FallbackContent
  @slides:
    error: ->
      type: "content"
      title: "出错了"
      items: ["请检查输入内容", "查看控制台错误信息", "联系技术支持"]

    notFound: ->
      type: "content"
      title: "未找到内容"
      items: ["请检查路径是否正确", "文件可能已被移动或删除"]

    loading: ->
      type: "content"
      title: "加载中..."
      items: ["请稍候", "正在获取内容"]

    empty: ->
      type: "content"
      title: "暂无内容"
      items: ["请添加内容后重试"]

  @getFallback: (type) ->
    if @slides[type]
      @slides[type]()
    else
      @slides.empty()

  @wrapWithFallback: (content, fallbackType = "empty") ->
    if content then content else @getFallback(fallbackType)

class ErrorSlide
  @createErrorSlide: (error, options = {}) ->
    title: options.title or "错误"
    type: "content"
    items: [
      "错误类型: #{error.name}"
      "错误信息: #{error.message}"
      "发生时间: #{new Date().toLocaleString()}"
    ]

  @createNotFoundSlide: (item, options = {}) ->
    title: options.title or "未找到"
    type: "content"
    items: [
      "未找到: #{item}"
      "请检查路径是否正确"
      options.suggestion or "联系管理员获取帮助"
    ]

  @createWarningSlide: (warnings, options = {}) ->
    title: options.title or "警告"
    type: "content"
    items: warnings.map (w) -> "⚠️ #{w.message}"

class RetryHandler
  @maxRetries: 3
  @retryDelay: 1000

  @withRetry: (fn, options = {}) ->
    maxRetries = options.maxRetries or @maxRetries
    retryDelay = options.retryDelay or @retryDelay
    onRetry = options.onRetry or (() ->)
    
    attempt = 0
    
    retry = ->
      attempt++
      try
        fn()
      catch error
        if attempt < maxRetries
          console.warn "⚠️ Attempt #{attempt} failed, retrying in #{retryDelay}ms..."
          onRetry(error, attempt)
          setTimeout(retry, retryDelay)
        else
          console.error "❌ All #{maxRetries} attempts failed"
          throw error
    
    retry()

class ErrorBoundary
  constructor: (fallback = null) ->
    @fallback = fallback
    @errors = []

  wrap: (fn) ->
    try
      fn()
    catch error
      @errors.push(error)
      ErrorHandler.handle(error, { boundary: true })
      if @fallback then @fallback() else null

  hasErrors: -> @errors.length > 0

  getErrors: -> @errors

  clearErrors: -> @errors = []

module.exports = {
  ValidationError
  ValidationResult
  Validator
  ErrorHandler
  FallbackContent
  ErrorSlide
  RetryHandler
  ErrorBoundary
}
