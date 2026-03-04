# BoxesPlus - 幻灯片类型完整总结

## 📊 文档说明

本文档总结了所有探索过的幻灯片类型，包括：
- 当前声明式框架已实现的类型
- boxesplus/api中的优秀实现
- 其他reviewer探索的类型

---

## ✅ 当前声明式框架已实现（16种）

### 基础类型

| 类型 | 类名 | 说明 | 使用场景 |
|------|------|------|----------|
| 标题页 | TitleSlide | 课程封面、章节封面 | 封面、章节分隔 |
| 内容页 | ContentSlide | 简单文本内容 | 文字说明、要点列表 |
| 双栏页 | TwoColumnSlide | 左右对比内容 | 对比分析、优缺点 |
| 表格页 | TableSlide | 表格数据展示 | 数据对比、信息汇总 |
| 卡片页 | CardSlide | 卡片式布局 | 多个要点、分类展示 |

### 视觉类型

| 类型 | 类名 | 说明 | 使用场景 |
|------|------|------|----------|
| 图片页 | ImageSlide | 单张图片展示 | 图片说明、案例展示 |
| 图文页 | ImageTextSlide | 图文混排 | 图片+文字说明 |

### 信息类型

| 类型 | 类名 | 说明 | 使用场景 |
|------|------|------|----------|
| 时间线页 | TimelineSlide | 时间轴展示 | 项目进度、历史事件 |
| 引用页 | QuoteSlide | 名言引用 | 金句、重要观点 |
| 数字页 | NumberSlide | 数字展示 | 数据统计、关键指标 |

### 流程类型

| 类型 | 类名 | 说明 | 使用场景 |
|------|------|------|----------|
| 流程页 | ProcessSlide | 流程步骤 | 工作流程、操作步骤 |
| 甘特图页 | GanttSlide | 甘特图 | 项目计划、时间安排 |

### 分析类型

| 类型 | 类名 | 说明 | 使用场景 |
|------|------|------|----------|
| 对比页 | ComparisonSlide | 对比分析 | 方案对比、优劣分析 |
| 金字塔页 | PyramidSlide | 层级结构 | 组织架构、层次关系 |
| 思维导图页 | MindmapSlide | 思维导图 | 知识结构、思维框架 |
| SWOT分析页 | SWOTSlide | SWOT分析 | 战略分析、优劣势分析 |

---

## 🆕 boxesplus/api中的优秀实现（可集成）

### 结构类型

| 类型 | 函数名 | 说明 | 使用场景 | 来源文件 |
|------|--------|------|----------|----------|
| 章节页 | sectionSlide | 章节分隔 | 章节开始 | elegant.coffee |
| 结束页 | endSlide | 结束致谢 | 演示结束 | elegant.coffee |

### 图表类型

| 类型 | 函数名 | 说明 | 使用场景 | 来源文件 |
|------|--------|------|----------|----------|
| PDCA循环 | pdcaSlide | PDCA循环图 | 质量管理、持续改进 | chart-components.coffee |
| 组织架构 | orgChartSlide | 组织架构图 | 组织结构、层级关系 | elegant.coffee |
| 流程图 | flowchartSlide | 水平流程图 | 工作流程、步骤展示 | chart-components.coffee |

### 布局类型

| 类型 | 函数名 | 说明 | 使用场景 | 来源文件 |
|------|--------|------|----------|----------|
| 方框 | boxSlide | 方框布局 | 重点内容、框式展示 | boxesplus-api.coffee |
| 矩阵 | matrixSlide | 2x2矩阵 | 象限分析、分类展示 | elegant.coffee |

---

## 📝 其他reviewer探索的类型

### 数据驱动类型（data-driven.coffee）

| 类型 | 说明 | 特点 |
|------|------|------|
| title | 标题页 | 支持渐变背景 |
| section | 章节页 | 支持编号、标题、副标题 |
| end | 结束页 | 支持致谢语 |
| list | 列表页 | 自动编号 |
| cards | 卡片页 | 支持多列布局 |
| pdca | PDCA循环 | SVG绘制 |
| swot | SWOT分析 | 4象限布局 |
| timeline | 时间线 | 垂直时间轴 |
| flowchart | 流程图 | 水平流程 |
| org | 组织架构 | 层级结构 |
| comparison | 对比分析 | 表格或左右对比 |

### Markdown转换器类型（markdown转换器.coffee）

| 类型 | 说明 | 自动判断规则 |
|------|------|--------------|
| 封面页 | 课程封面 | 第一个#标题 |
| 章节页 | 章节分隔 | ##标题 |
| 列表页 | 列表内容 | - 开头的列表 |
| 表格页 | 表格内容 | 内容行数 > 5 或单行 > 50字 |
| 卡片页 | 卡片内容 | 内容行数 ≤ 5 且单行 ≤ 50字 |

### 混合生成器类型（hybrid-generator.coffee）

| 类型 | 说明 | 特点 |
|------|------|------|
| Mermaid图表 | 流程图、时序图等 | 使用Mermaid语法 |
| 饼图 | 数据占比 | SVG绘制 |
| 事件闭环 | 事件流程 | SVG绘制 |

---

## 🎯 幻灯片类型分类

### 按用途分类

#### 1. 结构类（用于组织内容）
- TitleSlide（标题页）
- SectionSlide（章节页）
- EndSlide（结束页）

#### 2. 内容类（用于展示信息）
- ContentSlide（内容页）
- ListSlide（列表页）
- TableSlide（表格页）
- CardSlide（卡片页）
- BoxSlide（方框页）

#### 3. 视觉类（用于增强表现）
- ImageSlide（图片页）
- ImageTextSlide（图文页）
- QuoteSlide（引用页）

#### 4. 分析类（用于分析思考）
- SWOTSlide（SWOT分析）
- ComparisonSlide（对比分析）
- MatrixSlide（矩阵分析）
- PyramidSlide（金字塔）

#### 5. 流程类（用于展示流程）
- ProcessSlide（流程页）
- TimelineSlide（时间线）
- GanttSlide（甘特图）
- FlowchartSlide（流程图）
- PDCASlide（PDCA循环）

#### 6. 结构类（用于展示结构）
- OrgChartSlide（组织架构）
- MindmapSlide（思维导图）

---

## 📊 幻灯片类型优先级

### 高优先级（核心类型）
1. ✅ TitleSlide - 标题页
2. ✅ ContentSlide - 内容页
3. ✅ TableSlide - 表格页
4. ✅ CardSlide - 卡片页
5. ✅ ProcessSlide - 流程页
6. ✅ SWOTSlide - SWOT分析

### 中优先级（常用类型）
1. ✅ ImageSlide - 图片页
2. ✅ ImageTextSlide - 图文页
3. ✅ TimelineSlide - 时间线
4. ✅ ComparisonSlide - 对比分析
5. ✅ QuoteSlide - 引用页
6. 🆕 SectionSlide - 章节页
7. 🆕 EndSlide - 结束页

### 低优先级（特殊类型）
1. ✅ TwoColumnSlide - 双栏页
2. ✅ NumberSlide - 数字页
3. ✅ GanttSlide - 甘特图
4. ✅ PyramidSlide - 金字塔
5. ✅ MindmapSlide - 思维导图
6. 🆕 PDCASlide - PDCA循环
7. 🆕 OrgChartSlide - 组织架构
8. 🆕 BoxSlide - 方框
9. 🆕 MatrixSlide - 矩阵
10. 🆕 FlowchartSlide - 流程图

---

## 🚀 集成计划

### 阶段1：完善核心类型（已完成）
- ✅ 16种基础幻灯片类型
- ✅ 声明式框架设计
- ✅ 完整示例（E02品牌建设课程）

### 阶段2：集成新类型（待进行）
- 🆕 SectionSlide - 章节页
- 🆕 EndSlide - 结束页
- 🆕 PDCASlide - PDCA循环
- 🆕 OrgChartSlide - 组织架构
- 🆕 BoxSlide - 方框
- 🆕 MatrixSlide - 矩阵

### 阶段3：优化和测试（待进行）
- 测试所有幻灯片类型
- 优化样式和布局
- 完善文档

### 阶段4：高级功能（未来）
- Mermaid图表集成
- 动画效果
- 主题系统

---

## 📝 使用示例

### 当前声明式框架示例

```coffee
{ Slide, TitleSlide, ContentSlide, TableSlide, CardSlide,
  ImageSlide, ImageTextSlide, TimelineSlide, QuoteSlide,
  NumberSlide, ProcessSlide, GanttSlide, ComparisonSlide,
  PyramidSlide, MindmapSlide, SWOTSlide,
  Section, Chapter, Presentation } = require "./declarative-pptx-api"

# 标题页
class 课程名称 extends TitleSlide
    @副标题: "医院管理核心模块课程"

# 内容页
class 课程对象 extends ContentSlide
    @对象1: "医院院长、书记、分管副院长"
    @对象2: "品牌/宣传/市场/客服部门负责人"

# SWOT分析页
class 品牌建设SWOT分析 extends SWOTSlide
    @优势: ["技术领先", "专家团队"]
    @劣势: ["传播不足", "新媒体弱"]
    @机会: ["政策支持", "市场需求"]
    @威胁: ["竞争激烈", "舆论风险"]

# 演示文稿
class E02品牌建设课程 extends Presentation
    @sections: -> [
        课程信息章
        第一章医院品牌管理概述
    ]
    @nowYou: @newPresentation()
```

---

## 📚 参考文件

### 核心文件
- `/Users/jk/gits/hub/consult_strategy/boxesplus/glm5reviews/ReviewerLab/declarative-pptx-api/index.coffee` - 声明式框架核心
- `/Users/jk/gits/hub/consult_strategy/boxesplus/glm5reviews/ReviewerLab/E02品牌建设课程.coffee` - 完整示例

### 参考文件
- `/Users/jk/gits/hub/consult_strategy/boxesplus/api/elegant.coffee` - 极简诗式版
- `/Users/jk/gits/hub/consult_strategy/boxesplus/api/chart-components.coffee` - 图表组件
- `/Users/jk/gits/hub/consult_strategy/boxesplus/api/data-driven.coffee` - 数据驱动
- `/Users/jk/gits/hub/consult_strategy/boxesplus/api/boxesplus-api.coffee` - DSL解析器
- `/Users/jk/gits/hub/consult_strategy/boxesplus/api/mermaid-api.coffee` - Mermaid图表

---

**最后更新**: 2026-03-04
**维护者**: Reviewer AI
