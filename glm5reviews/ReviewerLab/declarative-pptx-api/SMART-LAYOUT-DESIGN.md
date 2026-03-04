# BoxesPlus - 智能布局设计文档

## 🎯 核心理念

### 用户职责
1. **提供内容** - 告诉框架幻灯片做什么
2. **选择类型** - 告诉框架想怎么摆那些内容

### 框架职责
1. **摆正确** - 确保内容不溢出、不错位
2. **摆好看** - 智能布局、美观呈现
3. **智能安排** - 根据数据自动调整布局
4. **自动优化** - 字体大小、布局调整

**核心理念**：
> 用户不用操心布局和样式，框架全包了！

---

## 📊 智能布局问题

### 1. 内容溢出问题

**问题描述**：
- 文字跑到页面外面
- 内容超出幻灯片边界
- 用户看不到完整内容

**解决方案**：
```coffee
# 自动检测内容是否溢出
isOverflow: (text, width, height, fontSize) ->
    lines = text.split('\n')
    lineHeight = fontSize * 1.2
    totalHeight = lines.length * lineHeight
    
    # 检查是否超出高度
    if totalHeight > height
        return true
    
    # 检查是否超出宽度
    for line in lines
        charWidth = fontSize * 0.6
        if line.length * charWidth > width
            return true
    
    false

# 自动调整字体大小
adjustFontSize: (text, width, height, maxFontSize = 18, minFontSize = 10) ->
    fontSize = maxFontSize
    
    while fontSize >= minFontSize
        unless @isOverflow(text, width, height, fontSize)
            return fontSize
        fontSize -= 1
    
    minFontSize
```

---

### 2. 布局优化问题

**问题描述**：
- 瘦高内容不美观
- 扁平内容更易读
- 空间利用不合理

**解决方案**：
```coffee
# 智能布局计算
calculateLayout: (content, slideWidth, slideHeight) ->
    # 计算内容密度
    lines = content.split('\n').length
    maxChars = Math.max(...content.split('\n').map (l) -> l.length)
    
    # 根据内容密度选择布局
    if lines > maxChars
        # 瘦高内容 - 扁平化布局
        return {
            columns: 2  # 分成两列
            fontSize: 12
            padding: 0.5
        }
    else
        # 扁平内容 - 正常布局
        return {
            columns: 1
            fontSize: 14
            padding: 0.8
        }
```

---

### 3. 字体大小问题

**问题描述**：
- 多行文字字体太大
- 内容挤在一起
- 可读性差

**解决方案**：
```coffee
# 根据内容长度自动调整字体
calculateFontSize: (content, availableWidth, availableHeight) ->
    lines = content.split('\n')
    lineCount = lines.length
    maxChars = Math.max(...lines.map (l) -> l.length)
    
    # 基础字体大小
    baseFontSize = 18
    
    # 根据行数调整
    if lineCount > 10
        baseFontSize = 10
    else if lineCount > 7
        baseFontSize = 12
    else if lineCount > 5
        baseFontSize = 14
    
    # 根据字符数调整
    if maxChars > 80
        baseFontSize = Math.min(baseFontSize, 10)
    else if maxChars > 60
        baseFontSize = Math.min(baseFontSize, 12)
    else if maxChars > 40
        baseFontSize = Math.min(baseFontSize, 14)
    
    baseFontSize
```

---

### 4. 空间利用问题

**问题描述**：
- 页面空间浪费
- 内容集中在某一区域
- 布局不平衡

**解决方案**：
```coffee
# 智能空间分配
allocateSpace: (contents, slideWidth, slideHeight) ->
    totalContent = contents.reduce ((sum, c) -> sum + c.length), 0
    
    contents.map (content) =>
        # 根据内容占比分配空间
        ratio = content.length / totalContent
        
        {
            width: slideWidth * ratio
            height: slideHeight * ratio
            x: 0  # 根据布局算法计算
            y: 0  # 根据布局算法计算
        }
```

---

## 🚀 智能布局实现计划

### 阶段1：基础智能布局

**目标**：解决内容溢出问题

**任务**：
1. 实现内容溢出检测
2. 实现字体大小自动调整
3. 实现基础布局优化

**优先级**：高

---

### 阶段2：高级智能布局

**目标**：优化布局美观度

**任务**：
1. 实现瘦高内容扁平化
2. 实现多列布局
3. 实现空间智能分配

**优先级**：中

---

### 阶段3：智能优化

**目标**：自动优化布局

**任务**：
1. 实现内容密度分析
2. 实现布局自动选择
3. 实现样式自动调整

**优先级**：低

---

## 📝 使用示例

### 当前方式（需要用户操心）

```coffee
class 课程对象 extends ContentSlide
    @对象1: "医院院长、书记、分管副院长"
    @对象2: "品牌/宣传、市场/客服部门负责人"
    # 用户需要考虑：字体大小、布局、是否溢出
```

### 未来方式（框架全包）

```coffee
class 课程对象 extends ContentSlide
    @对象1: "医院院长、书记、分管副院长"
    @对象2: "品牌/宣传、市场/客服部门负责人"
    # 框架自动：
    # 1. 检测内容长度
    # 2. 调整字体大小
    # 3. 优化布局
    # 4. 确保不溢出
```

---

## 🎯 成功标准

### 摆正确
- ✅ 所有内容都在页面内
- ✅ 没有文字溢出
- ✅ 没有布局错位

### 摆好看
- ✅ 布局美观平衡
- ✅ 字体大小合适
- ✅ 空间利用充分

### 智能安排
- ✅ 自动调整布局
- ✅ 自动优化字体
- ✅ 自动处理溢出

---

## 📚 参考资料

### 设计原则
1. **用户不用操心** - 框架全包了
2. **智能优先** - 自动处理问题
3. **美观至上** - 确保布局好看
4. **稳定可靠** - 确保内容正确

### 技术实现
- 内容密度分析
- 布局算法优化
- 字体大小计算
- 空间分配策略

---

**最后更新**: 2026-03-04
**维护者**: Reviewer AI
