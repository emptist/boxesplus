#!/usr/bin/env coffee

# Test Smart Layout Utilities

SmartLayout = require "./smart-layout"

console.log "🧪 Testing Smart Layout Utilities...\n"

# Test 1: Content overflow detection
console.log "Test 1: Content overflow detection"
text1 = "This is a short text"
overflow1 = SmartLayout.isOverflow(text1, 9, 1, 18)
console.log "  Short text overflow: #{overflow1} (expected: false)"

text2 = "This is a very long text that should overflow the available space because it has too many characters for the given width"
overflow2 = SmartLayout.isOverflow(text2, 9, 1, 18)
console.log "  Long text overflow: #{overflow2} (expected: true)"

# Test 2: Font size adjustment
console.log "\nTest 2: Font size adjustment"
text3 = "Short text"
fontSize1 = SmartLayout.adjustFontSize(text3, 9, 1, 18, 10)
console.log "  Short text font size: #{fontSize1} (expected: 18)"

text4 = "This is a longer text that needs smaller font size to fit in the available space"
fontSize2 = SmartLayout.adjustFontSize(text4, 9, 1, 18, 10)
console.log "  Long text font size: #{fontSize2} (expected: < 18)"

# Test 3: Content analysis
console.log "\nTest 3: Content analysis"
text5 = "Line 1\nLine 2\nLine 3\nLine 4\nLine 5"
analysis1 = SmartLayout.analyzeContent(text5)
console.log "  Text analysis: #{JSON.stringify(analysis1, null, 2)}"

obj1 = { key1: "value1", key2: "value2" }
analysis2 = SmartLayout.analyzeContent(obj1)
console.log "  Object analysis: #{JSON.stringify(analysis2, null, 2)}"

# Test 4: Font size calculation
console.log "\nTest 4: Font size calculation"
text6 = "Short content"
fontSize3 = SmartLayout.calculateFontSize(text6, 9, 1)
console.log "  Short content font size: #{fontSize3}"

text7 = "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10\nLine 11"
fontSize4 = SmartLayout.calculateFontSize(text7, 9, 1)
console.log "  Long content font size: #{fontSize4}"

# Test 5: Layout suggestion
console.log "\nTest 5: Layout suggestion"
text8 = "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8"
suggestion1 = SmartLayout.suggestLayout(text8)
console.log "  Tall content suggestion: #{JSON.stringify(suggestion1, null, 2)}"

text9 = "This is a very long line of text that should be displayed in a single column layout"
suggestion2 = SmartLayout.suggestLayout(text9)
console.log "  Wide content suggestion: #{JSON.stringify(suggestion2, null, 2)}"

console.log "\n🎉 All tests completed!"
