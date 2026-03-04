#!/usr/bin/env coffee

# Test Smart Layout in ContentSlide

{ ContentSlide, Presentation } = require "./index"

console.log "🧪 Testing Smart Layout in ContentSlide...\n"

# Test 1: Short content
console.log "Test 1: Short content"
class TestShortContent extends ContentSlide
    @要点1: "这是短内容"
    @要点2: "这也是短内容"

# Test 2: Long content
console.log "Test 2: Long content"
class TestLongContent extends ContentSlide
    @要点1: "这是一个非常长的内容，需要自动调整字体大小以适应页面宽度，确保内容不会溢出到页面外面"
    @要点2: "这也是一个非常长的内容，需要自动调整字体大小以适应页面宽度，确保内容不会溢出到页面外面"

# Test 3: Multi-line content
console.log "Test 3: Multi-line content"
class TestMultiLineContent extends ContentSlide
    @要点1: "第一行内容\n第二行内容\n第三行内容\n第四行内容\n第五行内容"
    @要点2: "这是普通内容"

# Generate test presentation
console.log "\nGenerating test presentation..."

class TestPresentation extends Presentation
    @sections: -> [
        class TestSection
            @幻灯片: -> [
                TestShortContent
                TestLongContent
                TestMultiLineContent
            ]
    ]
    @nowYou: @newPresentation()

console.log "\n🎉 Test completed!"
console.log "Check outputs/TestPresentation.pptx for results"
