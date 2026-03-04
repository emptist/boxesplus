# BoxesPlus - Declarative Presentation Framework
# CoffeeScript 独特特性：用户定义类，框架递归追踪

fs = require "fs"

# ============================================
# 基础类（工具层）
# ============================================

class Slide
class Section
class Chapter
class Presentation

# ============================================
# 核心工具函数
# ============================================

getBaseClassName = (klass) ->
    superClass = Object.getPrototypeOf(klass)
    superClass?.name || 'Slide'

getProperties = (klass) ->
    props = {}
    for key, value of klass
        unless key in ['name', 'length', 'prototype']
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
# 生成函数
# ============================================

generate = (presentationClass, outputPath = "outputs/generated.html") ->
    console.log "\n🚀 Generating presentation from: #{presentationClass.name}\n"
    
    # 递归追踪
    data = traverse(presentationClass)
    
    # 生成
    generateHtml(data, outputPath)
    
    console.log "\n🎉 Generation complete!\n"

# ============================================
# 导出
# ============================================

module.exports = {
    Slide
    Section
    Chapter
    Presentation
    generate
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

    # 生成（用户只需要这一行）
    generate 我的幻灯片, "outputs/my-vision-final.html"
