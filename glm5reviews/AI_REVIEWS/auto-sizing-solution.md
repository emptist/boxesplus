# Reviewer AI - 自动布局问题分析

**日期**: 2026-03-05
**主题**: hybrid-generator.coffee 的自动布局问题

---

## 问题发现

你们提到自动布局有问题，我分析了 `hybrid-generator.coffee`，发现了原因：

### 当前方案

```coffee
# hybrid-generator.coffee 的 HTML 生成
generateHtml = (data, outputPath) ->
  slidesHtml = for slide in data.slides
    if slide.type is "list" or slide.type is "content"
      itemsHtml = for item, i in (slide.items ? [])
        "<li>#{item}</li>"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <ul>#{itemsHtml.join('')}</ul>
      </div>
      """
```

**问题**：
1. ❌ 没有 CSS 自动调整字体大小
2. ❌ 内容多时会溢出
3. ❌ 截图后问题依然存在

---

## 解决方案

### 方案 1：CSS 自动调整（推荐）

在 HTML 中添加智能 CSS：

```html
<style>
.slide {
  width: 1280px;
  height: 720px;
  padding: 40px;
  box-sizing: border-box;
  overflow: hidden;
}

.slide h3 {
  font-size: 32px;
  margin-bottom: 20px;
}

.slide ul {
  font-size: 24px;
  line-height: 1.6;
}

/* 自动调整字体大小 */
.slide.auto-size ul {
  font-size: calc(24px - (var(--item-count) - 5) * 2px);
}

/* 内容过多时缩小 */
.slide.content-heavy ul {
  font-size: 18px;
  line-height: 1.4;
}
</style>
```

### 方案 2：JavaScript 动态调整

```javascript
// 在 HTML 中添加
<script>
function adjustFontSize() {
  document.querySelectorAll('.slide').forEach(slide => {
    const ul = slide.querySelector('ul');
    if (!ul) return;
    
    const items = ul.querySelectorAll('li');
    const itemCount = items.length;
    
    // 根据项目数量调整字体
    let fontSize = 24;
    if (itemCount > 5) fontSize = 20;
    if (itemCount > 8) fontSize = 18;
    if (itemCount > 10) fontSize = 16;
    
    ul.style.fontSize = fontSize + 'px';
    
    // 检查是否溢出
    if (ul.scrollHeight > ul.clientHeight) {
      // 继续缩小字体
      while (ul.scrollHeight > ul.clientHeight && fontSize > 12) {
        fontSize -= 1;
        ul.style.fontSize = fontSize + 'px';
      }
    }
  });
}

// Mermaid 渲染完成后调整
mermaid.initialize({
  startOnLoad: true,
  theme: 'default'
}, () => {
  adjustFontSize();
});
</script>
```

### 方案 3：迁移实验室的 SmartLayout

实验室有完整的智能布局系统：

**文件**: `/glm5reviews/ReviewerLab/declarative-pptx-api/smart-layout.coffee`

**核心功能**：
```coffee
class SmartLayout
    @calculateFontSize: (text, width, height, maxFontSize, minFontSize) ->
        charsPerLine = Math.floor(width * 10)
        lines = Math.ceil(text.length / charsPerLine)
        fontSize = Math.floor(height * 72 / (lines + 1))
        Math.max(minFontSize, Math.min(maxFontSize, fontSize))
```

**使用方式**：
```coffee
# 在 hybrid-generator.coffee 中
{ SmartLayout } = require "../glm5reviews/ReviewerLab/declarative-pptx-api/smart-layout"

# 生成 HTML 时计算字体大小
fontSize = SmartLayout.calculateFontSize(text, 9, 0.5, 24, 12)
```

---

## 推荐方案

**短期**：方案 1 + 方案 2（CSS + JS 动态调整）

**中期**：方案 3（迁移 SmartLayout）

**长期**：直接使用 PptxGenJS 生成 PPTX（不截图）

---

## 示例代码

修改 `hybrid-generator.coffee`：

```coffee
generateHtml = (data, outputPath) ->
  slidesHtml = for slide in data.slides
    if slide.type is "list" or slide.type is "content"
      items = slide.items ? []
      itemCount = items.length
      
      # 计算字体大小
      fontSize = if itemCount <= 5 then 24
                 else if itemCount <= 8 then 20
                 else if itemCount <= 10 then 18
                 else 16
      
      itemsHtml = for item, i in items
        "<li>#{item}</li>"
      
      """
      <div class="slide" style="--item-count: #{itemCount};">
        <h3>#{slide.title}</h3>
        <ul style="font-size: #{fontSize}px;">#{itemsHtml.join('')}</ul>
      </div>
      """
    # ... 其他类型
  
  # 添加自动调整脚本
  html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>#{data.title}</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@9.4.3/dist/mermaid.min.js"></script>
  <style>
    /* 基础样式 */
    body { margin: 0; padding: 20px; font-family: Arial, sans-serif; }
    .slide { 
      width: 1280px; 
      height: 720px; 
      padding: 40px; 
      box-sizing: border-box;
      overflow: hidden;
      margin-bottom: 20px;
      border: 1px solid #ccc;
    }
    .slide h3 { font-size: 32px; margin-bottom: 20px; color: #366092; }
    .slide ul { line-height: 1.6; }
    
    /* 自动调整 */
    .slide ul { 
      max-height: 500px;
      overflow: hidden;
    }
  </style>
</head>
<body>
#{slidesHtmlStr}
<script>
  mermaid.initialize({ startOnLoad: true, theme: 'default' });
  
  // 自动调整字体大小
  function adjustFonts() {
    document.querySelectorAll('.slide').forEach(slide => {
      const ul = slide.querySelector('ul');
      if (!ul) return;
      
      let fontSize = parseInt(ul.style.fontSize) || 24;
      
      // 检查溢出并调整
      while (ul.scrollHeight > ul.clientHeight && fontSize > 12) {
        fontSize -= 1;
        ul.style.fontSize = fontSize + 'px';
      }
    });
  }
  
  setTimeout(adjustFonts, 100);
</script>
</body>
</html>
"""
```

---

## 测试建议

1. **测试不同内容长度**：
   - 短内容（3-5项）
   - 中等内容（6-10项）
   - 长内容（10+项）

2. **测试不同内容宽度**：
   - 短文本（10字以内）
   - 中等文本（10-30字）
   - 长文本（30+字）

3. **检查溢出**：
   - 确保 `scrollHeight <= clientHeight`

---

## 需要帮助？

如果需要迁移 SmartLayout 或实现自动调整，我可以：

1. 提供完整的迁移代码
2. 创建测试用例
3. 协助调试

**Happy Coding!** 🚀

---

*Reviewer AI*
*BoxesPlus 实验室*
