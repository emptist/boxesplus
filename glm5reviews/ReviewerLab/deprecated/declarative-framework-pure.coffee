# BoxesPlus - Declarative Presentation Framework
# 完全声明式设计：每个类声明自己的行为

fs = require "fs"

# ============================================
# Slide - 幻灯片类（声明式）
# ============================================

class Slide
    @toHtml: ->
        content = @renderContent()
        """
        <section>
            <h2>#{@name}</h2>
            <div class="slide-content">
                #{content}
            </div>
        </section>
        """
    
    @renderContent: ->
        properties = @getProperties()
        parts = []
        
        for key, value of properties
            part = @renderProperty(key, value)
            parts.push(part) if part
        
        parts.join('\n')
    
    @getProperties: ->
        props = {}
        for key, value of this
            unless key in ['name', 'length', 'prototype', 'toHtml', 'renderContent', 'getProperties', 'renderProperty']
                props[key] = value
        props
    
    @renderProperty: (key, value) ->
        if typeof value is 'string'
            if value.match(/\.(png|jpg|jpeg|gif|svg)$/i)
                """
                <div class="image-block">
                    <h3>#{key}</h3>
                    <img src="#{value}" alt="#{key}" />
                </div>
                """
            else
                """
                <div class="text-block">
                    <h3>#{key}</h3>
                    <p>#{value}</p>
                </div>
                """
        
        else if typeof value is 'object' and not Array.isArray(value)
            if value['图'] and value['文']
                """
                <div class="image-text">
                    <img src="#{value['图']}" alt="插图" />
                    <div>
                        <h3>#{key}</h3>
                        <p>#{value['文']}</p>
                    </div>
                </div>
                """
        
        else if Array.isArray(value)
            items = value.map((i) -> "<li>#{i}</li>").join('')
            """
            <div class="list-block">
                <h3>#{key}</h3>
                <ul>#{items}</ul>
            </div>
            """

# ============================================
# Section - 节类（声明式）
# ============================================

class Section
    @toHtml: ->
        slidesKey = Object.keys(this).find((k) -> k in ['幻灯片', 'slides'])
        slides = if slidesKey then this[slidesKey] else []
        
        slidesHtml = slides.map((s) -> s.toHtml()).join('\n')
        
        """
        <section class="section">
            <h1>#{@name}</h1>
            #{slidesHtml}
        </section>
        """

# ============================================
# Chapter - 章类（声明式）
# ============================================

class Chapter
    @toHtml: ->
        sectionsKey = Object.keys(this).find((k) -> k in ['节', 'sections', '章'])
        sections = if sectionsKey then this[sectionsKey] else []
        
        sectionsHtml = sections.map((s) -> s.toHtml()).join('\n')
        
        """
        <section class="chapter">
            <h1>#{@name}</h1>
            #{sectionsHtml}
        </section>
        """

# ============================================
# Presentation - 演示文稿类（声明式）
# ============================================

class Presentation
    @generate: (outputPath = "outputs/generated.html") ->
        console.log "\n🚀 Generating presentation: #{@name}\n"
        
        html = @toHtml()
        
        fs.writeFileSync(outputPath, html)
        console.log "✅ Generated: #{outputPath}\n"
    
    @toHtml: ->
        sectionsKey = Object.keys(this).find((k) -> k in ['sections', '章', 'parts'])
        sections = if sectionsKey then this[sectionsKey] else []
        
        sectionsHtml = sections.map((s) -> s.toHtml()).join('\n')
        
        """
        <!doctype html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>#{@name}</title>
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
                    #{sectionsHtml}
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

# ============================================
# 导出
# ============================================

module.exports = {
    Slide
    Section
    Chapter
    Presentation
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

    # 生成（声明式）
    我的幻灯片.generate "outputs/my-vision-declarative.html"
