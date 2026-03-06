# BoxesPlus - 智能图片处理
# 自动布局、优化和处理

fs = require "fs"
path = require "path"

class SmartImage
  @layouts:
    full: "100%"
    half: "50%"
    third: "33.33%"
    quarter: "25%"
    left: "60%"
    right: "40%"

  @positions:
    center: "center"
    left: "left"
    right: "right"
    top: "top"
    bottom: "bottom"

  @fitModes:
    cover: "cover"
    contain: "contain"
    fill: "fill"
    scaleDown: "scale-down"

  @getLayout: (layoutName) ->
    @layouts[layoutName] or @layouts.half

  @calculateAspectRatio: (width, height) ->
    return 16/9 unless width and height
    width / height

  @getOptimalSize: (containerWidth, containerHeight, imageWidth, imageHeight) ->
    containerRatio = containerWidth / containerHeight
    imageRatio = imageWidth / imageHeight
    
    if imageRatio > containerRatio
      width: containerWidth
      height: containerWidth / imageRatio
    else
      height: containerHeight
      width: containerHeight * imageRatio

  @isValidImage: (imagePath) ->
    return false unless imagePath
    ext = path.extname(imagePath).toLowerCase()
    ext in ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg']

  @generateSrcSet: (imagePath, sizes = [320, 640, 960, 1280]) ->
    return imagePath unless @isValidImage(imagePath)
    baseName = path.basename(imagePath, path.extname(imagePath))
    ext = path.extname(imagePath)
    dir = path.dirname(imagePath)
    
    srcset = sizes.map (size) ->
      "#{dir}/#{baseName}-#{size}w#{ext} #{size}w"
    .join(", ")
    
    srcset

class ImageLayout
  constructor: (options = {}) ->
    @layout = options.layout or "half"
    @position = options.position or "center"
    @fit = options.fit or "cover"
    @caption = options.caption or ""
    @alt = options.alt or ""
    @lazy = options.lazy ? true

  toHtml: (imagePath) ->
    return "" unless SmartImage.isValidImage(imagePath)
    
    layoutWidth = SmartImage.getLayout(@layout)
    fitMode = SmartImage.fitModes[@fit]
    position = SmartImage.positions[@position]
    
    lazyAttr = if @lazy then "loading=\"lazy\"" else ""
    
    captionHtml = if @caption
      "<p class=\"image-caption\">#{@caption}</p>"
    else ""
    
    """
    <div class="smart-image" style="width: #{layoutWidth};">
      <img src="#{imagePath}" alt="#{@alt}" style="object-fit: #{fitMode}; object-position: #{position};" #{lazyAttr}>
      #{captionHtml}
    </div>
    """

  toPptx: (pptx, imagePath, options = {}) ->
    return unless SmartImage.isValidImage(imagePath)
    
    layout = options.layout or @layout
    x = options.x or 0.5
    y = options.y or 1.5
    w = options.w or 6
    h = options.h or 4
    
    switch layout
      when "full"
        x = 0.5
        y = 0.5
        w = 9
        h = 5.5
      when "half"
        w = 4.5
        h = 4
      when "third"
        w = 3
        h = 4
      when "quarter"
        w = 2.25
        h = 2.5
      when "left"
        x = 0.5
        w = 5
        h = 5
      when "right"
        x = 5
        w = 4.5
        h = 5

    pptx.addImage({
      path: imagePath
      x: x
      y: y
      w: w
      h: h
      sizing: { type: 'contain', w: w, h: h }
    })

class ImageGrid
  constructor: (images = [], options = {}) ->
    @images = images
    @columns = options.columns or 2
    @gap = options.gap or "10px"
    @layout = options.layout or "half"
    @captions = options.captions or []

  toHtml: ->
    return "" if @images.length is 0
    
    imagesHtml = for image, i in @images
      caption = @captions[i] or ""
      captionHtml = if caption then "<p class=\"image-caption\">#{caption}</p>" else ""
      """
      <div class="grid-image" style="flex: #{100/@columns}%;">
        <img src="#{image}" loading="lazy" alt="Image #{i+1}">
        #{captionHtml}
      </div>
      """
    
    """
    <div class="image-grid" style="display: flex; flex-wrap: wrap; gap: #{@gap};">
      #{imagesHtml.join('')}
    </div>
    """

  toPptx: (pptx, options = {}) ->
    return if @images.length is 0
    
    x = options.x or 1
    y = options.y or 2
    w = options.w or 4
    h = options.h or 3
    gap = options.gap or 0.5
    
    for image, i in @images
      continue unless SmartImage.isValidImage(image)
      
      row = Math.floor(i / @columns)
      col = i % @columns
      
      px = x + (col * (w + gap))
      py = y + (row * (h + gap))
      
      pptx.addImage({
        path: image
        x: px
        y: py
        w: w
        h: h
        sizing: { type: 'contain', w: w, h: h }
      })

class ImageComparison
  constructor: (beforeImage, afterImage, options = {}) ->
    @beforeImage = beforeImage
    @afterImage = afterImage
    @beforeLabel = options.beforeLabel or "修改前"
    @afterLabel = options.afterLabel or "修改后"
    @slider = options.slider ? true

  toHtml: ->
    return "" unless @beforeImage and @afterImage
    
    if @slider
      """
      <div class="image-comparison">
        <div class="comparison-container">
          <img src="#{@beforeImage}" class="comparison-before" alt="Before">
          <img src="#{@afterImage}" class="comparison-after" alt="After">
          <input type="range" min="0" max="100" value="50" class="comparison-slider" oninput="updateComparison(this)">
          <div class="comparison-labels">
            <span>#{@beforeLabel}</span>
            <span>#{@afterLabel}</span>
          </div>
        </div>
      </div>
      <script>
        function updateComparison(slider) {
          var container = slider.parentElement;
          var after = container.querySelector('.comparison-after');
          after.style.clipPath = 'inset(0 ' + (100 - slider.value) + '% 0 0)';
        }
      </script>
      """
    else
      """
      <div class="image-comparison-sidebyside">
        <div class="comparison-item">
          <img src="#{@beforeImage}" alt="Before">
          <p>#{@beforeLabel}</p>
        </div>
        <div class="comparison-item">
          <img src="#{@afterImage}" alt="After">
          <p>#{@afterLabel}</p>
        </div>
      </div>
      """

  toPptx: (pptx, options = {}) ->
    return unless @beforeImage and @afterImage
    
    x = options.x or 0.5
    y = options.y or 2
    w = options.w or 4.25
    h = options.h or 4
    
    if SmartImage.isValidImage(@beforeImage)
      pptx.addImage({
        path: @beforeImage
        x: x
        y: y
        w: w
        h: h
      })
      pptx.addText(@beforeLabel, { x: x, y: y + h + 0.2, w: w, h: 0.3, fontSize: 12, color: "666666" })
    
    if SmartImage.isValidImage(@afterImage)
      pptx.addImage({
        path: @afterImage
        x: x + w + 0.5
        y: y
        w: w
        h: h
      })
      pptx.addText(@afterLabel, { x: x + w + 0.5, y: y + h + 0.2, w: w, h: 0.3, fontSize: 12, color: "666666" })

class ImageCarousel
  constructor: (images = [], options = {}) ->
    @images = images
    @interval = options.interval or 3000
    @autoPlay = options.autoPlay ? true
    @showDots = options.showDots ? true
    @captions = options.captions or []

  toHtml: ->
    return "" if @images.length is 0
    
    slidesHtml = for image, i in @images
      caption = @captions[i] or ""
      active = if i is 0 then "active" else ""
      """
      <div class="carousel-slide #{active}">
        <img src="#{image}" alt="Slide #{i+1}">
        #{if caption then "<div class='carousel-caption'>#{caption}</div>" else ""}
      </div>
      """
    
    dotsHtml = if @showDots
      dots = for image, i in @images
        active = if i is 0 then "active" else ""
        "<span class=\"carousel-dot #{active}\" onclick=\"showSlide(#{i})\"></span>"
      "<div class=\"carousel-dots\">#{dots.join('')}</div>"
    else ""
    
    autoPlayAttr = if @autoPlay then "autoplay" else ""
    
    """
    <div class="image-carousel" data-interval="#{@interval}">
      <div class="carousel-slides">
        #{slidesHtml.join('')}
      </div>
      #{dotsHtml}
    </div>
    <script>
      var currentSlide = 0;
      var slides = document.querySelectorAll('.carousel-slide');
      var interval = #{@interval};
      function showSlide(n) {
        slides.forEach(function(s, i) {
          s.classList.toggle('active', i === n);
        });
        currentSlide = n;
      }
      #{if @autoPlay then "setInterval(function() { showSlide((currentSlide + 1) % slides.length); }, interval);" else ""}
    </script>
    """

  toPptx: (pptx, options = {}) ->
    console.log "⚠️ ImageCarousel PPTX export: showing first image only"

class ImageWithText
  constructor: (imagePath, text, options = {}) ->
    @imagePath = imagePath
    @text = text
    @imagePosition = options.imagePosition or "left"
    @textPosition = options.textPosition or "right"
    @imageRatio = options.imageRatio or 50

  toHtml: ->
    return "" unless @imagePath
    
    imageHtml = "<img src=\"#{@imagePath}\" alt=\"Image\">"
    textHtml = "<div class=\"text-content\"><p>#{@text}</p></div>"
    
    flexDir = if @imagePosition in ["left", "top"] then "row" else "column"
    imageOrder = if @imagePosition in ["left", "top"] then 1 else 2
    textOrder = if @imagePosition in ["left", "top"] then 2 else 1
    
    """
    <div class="image-with-text" style="display: flex; flex-direction: #{flexDir}; gap: 20px; align-items: center;">
      <div class="image-part" style="flex: #{@imageRatio}; order: #{imageOrder};">#{imageHtml}</div>
      <div class="text-part" style="flex: #{100 - @imageRatio}; order: #{textOrder};">#{textHtml}</div>
    </div>
    """

  toPptx: (pptx, options = {}) ->
    return unless SmartImage.isValidImage(@imagePath)
    
    x = options.x or 0.5
    y = options.y or 1.5
    w = options.w or 9
    h = options.h or 5
    
    imageW = if @imagePosition in ["left", "right"] then w * (@imageRatio / 100) else w
    textW = w - imageW - 0.3
    
    if @imagePosition in ["left", "top"]
      imageX = x
      textX = x + imageW + 0.3
    else
      textX = x
      imageX = x + textW + 0.3
    
    pptx.addImage({
      path: @imagePath
      x: imageX
      y: y
      w: imageW
      h: h
    })
    
    pptx.addText(@text, { x: textX, y: y, w: textW, h: h, fontSize: 16, color: "333333" })

module.exports = {
  SmartImage
  ImageLayout
  ImageGrid
  ImageComparison
  ImageCarousel
  ImageWithText
}
