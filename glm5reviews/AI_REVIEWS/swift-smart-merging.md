# Swift 智能合并理念探索

**创建日期**: 2026-03-05  
**探索者**: Reviewer AI  
**来源**: Swift AI Assistant - DeclarativeFramework.swift

---

## 📋 概述

Swift AI Assistant 使用 **智能合并** 来自动识别和合并相关属性，无需手动定义合并规则。这种设计大大简化了代码，提高了开发效率。

---

## 🎯 Swift 实现

### mergeItems - 合并列表项

```swift
func mergeItems(_ dict: [String: any Sendable]) -> [String] {
    var items: [String] = []
    
    let prefixes = ["item", "要点", "benefit", "advantage", "feature", "特点"]
    
    for (key, value) in dict {
        for prefix in prefixes {
            if key.hasPrefix(prefix) {
                if let stringValue = value as? String {
                    items.append(stringValue)
                } else if let stringArray = value as? [String] {
                    items.append(contentsOf: stringArray)
                }
                break
            }
        }
    }
    
    return items
}
```

### mergeCards - 合并卡片

```swift
func mergeCards(_ dict: [String: any Sendable]) -> [[String: any Sendable]] {
    var cards: [[String: any Sendable]] = []
    var currentCard: [String: any Sendable] = [:]
    
    let cardPrefixes = ["card", "卡片"]
    let cardFields = ["title", "content", "description", "标题", "内容", "描述"]
    
    for (key, value) in dict {
        var isCardField = false
        
        for prefix in cardPrefixes {
            if key.hasPrefix(prefix) {
                if let stringValue = value as? String {
                    currentCard[key] = stringValue
                }
                isCardField = true
                break
            }
        }
        
        if !isCardField {
            for field in cardFields {
                if key.hasPrefix(field) {
                    if let stringValue = value as? String {
                        currentCard[key] = stringValue
                    }
                    isCardField = true
                    break
                }
            }
        }
    }
    
    if !currentCard.isEmpty {
        cards.append(currentCard)
    }
    
    return cards
}
```

### mergeTable - 合并表格

```swift
func mergeTable(_ dict: [String: any Sendable]) -> [[String: any Sendable]] {
    var table: [[String: any Sendable]] = []
    var currentRow: [String: any Sendable] = [:]
    
    let tablePrefixes = ["row", "行"]
    let tableFields = ["key", "value", "label", "data", "键", "值", "标签", "数据"]
    
    for (key, value) in dict {
        var isTableField = false
        
        for prefix in tablePrefixes {
            if key.hasPrefix(prefix) {
                if let stringValue = value as? String {
                    currentRow[key] = stringValue
                }
                isTableField = true
                break
            }
        }
        
        if !isTableField {
            for field in tableFields {
                if key.hasPrefix(field) {
                    if let stringValue = value as? String {
                        currentRow[key] = stringValue
                    }
                    isTableField = true
                    break
                }
            }
        }
    }
    
    if !currentRow.isEmpty {
        table.append(currentRow)
    }
    
    return table
}
```

### mergeTwoColumn - 合并两列

```swift
func mergeTwoColumn(_ dict: [String: any Sendable]) -> [String: any Sendable] {
    var result: [String: any Sendable] = [:]
    
    let leftPrefixes = ["left", "左"]
    let rightPrefixes = ["right", "右"]
    let columnPrefixes = ["column", "列"]
    
    var leftItems: [String] = []
    var rightItems: [String] = []
    
    for (key, value) in dict {
        for prefix in leftPrefixes {
            if key.hasPrefix(prefix) {
                if let stringValue = value as? String {
                    leftItems.append(stringValue)
                } else if let stringArray = value as? [String] {
                    leftItems.append(contentsOf: stringArray)
                }
                break
            }
        }
        
        for prefix in rightPrefixes {
            if key.hasPrefix(prefix) {
                if let stringValue = value as? String {
                    rightItems.append(stringValue)
                } else if let stringArray = value as? [String] {
                    rightItems.append(contentsOf: stringArray)
                }
                break
            }
        }
        
        for prefix in columnPrefixes {
            if key.hasPrefix(prefix) {
                if let stringValue = value as? String {
                    result[key] = stringValue
                } else if let stringArray = value as? [String] {
                    result[key] = stringArray
                }
                break
            }
        }
    }
    
    if !leftItems.isEmpty {
        result["left"] = leftItems
    }
    
    if !rightItems.isEmpty {
        result["right"] = rightItems
    }
    
    return result
}
```

---

## 💡 CoffeeScript 实现

### mergeItems - 合并列表项

```coffeescript
class Slide
  @mergeItems: (dict) ->
    items = []
    
    prefixes = ["item", "要点", "benefit", "advantage", "feature", "特点"]
    
    for key, value of dict
      for prefix in prefixes
        if key.indexOf(prefix) is 0
          if typeof value is "string"
            items.push(value)
          else if Array.isArray(value)
            if typeof value[0] is "string"
              items = items.concat(value)
          break
    
    items
```

### mergeCards - 合并卡片

```coffeescript
class Slide
  @mergeCards: (dict) ->
    cards = []
    currentCard = {}
    
    cardPrefixes = ["card", "卡片"]
    cardFields = ["title", "content", "description", "标题", "内容", "描述"]
    
    for key, value of dict
      isCardField = false
      
      for prefix in cardPrefixes
        if key.indexOf(prefix) is 0
          if typeof value is "string"
            currentCard[key] = value
          isCardField = true
          break
      
      unless isCardField
        for field in cardFields
          if key.indexOf(field) is 0
            if typeof value is "string"
              currentCard[key] = value
            isCardField = true
            break
    
    if Object.keys(currentCard).length > 0
      cards.push(currentCard)
    
    cards
```

### mergeTable - 合并表格

```coffeescript
class Slide
  @mergeTable: (dict) ->
    table = []
    currentRow = {}
    
    tablePrefixes = ["row", "行"]
    tableFields = ["key", "value", "label", "data", "键", "值", "标签", "数据"]
    
    for key, value of dict
      isTableField = false
      
      for prefix in tablePrefixes
        if key.indexOf(prefix) is 0
          if typeof value is "string"
            currentRow[key] = value
          isTableField = true
          break
      
      unless isTableField
        for field in tableFields
          if key.indexOf(field) is 0
            if typeof value is "string"
              currentRow[key] = value
            isTableField = true
            break
    
    if Object.keys(currentRow).length > 0
      table.push(currentRow)
    
    table
```

### mergeTwoColumn - 合并两列

```coffeescript
class Slide
  @mergeTwoColumn: (dict) ->
    result = {}
    
    leftPrefixes = ["left", "左"]
    rightPrefixes = ["right", "右"]
    columnPrefixes = ["column", "列"]
    
    leftItems = []
    rightItems = []
    
    for key, value of dict
      for prefix in leftPrefixes
        if key.indexOf(prefix) is 0
          if typeof value is "string"
            leftItems.push(value)
          else if Array.isArray(value)
            if typeof value[0] is "string"
              leftItems = leftItems.concat(value)
          break
      
      for prefix in rightPrefixes
        if key.indexOf(prefix) is 0
          if typeof value is "string"
            rightItems.push(value)
          else if Array.isArray(value)
            if typeof value[0] is "string"
              rightItems = rightItems.concat(value)
          break
      
      for prefix in columnPrefixes
        if key.indexOf(prefix) is 0
          if typeof value is "string"
            result[key] = value
          else if Array.isArray(value)
            result[key] = value
          break
    
    if leftItems.length > 0
      result["left"] = leftItems
    
    if rightItems.length > 0
      result["right"] = rightItems
    
    result
```

---

## 🔍 对比分析

### Swift vs CoffeeScript

| 特性 | Swift | CoffeeScript | 优势 |
|------|--------|--------------|------|
| **智能识别** | ✅ hasPrefix | ✅ indexOf | 平手 |
| **类型安全** | ✅ 类型检查 | ❌ 运行时检查 | Swift 领先 |
| **数组处理** | ✅ append(contentsOf) | ✅ concat | 平手 |
| **中英文支持** | ✅ 支持中英文前缀 | ✅ 支持中英文前缀 | 平手 |
| **代码简洁** | ✅ 简洁 | ✅ 简洁 | 平手 |
| **性能** | ✅ 编译时优化 | ❌ 运行时检查 | Swift 领先 |

---

## 🎯 实现建议

### 短期目标（1-2周）

1. **实现基本合并**
   - 实现 mergeItems
   - 实现 mergeCards
   - 实现 mergeTable
   - 实现 mergeTwoColumn

2. **测试合并功能**
   - 创建测试用例
   - 验证合并逻辑
   - 验证中英文支持

### 中期目标（1-2月）

1. **增强合并功能**
   - 支持更多前缀
   - 支持更多字段
   - 实现更智能的合并

2. **优化性能**
   - 缓存前缀列表
   - 优化字符串匹配
   - 减少运行时开销

### 长期目标（3-6月）

1. **集成到框架**
   - 将合并功能集成到 Slide 类
   - 更新所有幻灯片类型
   - 提供向后兼容性

2. **文档和示例**
   - 编写 API 文档
   - 提供使用示例
   - 编写最佳实践

---

## 📊 示例代码

### Swift 版本

```swift
let slide = ContentSlide("Title", [
    "item1": "First item",
    "item2": "Second item",
    "item3": "Third item"
])

let items = mergeItems(slide.collectContent())
// items = ["First item", "Second item", "Third item"]
```

### CoffeeScript 版本

```coffeescript
class MySlide extends ContentSlide
  @item1: "First item"
  @item2: "Second item"
  @item3: "Third item"

items = MySlide.mergeItems(MySlide.collectContent())
// items = ["First item", "Second item", "Third item"]
```

---

## 🎉 总结

### Swift 的优势

1. **类型安全** - 编译时检查类型，减少运行时错误
2. **性能优化** - 编译时优化，减少运行时开销
3. **标准库** - 丰富的标准库，简化开发

### CoffeeScript 的优势

1. **灵活性** - 运行时检查，更灵活
2. **简洁性** - 代码更简洁，更容易理解
3. **兼容性** - 与 JavaScript 完全兼容

### 建议

- ✅ **可以借鉴 Swift 的设计思路** - 智能识别前缀，自动合并
- ✅ **可以使用 indexOf 实现** - CoffeeScript 有类似的字符串匹配
- ✅ **支持中英文前缀** - 提高国际化支持
- ⚠️ **需要注意类型安全** - CoffeeScript 缺少编译时检查
- ⚠️ **需要注意性能** - CoffeeScript 的运行时检查可能影响性能

---

**文档创建日期**: 2026-03-05  
**最后更新**: 2026-03-05  
**维护者**: Reviewer AI  
**版本**: 1.0.0
