# BoxesPlus - Declarative Presentation Framework
# 声明式演示文稿框架 - 利用 CoffeeScript 独特特性

fs = require "fs"

# ============================================
# 全局注册表
# ============================================

global.__boxesplus_registry__ =
    slides: []
    sections: []
    chapters: []
    presentations: []

# ============================================
# 基础类（工具层）- 利用 CoffeeScript 独特特性
# ============================================

# CoffeeScript 独特特性：
# 1. 类定义时就可以执行代码
# 2. 子类继承时，父类的静态方法会被调用
# 3. 不需要实例化，直接操作类本身

class Slide
    # CoffeeScript 独特特性：类定义时执行
    # 当子类继承时，这个代码块会执行
    @__inherited: (child) ->
        # 自动注册子类
        global.__boxesplus_registry__.slides.push(child)
        console.log "📝 Auto-registered slide: #{child.name}"

class Section
    @__inherited: (child) ->
        global.__boxesplus_registry__.sections.push(child)
        console.log "📝 Auto-registered section: #{child.name}"

class Chapter
    @__inherited: (child) ->
        global.__boxesplus_registry__.chapters.push(child)
        console.log "📝 Auto-registered chapter: #{child.name}"

class Presentation
    @__inherited: (child) ->
        global.__boxesplus_registry__.presentations.push(child)
        console.log "📝 Auto-registered presentation: #{child.name}"

# ============================================
# 核心工具函数
# ============================================

getBaseClassName = (klass) ->
    superClass = Object.getPrototypeOf(klass)
    superClass?.name || 'Slide'

getProperties = (klass) ->
    props = {}
    for key, value of klass
        unless key in ['name', 'length', 'prototype', 'extend', 'include', '__inherited']
            props[key] = value
    props

# ============================================
# 递归追踪器
# ============================================

traverse = (klass) ->
    baseClass = getBaseClassName(klass)
    title = klass.name
    properties = getProperties(klass)
    
    console.log "🔍 Traversing: #{title} (#{baseClass})"
    
    switch baseClass
        when 'Slide'
            traverseSlide(title, properties)
        
        when 'Section'
            traverseSection(title, properties)
        
        when 'Chapter'
            traverseChapter(title, properties)
        
        when 'Presentation'
            traversePresentation(title, properties)
        
        else
            console.warn "Unknown base class: #{baseClass}"
            traverseSlide(title, properties)

traverseSlide = (title, properties) ->
    content = []
    
    for key, value of properties
        valueType = typeof value
        
        if valueType is 'string'
            if value.match(/\.(png|jpg|jpeg|gif|svg)$/i)
                content.push
                    type: 'image'
                    label: key
                    src: value
            else
                content.push
                    type: 'text'
                    label: key
                    content: value
        
        else if valueType is 'object' and not Array.isArray(value)
            if value['图'] and value['文']
                content.push
                    type: 'image-text'
                    label: key
                    image: value['图']
                    text: value['文']
            else
                content.push
                    type: 'object'
                    label: key
                    data: value
        
        else if Array.isArray(value)
            content.push
                type: 'list'
                label: key
                items: value
    
    {
        type: 'slide'
        title: title
        content: content
    }

traverseSection = (title, properties) ->
    slidesKey = Object.keys(properties).find((k) -> 
        k in ['幻灯片', 'slides']
    )
    
    slides = if slidesKey then properties[slidesKey] else []
    
    {
        type: 'section'
        title: title
        slides: slides.map((s) -> traverse(s))
    }

traverseChapter = (title, properties) ->
    sectionsKey = Object.keys(properties).find((k) -> 
        k in ['节', 'sections', '章']
    )
    
    sections = if sectionsKey then properties[sectionsKey] else []
    
    {
        type: 'chapter'
        title: title
        sections: sections.map((s) -> traverse(s))
    }

traversePresentation = (title, properties) ->
    sectionsKey = Object.keys(properties).find((k) -> 
        k in ['sections', '章', 'parts']
    )
    
    sections = if sectionsKey then properties[sectionsKey] else []
    
    {
        type: 'presentation'
        title: title
        sections: sections.map((s) -> traverse(s))
    }

# ============================================
# HTML 生成器
# ============================================

generateHtml = (data, outputPath) ->
    slides = flattenSlides(data)
    
    html = """
    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>#{data.title}</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
        <style>
            .reveal .slides section { text-align: left; }
            .reveal { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; }
            .slide-content { margin: 20px; }
            .image-text { display: flex; gap: 20px; align-items: center; }
            .image-text img { max-width: 50%; }
        </style>
    </head>
    <body>
        <div class="reveal">
            <div class="slides">
                #{slides.map((s) -> renderSlideHtml(s)).join('\n')}
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
        <script>
            Reveal.initialize({
                hash: true,
                slideNumber: true,
                transition: 'slide',
                center: true,
                width: 1280,
                height: 720
            });
        </script>
    </body>
    </html>
    """
    
    fs.writeFileSync(outputPath, html)
    console.log "✅ Generated: #{outputPath}"

flattenSlides = (data) ->
    slides = []
    
    if data.type is 'presentation'
        for section in (data.sections || [])
            slides.push(...flattenSlides(section))
    
    else if data.type is 'chapter'
        for section in (data.sections || [])
            slides.push(...flattenSlides(section))
    
    else if data.type is 'section'
        for slide in (data.slides || [])
            slides.push(...flattenSlides(slide))
    
    else if data.type is 'slide'
        slides.push(data)
    
    slides

renderSlideHtml = (slide) ->
    contentHtml = slide.content.map((item) ->
        switch item.type
            when 'text'
                """
                <div class="text-block">
                    <h3>#{item.label}</h3>
                    <p>#{item.content}</p>
                </div>
                """
            
            when 'image'
                """
                <div class="image-block">
                    <h3>#{item.label}</h3>
                    <img src="#{item.src}" alt="#{item.label}" />
                </div>
                """
            
            when 'image-text'
                """
                <div class="image-text">
                    <img src="#{item.image}" alt="插图" />
                    <div>
                        <h3>#{item.label}</h3>
                        <p>#{item.text}</p>
                    </div>
                </div>
                """
            
            when 'list'
                items = item.items.map((i) -> "<li>#{i}</li>").join('')
                """
                <div class="list-block">
                    <h3>#{item.label}</h3>
                    <ul>#{items}</ul>
                </div>
                """
            
            else
                ""
    ).join('')
    
    """
    <section>
        <h2>#{slide.title}</h2>
        <div class="slide-content">
            #{contentHtml}
        </div>
    </section>
    """

# ============================================
# 自动生成函数
# ============================================

autoGenerate = (outputPath = "outputs/auto-generated.html") ->
    console.log "\n🚀 Auto-generating presentation...\n"
    
    registry = global.__boxesplus_registry__
    
    console.log "📊 Registry:"
    console.log "   - #{registry.slides.length} slides"
    console.log "   - #{registry.sections.length} sections"
    console.log "   - #{registry.chapters.length} chapters"
    console.log "   - #{registry.presentations.length} presentations"
    
    # 找到第一个 Presentation
    presentation = registry.presentations[0]
    
    unless presentation
        console.error "❌ No Presentation found!"
        return
    
    # 递归追踪
    data = traverse(presentation)
    
    # 生成
    generateHtml(data, outputPath)
    
    console.log "\n🎉 Auto-generation complete!\n"

# ============================================
# 导出
# ============================================

module.exports = {
    Slide
    Section
    Chapter
    Presentation
    autoGenerate
    traverse
}

# ============================================
# 测试
# ============================================

if require.main is module
    # 用户定义的幻灯片
    class AI革命前教学平台定义 extends Slide
        @AI革命前: "那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
        @AI革命后: "AI革命后，教学平台发生了翻天覆地的变化。"
        @插图: "AI革命前教学平台定义.png"

    class AI革命后教学平台定义 extends Slide
        @图文: {
            图: "AI革命后教学平台定义.png"
            文: "那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
        }

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

    # 自动生成（用户不需要调用）
    autoGenerate "outputs/my-vision-auto.html"
