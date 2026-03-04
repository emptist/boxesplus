#!/usr/bin/env coffee

# Mermaid Support for Declarative PPTX API
# Generates Reveal.js HTML with Mermaid diagrams

fs = require "fs"

class MermaidGenerator
    @generateHtml: (slides, outputPath, title = "Presentation") ->
        slidesHtml = slides.map (slide) =>
            switch slide.type
                when "mermaid" then @mermaidSlide(slide)
                when "title" then @titleSlide(slide)
                when "section" then @sectionSlide(slide)
                when "end" then @endSlide(slide)
                when "list" then @listSlide(slide)
                when "cards" then @cardsSlide(slide)
                else @contentSlide(slide)
        
        html = """
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>#{title}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
    <style>
        .reveal .slides section { text-align: center; }
        .reveal { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; }
        .mermaid { display: flex; justify-content: center; margin: 20px 0; }
        .reveal .mermaid svg { max-width: 100%; height: auto; }
        .reveal h1, .reveal h2, .reveal h3 { color: #1a365d; }
    </style>
</head>
<body>
    <div class="reveal">
        <div class="slides">
            #{slidesHtml.join("\n")}
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
    <script>
        mermaid.initialize({ 
            startOnLoad: true,
            theme: 'base',
            themeVariables: {
                primaryColor: '#3182ce',
                edgeLabelBackground: '#ffffff',
                tertiaryColor: '#f7fafc'
            }
        });
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
        console.log "✅ Created: #{outputPath}"
    
    @titleSlide: (opts) ->
        { title, subtitle, gradient } = opts
        gradient = gradient || "linear-gradient(135deg, #1a365d 0%, #2c5282 100%)"
        
        """
        <section style="background: #{gradient};">
            <h1 style="color: white;">#{title || '标题'}</h1>
            <h3 style="color: #90cdf4;">#{subtitle || ''}</h3>
        </section>
        """
    
    @sectionSlide: (opts) ->
        { title, subtitle } = opts
        
        """
        <section data-background-gradient="linear-gradient(135deg, #1a365d 0%, #2c5282 100%)">
            <h1 style="color: white;">#{title || '章节'}</h1>
            <h2 style="color: #90cdf4;">#{subtitle || ''}</h2>
        </section>
        """
    
    @endSlide: (opts) ->
        { title } = opts
        
        """
        <section data-background-gradient="linear-gradient(135deg, #38a169 0%, #276749 100%)">
            <h1 style="color: white; font-size: 3em;">#{title || '谢谢!'}</h1>
        </section>
        """
    
    @mermaidSlide: (opts) ->
        { title, diagram } = opts
        
        """
        <section>
            <h3 style="color: #1a365d; margin-bottom: 20px;">#{title || ''}</h3>
            <div class="mermaid" style="font-size: 24px;">
#{diagram || 'graph TD\\nA[A] --> B[B]'}
            </div>
        </section>
        """
    
    @listSlide: (opts) ->
        { title, items } = opts
        items = items || ["要点1", "要点2", "要点3"]
        
        itemsHtml = items.map((item, i) -> 
            """
            <div style="display: flex; align-items: flex-start; margin-bottom: 15px;">
                <div style="background: #3182ce; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; margin-right: 15px; flex-shrink: 0;">#{i + 1}</div>
                <div style="text-align: left; padding-top: 5px;">#{item}</div>
            </div>
            """
        ).join("")
        
        """
        <section>
            <h2 style="color: #1a365d;">#{title || '内容'}</h2>
            <div style="margin-top: 30px; padding: 0 100px; text-align: left;">
                #{itemsHtml}
            </div>
        </section>
        """
    
    @cardsSlide: (opts) ->
        { title, cards } = opts
        cards = cards || [
            { title: "卡片1", content: "内容1", color: "#ebf8ff" }
            { title: "卡片2", content: "内容2", color: "#f0fff4" }
        ]
        
        cardsHtml = cards.map((card) ->
            """
            <div style="flex: 1; background: #{card.color}; border-radius: 10px; padding: 20px; margin: 0 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <h3 style="margin: 0 0 10px 0; color: #1a365d;">#{card.title}</h3>
                <p style="margin: 0; color: #4a5568;">#{card.content}</p>
            </div>
            """
        ).join("")
        
        """
        <section>
            <h2 style="color: #1a365d;">#{title || '特点'}</h2>
            <div style="display: flex; gap: 20px; margin-top: 40px; justify-content: center;">
                #{cardsHtml}
            </div>
        </section>
        """
    
    @contentSlide: (opts) ->
        { title, content } = opts
        
        """
        <section>
            <h2 style="color: #1a365d;">#{title || '内容'}</h2>
            <div style="text-align: left; padding: 20px;">
                <p>#{content || ''}</p>
            </div>
        </section>
        """

module.exports = MermaidGenerator
