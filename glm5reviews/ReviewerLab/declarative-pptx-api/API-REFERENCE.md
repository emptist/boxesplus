# BoxesPlus - 声明式PPTX生成框架 API参考文档

## 📋 目录

- [核心概念](#核心概念)
- [快速开始](#快速开始)
- [核心类](#核心类)
- [幻灯片类型](#幻灯片类型)
- [示例代码](#示例代码)
- [错误处理](#错误处理)
- [最佳实践](#最佳实践)

---

## 核心概念

### 声明式设计

BoxesPlus采用声明式设计，用户只需要定义类，不需要调用任何API。

**核心理念**：
- 类名即标题
- 属性即内容
- 自动生成PPTX

**关键特性**：
1. **函数延迟解析**：`@sections: -> [...]`
2. **setImmediate延迟执行**：`@newPresentation: -> setImmediate => @generate()`
3. **类定义时执行**：`@nowYou: @newPresentation()`
4. **任意顺序定义类**：用户可以自由写作

---

## 快速开始

### 安装依赖

```bash
npm install pptxgenjs
```

### 创建第一个演示文稿

```coffee
# my-first-presentation.coffee
{ TitleSlide, ContentSlide, Presentation } = require "./declarative-pptx-api"

# 定义标题页
class 我的第一个演示 extends TitleSlide
    @副标题: "声明式PPTX生成示例"

# 定义内容页
class 主要内容 extends ContentSlide
    @要点1: "声明式设计，简单优雅"
    @要点2: "类名即标题，属性即内容"
    @要点3: "自动生成，无需调用API"

# 定义演示文稿
class MyPresentation extends Presentation
    @sections: -> [我的第一个演示, 主要内容]
    @nowYou: @newPresentation()

# 运行：coffee my-first-presentation.coffee
# 输出：outputs/MyPresentation.pptx
```

---

## 核心类

### Slide - 幻灯片基类

所有幻灯片类型的基类，提供基础的渲染功能。

**类方法**：
- `@toPptx(pptx)` - 渲染幻灯片到PPTX
- `@getProperties()` - 获取用户定义的属性
- `@renderPropertyToPptx(slide, key, value, y)` - 渲染属性到幻灯片
- `@createErrorSlide(pptx, error)` - 创建错误提示页

---

### Section - 节类

用于组织幻灯片的容器。

**支持属性**：
- `@幻灯片: -> [...]` - 幻灯片列表（函数形式，推荐）
- `@幻灯片: [...]` - 幻灯片列表（数组形式）

**示例**：
```coffee
class 第一章节 extends Section
    @幻灯片: -> [
        标题页
        内容页1
        内容页2
    ]
```

---

### Chapter - 章类

用于组织节的容器。

**支持属性**：
- `@节: -> [...]` - 节列表（函数形式，推荐）
- `@节: [...]` - 节列表（数组形式）

**示例**：
```coffee
class 第一章 extends Chapter
    @节: -> [
        第一节
        第二节
    ]
```

---

### Presentation - 演示文稿类

顶层容器，代表整个演示文稿。

**支持属性**：
- `@sections: -> [...]` - 章列表（函数形式，推荐）
- `@sections: [...]` - 章列表（数组形式）
- `@nowYou: @newPresentation()` - 自动生成（必须）

**类方法**：
- `@generate()` - 生成PPTX文件
- `@newPresentation()` - 创建新演示文稿（延迟执行）

**示例**：
```coffee
class MyPresentation extends Presentation
    @sections: -> [
        第一章
        第二章
    ]
    @nowYou: @newPresentation()
```

---

## 幻灯片类型

### TitleSlide - 标题页

用于课程封面、章节封面。

**支持属性**：
- `@副标题: string` - 副标题文本（可选）

**示例**：
```coffee
class 课程名称 extends TitleSlide
    @副标题: "医院管理核心模块课程"
```

---

### ContentSlide - 内容页

用于展示文本内容。

**支持属性**：
- `@属性名: string` - 任意文本内容
- 支持多个属性，每个属性显示为一行

**示例**：
```coffee
class 课程对象 extends ContentSlide
    @对象1: "医院院长、书记、分管副院长"
    @对象2: "品牌/宣传/市场/客服部门负责人"
```

---

### TableSlide - 表格页

用于展示表格数据。

**支持属性**：
- `@属性名: string` - 表格内容，用`|`分隔列

**示例**：
```coffee
class 课程安排 extends TableSlide
    @第一天: "上午|理论讲授|下午|案例分析"
    @第二天: "上午|方法演练|下午|实操练习"
```

---

### CardSlide - 卡片页

用于展示卡片式内容。

**支持属性**：
- `@卡片: [{标题, 内容}]` - 卡片数组

**示例**：
```coffee
class 课程目标 extends CardSlide
    @卡片: [
        {标题: "知识目标", 内容: "掌握品牌管理理论"}
        {标题: "能力目标", 内容: "制定品牌战略"}
        {标题: "素质目标", 内容: "培养品牌思维"}
    ]
```

---

### ImageSlide - 图片页

用于展示单张图片。

**支持属性**：
- `@图片: string` - 图片路径

**示例**：
```coffee
class 案例展示 extends ImageSlide
    @图片: "./images/case-study.png"
```

---

### ImageTextSlide - 图文页

用于展示图片和文字。

**支持属性**：
- `@属性名: {图: string, 文: string}` - 图文对象

**示例**：
```coffee
class 品牌案例 extends ImageTextSlide
    @案例1:
        图: "./images/brand1.png"
        文: "这是品牌案例的详细说明"
```

---

### TimelineSlide - 时间线页

用于展示时间轴。

**支持属性**：
- `@事件: [{时间, 事件}]` - 事件数组

**示例**：
```coffee
class 项目进度 extends TimelineSlide
    @事件: [
        {时间: "2024-01", 事件: "项目启动"}
        {时间: "2024-03", 事件: "需求分析"}
        {时间: "2024-06", 事件: "开发完成"}
    ]
```

---

### QuoteSlide - 引用页

用于展示名言引用。

**支持属性**：
- `@引用: string` - 引用内容
- `@作者: string` - 作者（可选）

**示例**：
```coffee
class 名言警句 extends QuoteSlide
    @引用: "品牌是企业最重要的无形资产"
    @作者: "管理大师"
```

---

### NumberSlide - 数字页

用于展示数字统计。

**支持属性**：
- `@数字: [{数值, 标签}]` - 数字数组

**示例**：
```coffee
class 关键数据 extends NumberSlide
    @数字: [
        {数值: "100+", 标签: "成功案例"}
        {数值: "50+", 标签: "合作医院"}
        {数值: "10年", 标签: "行业经验"}
    ]
```

---

### ProcessSlide - 流程页

用于展示流程步骤。

**支持属性**：
- `@步骤: [{名称, 描述}]` - 步骤数组

**示例**：
```coffee
class 工作流程 extends ProcessSlide
    @步骤: [
        {名称: "需求分析", 描述: "了解客户需求"}
        {名称: "方案设计", 描述: "制定解决方案"}
        {名称: "实施部署", 描述: "执行落地"}
    ]
```

---

### GanttSlide - 甘特图页

用于展示项目计划。

**支持属性**：
- `@任务: [{任务, 开始, 结束}]` - 任务数组

**示例**：
```coffee
class 项目计划 extends GanttSlide
    @任务: [
        {任务: "需求分析", 开始: "2024-01", 结束: "2024-02"}
        {任务: "系统设计", 开始: "2024-02", 结束: "2024-03"}
        {任务: "开发测试", 开始: "2024-03", 结束: "2024-06"}
    ]
```

---

### ComparisonSlide - 对比页

用于展示对比分析。

**支持属性**：
- `@对比: [{维度, 方案A, 方案B}]` - 对比数组

**示例**：
```coffee
class 方案对比 extends ComparisonSlide
    @对比: [
        {维度: "成本", 方案A: "低", 方案B: "高"}
        {维度: "效率", 方案A: "高", 方案B: "低"}
        {维度: "风险", 方案A: "低", 方案B: "高"}
    ]
```

---

### PyramidSlide - 金字塔页

用于展示层级结构。

**支持属性**：
- `@层级: [string]` - 层级数组

**示例**：
```coffee
class 组织架构 extends PyramidSlide
    @层级: [
        "战略层"
        "管理层"
        "执行层"
    ]
```

---

### MindmapSlide - 思维导图页

用于展示思维导图。

**支持属性**：
- `@中心: string` - 中心主题
- `@分支: [string]` - 分支主题

**示例**：
```coffee
class 知识体系 extends MindmapSlide
    @中心: "品牌管理"
    @分支: ["品牌战略", "品牌传播", "品牌评估"]
```

---

### SWOTSlide - SWOT分析页

用于战略分析、优劣势分析。

**支持属性**：
- `@优势 or @S: string` - 优势内容
- `@劣势 or @W: string` - 劣势内容
- `@机会 or @O: string` - 机会内容
- `@威胁 or @T: string` - 威胁内容
- 至少需要一个属性

**示例**：
```coffee
class 品牌建设SWOT分析 extends SWOTSlide
    @优势: "技术领先、专家团队"
    @劣势: "传播不足、新媒体弱"
    @机会: "政策支持、市场需求"
    @威胁: "竞争激烈、舆论风险"
```

---

## 示例代码

### 完整示例

```coffee
{ TitleSlide, ContentSlide, TableSlide, CardSlide,
  ImageSlide, ImageTextSlide, TimelineSlide, QuoteSlide,
  NumberSlide, ProcessSlide, GanttSlide, ComparisonSlide,
  PyramidSlide, MindmapSlide, SWOTSlide,
  Section, Chapter, Presentation } = require "./declarative-pptx-api"

# ============================================
# 第一章：课程介绍
# ============================================

class 课程名称 extends TitleSlide
    @副标题: "医院品牌建设课程"

class 课程目标 extends CardSlide
    @卡片: [
        {标题: "知识目标", 内容: "掌握品牌管理理论"}
        {标题: "能力目标", 内容: "制定品牌战略"}
        {标题: "素质目标", 内容: "培养品牌思维"}
    ]

class 第一章节 extends Section
    @幻灯片: -> [课程名称, 课程目标]

# ============================================
# 第二章：品牌分析
# ============================================

class 品牌建设SWOT分析 extends SWOTSlide
    @优势: "技术领先、专家团队"
    @劣势: "传播不足、新媒体弱"
    @机会: "政策支持、市场需求"
    @威胁: "竞争激烈、舆论风险"

class 第二章节 extends Section
    @幻灯片: -> [品牌建设SWOT分析]

# ============================================
# 演示文稿
# ============================================

class E02品牌建设课程 extends Presentation
    @sections: -> [第一章节, 第二章节]
    @nowYou: @newPresentation()
```

---

## 错误处理

### 自动错误捕获

框架会自动捕获错误并创建错误提示页：

```coffee
# 错误示例：副标题类型错误
class 错误示例 extends TitleSlide
    @副标题: 123  # 应该是string，不是number

# 运行时会显示：
# ❌ Error in TitleSlide '错误示例': 副标题 must be a string
```

### 验证方法

每种幻灯片类型都有验证方法：

```coffee
class TitleSlide extends Slide
    @validate: ->
        unless @name
            throw new Error "TitleSlide must have a name"
        if @副标题 and typeof @副标题 isnt 'string'
            throw new Error "副标题 must be a string"
        true
```

---

## 最佳实践

### 1. 使用函数延迟解析

```coffee
# ✅ 推荐
class MyPresentation extends Presentation
    @sections: -> [Section1, Section2]

# ❌ 不推荐
class MyPresentation extends Presentation
    @sections: [Section1, Section2]
```

### 2. 类名要有意义

```coffee
# ✅ 推荐
class 课程目标 extends CardSlide

# ❌ 不推荐
class Slide1 extends CardSlide
```

### 3. 组织代码结构

```coffee
# ✅ 推荐：按章节组织
# ============================================
# 第一章：课程介绍
# ============================================

class 课程名称 extends TitleSlide
    @副标题: "医院品牌建设课程"

class 第一章节 extends Section
    @幻灯片: -> [课程名称]

# ============================================
# 演示文稿
# ============================================

class MyPresentation extends Presentation
    @sections: -> [第一章节]
    @nowYou: @newPresentation()
```

### 4. 保持简洁

```coffee
# ✅ 推荐：简洁明了
class 课程对象 extends ContentSlide
    @对象1: "医院院长、书记、分管副院长"
    @对象2: "品牌/宣传/市场/客服部门负责人"

# ❌ 不推荐：过度复杂
class 课程对象 extends ContentSlide
    @对象1: "医院院长、书记、分管副院长（包括正职和副职）"
    @对象2: "品牌/宣传/市场/客服部门负责人（包括部门经理和主管）"
    @对象3: "其他相关人员（如有需要）"
```

---

## 📚 相关文档

- [幻灯片类型总结](./SLIDE-TYPES-SUMMARY.md)
- [打磨完善计划](./IMPROVEMENT-PLAN.md)
- [README](./README.md)

---

**最后更新**: 2026-03-04
**维护者**: Reviewer AI
