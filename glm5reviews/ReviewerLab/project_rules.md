# GLM5 Reviews - 项目规则

## 📋 项目概述

本项目是代码审查和工具开发的工作空间，专注于PPTX和RevealJS演示文稿的自动生成，以及Mermaid图表的增强实现。

## 🚀 核心工具链

```
Markdown教案 → 自动判断 → CSON数据 → PPTX输出
     ↓
  自动选择：
  - 内容少 → 卡片页（固定布局）
  - 内容多 → 表格页（自动调整）
```

## 📂 目录结构

```
glm5reviews/
├── AI_REVIEWS/               # 📋 报告目录
│   ├── README.md
│   ├── boxesplus-comprehensive-review.md
│   ├── review-methodology.md
│   ├── html-conversion-methods.md
│   └── pdf-pptx-generation-review.md
└── ReviewerLab/                  # 🔬 ReviewerLab目录
    ├── my-workspace/          # 之前的my-workspace
    │   ├── api/             # API实现
    │   │   ├── hybrid-generator-v2.coffee
    │   │   ├── hybrid-generator.coffee
    │   │   ├── mermaid-enhanced-complete.coffee
    │   │   ├── mermaid-enhanced-fixed.coffee
    │   │   ├── mermaid-enhanced-v2.coffee
    │   │   ├── mermaid-enhanced-v3.coffee
    │   │   ├── mermaid-enhanced.coffee
    │   │   ├── mermaid-to-pptx-html.coffee
    │   │   └── mermaid-user-friendly.coffee
    │   ├── demo/            # 演示代码
    │   │   ├── C01课程PPTX-完整版.coffee
    │   │   ├── C01课程图表-一次成型版.coffee
    │   │   ├── C01课程图表-优化版.coffee
    │   │   ├── C01课程图表-尺寸优化版.coffee
    │   │   ├── C01课程图表-简化测试版.coffee
    │   │   ├── E02课程PPTX-完整版.coffee
    │   │   ├── 方案1-Puppeteer截图.coffee
    │   │   ├── 方案1-完整流程.coffee
    │   │   ├── 方案1-简化版.coffee
    │   │   ├── 测试一次成型尺寸.coffee
    │   │   ├── 测试优化版尺寸.coffee
    │   │   └── 用户友好API使用示例.coffee
    │   ├── deprecated/       # 过时的代码
    │   └── README.md
    ├── reviewer-workspace/   # 之前的reviewer-workspace
    │   ├── data/           # 数据文件（JSON格式）
    │   └── data2/          # 数据文件（CSON格式）
    ├── src/                # 之前的src
    │   ├── code/           # 核心代码
    │   │   ├── markdown转换器.coffee
    │   │   ├── boxesplus.coffee
    │   │   ├── 中文表达.coffee
    │   │   ├── 双侧编程.coffee
    │   │   ├── 真正的诗式PPTX.coffee
    │   │   ├── 散文式PPTX.coffee
    │   │   ├── 极简诗式PPTX.coffee
    │   │   ├── JSON定义解析.coffee
    │   │   ├── 自然语言表达.coffee
    │   │   ├── csv-to-json.coffee
    │   │   ├── json-to-pptx.coffee
    │   │   └── revealjs生成器.coffee
    │   └── examples/       # 示例代码
    ├── project_rules.md
    ├── README.md
    └── .gitignore
```

## 🎯 工作内容

### 1. 代码审查
对主项目 `/Users/jk/gits/hub/consult_strategy/boxesplus/` 进行深入全面的代码审查，包括：
- 核心API文件审查
- Demo示例审查
- 工具和辅助文件审查
- 文档和配置审查
- 性能分析和优化建议

### 2. 工具开发
在 `my-workspace/` 中实践和开发工具：
- Mermaid图表生成器（支持多种图表类型）
- ASCII框图增强版
- HTML/PPTX/RevealJS输出
- 多种API风格（诗式、双侧编程、数据驱动）

## 🔧 Mermaid图表开发规则（重要）

### 1. Mermaid自动渲染

**规则**：必须使用 `startOnLoad: true` 让Mermaid自动渲染

```javascript
mermaid.initialize({
  startOnLoad: true,  // 关键：自动加载
  theme: 'default',
  securityLevel: 'loose'
});
```

**原因**：手动加载时机难以控制，自动加载最可靠

### 2. Mermaid代码格式

**规则**：Mermaid代码必须左对齐，不能有缩进

```html
<!-- ✅ 正确 -->
<div class="mermaid">
flowchart TD
P[PLAN]
D[DO]
P --> D
</div>

<!-- ❌ 错误：有缩进 -->
<div class="mermaid">
  flowchart TD
    P[PLAN]
    D[DO]
    P --> D
</div>
```

**原因**：Mermaid解析器对缩进敏感，左对齐最安全

### 3. 状态图语法

**规则**：状态图使用 `[*]` 表示开始状态，不要用 `state` 关键字

```mermaid
<!-- ✅ 正确 -->
stateDiagram-v2
[*] --> 正常
正常 --> 风险评估
风险评估 --> [*]

<!-- ❌ 错误：使用state关键字 -->
stateDiagram-v2
state 正常
state 风险评估
```

**原因**：`stateDiagram-v2` 不需要 `state` 关键字，直接写状态名即可

### 4. HTML/CSS样式优化

**规则**：容器和字体大小要合适

```css
.mermaid-container {
  min-height: 400px;      /* 关键：足够的高度 */
  padding: 2em;
  overflow: auto;           /* 支持滚动 */
}

.mermaid {
  font-size: 1.2em;        /* 关键：合适的字体 */
  width: 100%;
}

.mermaid svg {
  max-width: 100% !important;  /* 关键：限制宽度 */
  height: auto !important;       /* 关键：自适应高度 */
}
```

**原因**：避免图表显示太小或溢出

### 5. 子图节点生成

**规则**：支持字符串数组和对象数组两种类型

```coffee
# ✅ 正确：支持两种类型
for 节点 in 子图.节点
  if typeof 节点 == "string"
    输出.push "  #{节点}[#{节点}]\n"
  else
    输出.push "  #{节点.id}[#{节点.文本}]\n"
```

**原因**：提高API的灵活性

### 6. 流程图形状支持

**规则**：支持所有常见形状

```coffee
if 节点.样式.形状 == "圆角"
  输出.push "#{节点.id}(#{节点.文本})\n"
else if 节点.样式.形状 == "菱形"
  输出.push "#{节点.id}{#{节点.文本}}\n"
else if 节点.样式.形状 == "圆柱"
  输出.push "#{节点.id}[(#{节点.文本})]\n"
else if 节点.样式.形状 == "parallelogram"
  输出.push "#{节点.id}[/#{节点.文本}/]\n"
else
  输出.push "#{节点.id}[#{节点.文本}]\n"
```

**原因**：完整的形状支持提高表达能力

### 7. 时序图消息类型

**规则**：支持所有消息类型

```coffee
if 消息.类型 == "同步"
  输出.push "#{消息.从}->>#{消息.到}: #{消息.文本}\n"
else if 消息.类型 == "异步"
  输出.push "#{消息.从}->#{消息.到}: #{消息.文本}\n"
else if 消息.类型 == "返回"
  输出.push "#{消息.从}-->>#{消息.到}: #{消息.文本}\n"
else if 消息.类型 == "dashed"
  输出.push "#{消息.从}-->>#{消息.到}: #{消息.文本}\n"
```

**原因**：完整的消息类型支持

### 8. 类图方法括号

**规则**：避免重复括号

```coffee
# ✅ 正确：检查是否已有括号
for 方法 in 类.方法
  if 方法.endsWith "()"
    输出.push "  #{方法}\n"
  else
    输出.push "  #{方法}()\n"
```

**原因**：避免生成 `方法()()` 这样的重复

## 🎨 页面类型

### 封面页
- 用于课程封面
- 支持标题、副标题、渐变背景

### 章节页
- 用于章节分隔
- 支持编号、标题、副标题

### 列表页
- 用于列表内容
- 自动调整项目数量和字体大小

### 表格页
- 用于表格内容
- 自动调整行高
- 适合内容多的页面

### 卡片页
- 用于卡片内容
- 固定布局（高度1.8，字体12）
- 适合内容少的页面

## 🎯 自动判断规则（重要）

### Markdown转换器自动判断

```coffee
# 规则1：超过5行 → 表格页
if 内容行数 > 5
  类型: "表格页"

# 规则2：单行超过50字 → 表格页
if 内容行数 == 1 and 总字数 > 50
  类型: "表格页"

# 规则3：其他情况 → 卡片页
else
  类型: "卡片页"
```

## 🔧 卡片页实现（重要）

### 正确的实现方式

```coffee
渲染卡片: (演示) ->
  slide = 演示.addSlide()
  slide.addText @标题,
    x: 0.5, y: 0.3, w: 9, h: 0.6
    fontSize: 28, bold: true, color: @颜色
  
  if @数据.卡片
    列数 = @数据.列数 ? 2  # 默认2列
    卡片宽度 = 8.5 / 列数
    
    @数据.卡片.forEach (卡片, 索引) =>
      x = 0.75 + (索引 % 列数) * 卡片宽度
      y = 1.2 + Math.floor(索引 / 列数) * 2  # 卡片间距2.0
      
      # 清理Markdown格式
      内容 = 卡片.内容
        .replace /\*\*/g, ""
        .replace /\n-/g, "\n•"
        .replace "（原为图例）", ""
      
      # 卡片背景（固定高度1.8）
      slide.addShape "rect",
        x: x, y: y, w: 卡片宽度 - 0.2, h: 1.8
        fill: {color: "F0F0F0"}
      
      # 卡片标题（固定高度0.4）
      slide.addText 卡片.标题,
        x: x + 0.1, y: y + 0.1, w: 卡片宽度 - 0.4, h: 0.4
        fontSize: 16, bold: true, color: @颜色
      
      # 卡片内容（固定高度1.2，固定字体12）
      slide.addText 内容,
        x: x + 0.1, y: y + 0.5, w: 卡片宽度 - 0.4, h: 1.2
        fontSize: 12, color: "333333"
```

### 关键点

1. ✅ **固定高度**：卡片 h: 1.8，标题 h: 0.4，内容 h: 1.2
2. ✅ **固定字体**：fontSize: 12，不会太小
3. ✅ **卡片间距**：2.0，布局紧凑
4. ✅ **列数默认**：2列，更合理

### 错误的实现方式（不要使用）

```coffee
# ❌ 错误1：不设置高度
slide.addText 内容,
  x: x, y: y, w: w
  # 没有设置h，可能导致溢出

# ❌ 错误2：自动调整字体大小
字体大小 = if 内容行数 <= 3 then 14
else if 内容行数 <= 6 then 12
else 10
# 内容多时字体太小

# ❌ 错误3：卡片高度太大
slide.addShape "rect",
  h: 4  # 太大，布局不合理
```

## 📝 开发规范

1. **代码风格**: 使用CoffeeScript，中文变量名
2. **注释**: 代码中不添加注释
3. **提交**: 重要更改后及时提交代码
4. **文档**: 完成任务后更新文档
5. **实践**: 通过实践验证理论

### 🧪 测试文件命名规范（重要）

**规则**：测试阶段的输出文件必须使用带编号的命名格式

**格式**：`T<编号>-<课程名称>.<扩展名>`

**示例**：
```
T001-C01医疗质量与安全管理课程.html
T002-C01医疗质量与安全管理课程-修复版.html
T003-C01医疗质量与安全管理课程-RevealJS.html
T004-C01医疗质量与安全管理课程.pdf
T005-C01医疗质量与安全管理课程.pptx
```

**说明**：
- `T` 表示 Test（测试）
- `<编号>` 使用3位数字（001, 002, 003...），表示测试的先后顺序
- `<课程名称>` 清晰标识内容
- `<扩展名>` 根据输出格式（html, pdf, pptx等）

**原因**：
- 测试阶段会生成多个版本的输出文件
- 编号便于按时间顺序查看和对比
- 避免文件名冲突
- 方便追踪测试进度和问题

**实现示例**：
```coffee
测试编号 = "001"
课程名称 = "C01医疗质量与安全管理课程"
输出文件名 = "T#{测试编号}-#{课程名称}-简化测试版.html"
```

### 📐 图表尺寸测定与排版策略（重要）

**核心理念**：先制图，然后以合理的尺寸和缩放策略来排版PDF/PPTX

#### 流程

```
步骤1: 生成HTML（包含Mermaid图表）
   ↓
步骤2: 测定图表实际尺寸
   ↓
步骤3: 根据页面尺寸计算缩放比例
   ↓
步骤4: 选择排版策略（缩放/平铺/分页）
   ↓
步骤5: 生成PDF/PPTX
```

#### 图表尺寸测定

**方法1: Puppeteer截图**
```coffee
Puppeteer.launch(headless: true).then (browser) ->
  browser.newPage().then (page) ->
    page.goto('file://...html').then ->
      page.$$('.mermaid-container').then (图表容器) ->
        for 容器, 索引 in 图表容器
          容器.boundingBox().then (边界框) ->
            console.log "图表 #{索引 + 1}: #{Math.round 边界框.width} x #{Math.round 边界框.height}"
```

**示例输出**：
```
图表1: 670 x 1039
图表2: 670 x 766
图表3: 670 x 2160
图表4: 670 x 564
图表5: 670 x 4577
图表6: 670 x 1869
```

#### 排版策略

**策略1: 缩放到页面**
- 适用：图表尺寸接近页面尺寸
- 计算：`缩放比例 = min(页面宽度/图表宽度, 页面高度/图表高度)`
- 示例：A4页面 (210mm x 297mm)，图表670x1039px

**策略2: 平铺布局**
- 适用：多个小图表
- 计算：`每行图表数 = floor(页面宽度 / 图表宽度)`
- 示例：页面宽度960px，图表宽度670px，每行1个

**策略3: 分页显示**
- 适用：单个大图表
- 计算：`页数 = ceil(图表高度 / 页面高度)`
- 示例：图表高度4577px，页面高度1000px，需要5页

**策略4: 混合策略**
- 适用：不同尺寸的图表混合
- 计算：根据每个图表的尺寸选择策略
- 示例：小图表平铺，大图表分页

#### 实现示例

```coffee
计算排版策略 = (图表尺寸, 页面尺寸) ->
  {宽度: 图宽, 高度: 图高} = 图表尺寸
  {宽度: 页宽, 高度: 页高} = 页面尺寸
  
  缩放比例 = Math.min(页宽 / 图宽, 页高 / 图高)
  
  if 缩放比例 >= 0.8
    return 策略: "缩放", 比例: 缩放比例
  else if 图高 > 页高 * 2
    return 策略: "分页", 页数: Math.ceil(图高 / 页高)
  else
    return 策略: "平铺", 每行: Math.floor(页宽 / 图宽)
```

#### 测试结果

**方案1: Puppeteer截图** ✅ 成功

| 图表 | 尺寸 (宽x高) | 文件 |
|------|---------------|------|
| 图表1 | 670 x 1039 | T001-图表1.png |
| 图表2 | 670 x 766 | T001-图表2.png |
| 图表3 | 670 x 2160 | T001-图表3.png |
| 图表4 | 670 x 564 | T001-图表4.png |
| 图表5 | 670 x 4577 | T001-图表5.png |
| 图表6 | 670 x 1869 | T001-图表6.png |

**优点**：
- ✅ 可以直接从HTML截图
- ✅ 可以获取图表的实际尺寸
- ✅ 可以精确控制截图区域
- ✅ 支持批量处理多个图表
- ✅ 图表清晰度高

**缺点**：
- ❌ 需要安装Chrome
- ❌ 依赖外部浏览器，不够轻量
- ❌ 占用资源较多

**结论**：推荐使用 - 方案1成功实现了从HTML截图的功能，可以获取图表的实际尺寸，为后续的PDF/PPTX排版提供基础。

## 🔬 实践驱动的开发方法

### 核心理念

"实践出真知" - 通过实际编写和测试代码，深入理解API的设计意图和使用方式。

### 开发流程

1. **阅读代码** - 理解项目结构和设计
2. **实践验证** - 在工作间中实现类似功能
3. **对比分析** - 对比主项目和实践代码
4. **发现问题** - 识别潜在问题和改进点
5. **提出建议** - 基于实践经验提出改进建议
6. **编写报告** - 整理发现和建议，形成报告

### 调试策略

1. **简化版本** - 先实现简化版本，快速验证
2. **逐步完善** - 确认基本功能后，逐步添加特性
3. **测试验证** - 每次修改后立即测试
4. **文档记录** - 记录问题和解决方案

## 🔧 技术栈

- **CoffeeScript**: 主要开发语言
- **Mermaid**: 图表生成库（v10）
- **RevealJS**: HTML演示框架（v4.5.0）
- **Node.js**: 运行环境

## 📌 最近更新（2026-03-02）

### 代码审查
- ✅ 深入全面审查完成
- ✅ 审查方法论文档完成
- ✅ HTML转换方法研究完成

### 工具开发
- ✅ Mermaid核心API完成
- ✅ HTML生成器完成
- ✅ 修复版完成（解决渲染问题）
- ✅ 简化测试版完成
- ✅ 多种API风格实现完成

### 关键发现
1. **Mermaid渲染**：使用 `startOnLoad: true` 最可靠
2. **代码格式**：左对齐，无缩进
3. **状态图语法**：使用 `[*]` 表示开始状态
4. **样式优化**：容器高度和字体大小要合适

## 🚧 待办事项

- [ ] 集成Mermaid图表到PPTX
- [ ] 支持更多页面类型
- [ ] 优化表格页样式
- [ ] 添加图片支持
- [ ] 支持动画效果

## 📞 联系方式

如有问题或建议，请通过以下方式联系：
- 提交Issue
- 发送Pull Request
- 更新文档

---

**最后更新**: 2026-03-02
