# BoxesPlus - Smart Layout Utilities
# 智能布局工具类 - 自动处理内容溢出、字体调整、布局优化

class SmartLayout
    # ============================================
    # 内容溢出检测
    # ============================================
    
    @isOverflow: (text, width, height, fontSize) ->
        lines = text.split('\n')
        lineHeight = fontSize * 1.2
        totalHeight = lines.length * lineHeight
        
        if totalHeight > height
            return true
        
        for line in lines
            charWidth = fontSize * 0.6
            if line.length * charWidth > width
                return true
        
        false
    
    # ============================================
    # 字体大小自动调整
    # ============================================
    
    @adjustFontSize: (text, width, height, maxFontSize = 18, minFontSize = 10) ->
        fontSize = maxFontSize
        
        while fontSize >= minFontSize
            unless @isOverflow(text, width, height, fontSize)
                return fontSize
            fontSize -= 1
        
        minFontSize
    
    # ============================================
    # 内容密度分析
    # ============================================
    
    @analyzeContent: (content) ->
        if typeof content is 'string'
            lines = content.split('\n')
            lineCount = lines.length
            maxChars = Math.max(...lines.map (l) -> l.length)
            totalChars = content.length
            
            return {
                type: 'text'
                lineCount: lineCount
                maxChars: maxChars
                totalChars: totalChars
                density: if lineCount > 0 then totalChars / lineCount else 0
            }
        else if typeof content is 'object'
            return {
                type: 'object'
                keys: Object.keys(content).length
            }
        else
            return {
                type: 'unknown'
            }
    
    # ============================================
    # 智能字体大小计算
    # ============================================
    
    @calculateFontSize: (content, availableWidth, availableHeight) ->
        analysis = @analyzeContent(content)
        
        if analysis.type is 'text'
            baseFontSize = 18
            
            if analysis.lineCount > 10
                baseFontSize = 10
            else if analysis.lineCount > 7
                baseFontSize = 12
            else if analysis.lineCount > 5
                baseFontSize = 14
            
            if analysis.maxChars > 80
                baseFontSize = Math.min(baseFontSize, 10)
            else if analysis.maxChars > 60
                baseFontSize = Math.min(baseFontSize, 12)
            else if analysis.maxChars > 40
                baseFontSize = Math.min(baseFontSize, 14)
            
            return @adjustFontSize(content, availableWidth, availableHeight, baseFontSize)
        
        18
    
    # ============================================
    # 布局优化建议
    # ============================================
    
    @suggestLayout: (content, slideWidth = 10, slideHeight = 7.5) ->
        analysis = @analyzeContent(content)
        
        if analysis.type is 'text'
            if analysis.lineCount > analysis.maxChars
                return {
                    layout: 'multi-column'
                    columns: 2
                    fontSize: @calculateFontSize(content, slideWidth / 2, slideHeight)
                    reason: '瘦高内容，建议多列布局'
                }
            else
                return {
                    layout: 'single-column'
                    columns: 1
                    fontSize: @calculateFontSize(content, slideWidth, slideHeight)
                    reason: '扁平内容，建议单列布局'
                }
        
        {
            layout: 'default'
            columns: 1
            fontSize: 18
            reason: '默认布局'
        }

module.exports = SmartLayout
