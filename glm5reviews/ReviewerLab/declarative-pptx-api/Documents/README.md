# Declarative PPTX API

**声明式PPTX生成框架 - 让PPTX生成变得简单优雅**

## 🎯 核心理念

**人 = 数据（内容）**，**衣服 = 幻灯片类型**

同样的数据，只需要改变继承的类，就可以换不同的展示方式！

**古时候的写作方式**：
- 用纸张写作（先写内容）
- 装订成册（多少页一册呢）
- 一册多少卷呢（一册有多少卷）
- 整个封面怎么写呢（给整本书写封面）

**我们的 API 完美支持这种写作方式**：
- 先写所有的内容（幻灯片）
- 然后装订成册（节）
- 然后组织成一册（演示文稿）

## ✨ 特性

- **声明式设计**：用户只需要定义类，不需要调用任何东西
- **任意顺序**：类定义顺序无关，自由写作
- **古时候写作方式**：先写内容，然后装订成册，然后组织成一册
- **比 Markdown 还好**：支持自由顺序，可以随时调整结构
- **多种类型**：17种幻灯片类型，满足各种展示需求
- **智能布局**：自动调整字体大小，避免内容溢出
- **简单优雅**：完美体现CoffeeScript的独特特性

## 🚀 快速开始

### 1. 引入框架

```coffee
{ 
    Slide, TitleSlide, ContentSlide, TwoColumnSlide, TableSlide, CardSlide,
    ImageSlide, ImageTextSlide, TimelineSlide, QuoteSlide, NumberSlide,
    ProcessSlide, GanttSlide, ComparisonSlide, PyramidSlide, MindmapSlide, SWOTSlide,
    Section, Chapter, Presentation 
} = require "./index"
```

### 2. 定义演示文稿

```coffee
class 我的演示文稿 extends Presentation
    @sections: -> [
        第一章
        第二章
    ]
    @nowYou: @newPresentation()
```

### 3. 定义章

```coffee
class 第一章 extends Chapter
    @节: -> [
        第一节
        第二节
    ]
```

### 4. 定义节

```coffee
class 第一节 extends Section
    @幻灯片: -> [
        幻灯片1
        幻灯片2
    ]
```

### 5. 定义幻灯片

```coffee
class 幻灯片1 extends ContentSlide
    @要点1: "这是第一个要点"
    @要点2: "这是第二个要点"
    @要点3: "这是第三个要点"
```

### 6. 运行

```bash
coffee self.coffee
```

## 📊 幻灯片类型

### 基础类型

| 类型 | 用途 | 特点 |
|------|------|------|
| Slide | 基础幻灯片 | 标题+内容 |
| TitleSlide | 标题页 | 居中大标题 |
| ContentSlide | 内容页 | 列表形式，带项目符号 |
| TwoColumnSlide | 两栏页 | 左右两栏布局 |
| TableSlide | 表格页 | 表格形式展示 |
| CardSlide | 卡片页 | 卡片式展示 |

### 视觉类型

| 类型 | 用途 | 特点 |
|------|------|------|
| ImageSlide | 图片页 | 图片展示 |
| ImageTextSlide | 图文混排页 | 左图右文 |
| QuoteSlide | 引用页 | 引用样式 |
| NumberSlide | 数字页 | 大数字展示 |

### 图表类型

| 类型 | 用途 | 特点 |
|------|------|------|
| ProcessSlide | 流程图页 | 流程步骤展示 |
| GanttSlide | 甘特图页 | 项目时间线 |
| TimelineSlide | 时间线页 | 时间轴展示 |
| ComparisonSlide | 对比页 | 左右对比 |
| PyramidSlide | 金字塔页 | 层级结构 |
| MindmapSlide | 思维导图页 | 放射状结构 |
| SWOTSlide | SWOT分析页 | 四象限分析 |

## 🎭 换衣服（改变展示方式）

**同样的数据，只需要改变继承的类！**

```coffee
# 方式1：普通Slide
class 品牌定义 extends Slide
    @定义: "品牌是一个名称..."
    @公式: "品牌 = 产品功能 + ..."

# 方式2：ContentSlide（列表形式）
class 品牌定义 extends ContentSlide
    @定义: "品牌是一个名称..."
    @公式: "品牌 = 产品功能 + ..."

# 方式3：CardSlide（卡片形式）
class 品牌定义 extends CardSlide
    @定义: "品牌是一个名称..."
    @公式: "品牌 = 产品功能 + ..."

# 方式4：TableSlide（表格形式）
class 品牌定义 extends TableSlide
    @定义: "品牌是一个名称..."
    @公式: "品牌 = 产品功能 + ..."
```

## 📝 版本管理

**通过改名保存不同版本**

```coffee
# 第一版
class E02品牌建设课程第一版 extends Presentation
    @sections: -> [...]
    @nowYou: @newPresentation()
# 输出：outputs/E02品牌建设课程第一版.pptx

# 第二版
class E02品牌建设课程第二版 extends Presentation
    @sections: -> [...]
    @nowYou: @newPresentation()
# 输出：outputs/E02品牌建设课程第二版.pptx
```

## 📂 文件结构

```
declarative-pptx-api/
├── index.coffee              # 核心框架
├── README.md                 # 使用文档
├── Documents/               # 文档目录
│   └── README.md           # 使用文档
├── coffee-works/           # CoffeeScript 工作目录
│   └── 项目演进史.coffee   # 示例：50页项目演进史
└── outputs/               # 输出目录
    └── BoxesPlus项目演进史.pptx  # 生成的PPTX文件
```

## 📝 推荐的写作方式

### 方式1：古时候的写作方式（推荐）

**先写所有的内容（幻灯片）**：
```coffeescript
class 封面 extends TitleSlide
  @副标题: "从起步到光明顶的演进之路"

class 目录 extends ContentSlide
  @起源: "项目起源与早期探索"
  @框架: "声明式框架的诞生"
  @演进: "框架的持续演进"
  @协作: "AI协作与知识共享"
  @未来: "未来展望"

class 第一章标题 extends Slide
  @layout: "section"
  @title: "第一章"

class 项目起源 extends ContentSlide
  @背景: "2024年，医院管理培训需求激增"
  @痛点: "传统PPT制作效率低、质量不稳定"
  @目标: "开发自动化PPT生成系统"
  @技术: "选择CoffeeScript作为开发语言"

# ... 一直写到第十章的所有幻灯片
```

**然后装订成册（节）**：
```coffeescript
class 封面章节 extends Section
  @幻灯片: -> [
    封面
    目录
  ]

class 第一章 extends Section
  @幻灯片: -> [
    第一章标题
    项目起源
    早期探索
    HQCoffee参考
    早期技术栈
  ]
# ... 一直装订到第十章
```

**然后组织成一册（演示文稿）**：
```coffeescript
class BoxesPlus项目演进史 extends Presentation
  @sections: -> [
    封面章节
    第一章
    第二章
    # ... 一直到第十章
  ]
  
  @now: @newPresentation()
```

**优势**：
- 先写所有的内容（幻灯片）- 这部分比较复杂，但可以专注于内容
- 然后装订成册（节）- 这部分很简单，只是组织结构
- 然后组织成一册（演示文稿）- 这部分更简单，只是引用节
- 符合人类的写作习惯，像古时候的写作方式

### 方式2：自顶向下（E02 的方式）

**先定义演示文稿，再定义章、节、幻灯片**：
```coffeescript
class E02品牌建设课程 extends Presentation
    @sections: -> [
        课程信息章
        第一章医院品牌管理概述
        第二章医院品牌战略规划
    ]
    @nowYou: @newPresentation()

class 课程信息章 extends Chapter
    @节: -> [
        课程信息节
        课程目标节
    ]

class 课程信息节 extends Section
    @幻灯片: -> [
        课程名称
        课程定位
        课程对象
    ]

class 课程名称 extends TitleSlide
    @副标题: "医院管理核心模块课程 | 12小时（2天）"
```

**优势**：
- 先规划整体结构
- 适合大型项目
- 适合团队协作

### 方式3：自底向上（F05 的方式）

**先定义幻灯片，再定义节，最后定义演示文稿**：
```coffeescript
class 封面 extends TitleSlide
  @副标题: "医院管理保障与支撑模块"

class 课程信息 extends ContentSlide
  @课程名称: "AI时代的数据资产管理"
  @课程定位: "医院管理保障与支撑模块（优选课程）"
  @课程对象: "医院院长，信息中心主任、医务部主任"
  @教学方法: "理论讲授、案例分析、课堂讨论"

class 概述章节 extends Section
  @幻灯片: -> [
    封面
    课程信息
    课程目标
  ]

class F05数据资产管理课程 extends Presentation
  @sections: -> [
    概述章节
    第一章
    第二章
    # ...
  ]
  
  @now: @newPresentation()
```

**优势**：
- 先定义组件，再组装
- 适合快速原型
- 适合个人项目

### 选择哪种方式？

- **推荐使用方式1（古时候的写作方式）**：
  - 符合人类的写作习惯
  - 先写内容，然后装订成册，然后组织成一册
  - 比 Markdown 还好，支持自由顺序

- **根据实际情况选择方式2或方式3**：
  - 大型项目、团队协作 → 方式2（自顶向下）
  - 快速原型、个人项目 → 方式3（自底向上）

## 🔧 核心技术

### 1. 函数延迟解析

```coffee
@sections: -> [学科平台定义]  # 函数延迟解析
```

### 2. setImmediate 延迟执行

```coffee
@newPresentation: ->
    setImmediate => @generate()  # 延迟到下一个事件循环
```

### 3. 类定义时执行

```coffee
@nowYou: @newPresentation()  # 任意名字，让函数跑起来
```

### 4. 智能布局

框架会自动处理以下问题：
- **内容溢出** - 自动调整字体大小，确保内容不跑到页面外面
- **布局优化** - 将瘦高内容摆成扁平状态，更美观
- **字体调整** - 根据内容长度自动缩小字体
- **空间利用** - 充分利用页面空间，避免浪费

**用户不用操心布局和样式，框架全包了！**

## 📚 示例

### 简单示例

```coffee
{ Slide, Section, Chapter, Presentation } = require "./index"

class 我的幻灯片 extends Presentation
    @sections: -> [学科平台定义]
    @nowYou: @newPresentation()

class 学科平台定义 extends Chapter
    @节: -> [国际学科平台定义]

class 国际学科平台定义 extends Section
    @幻灯片: -> [AI革命前教学平台定义]

class AI革命前教学平台定义 extends Slide
    @AI革命前: "那是一个美好的时代..."
    @AI革命后: "AI革命后，教学平台发生了翻天覆地的变化。"
```

### 完整示例

查看 `examples/E02品牌建设课程.coffee`，包含：
- 17种幻灯片类型的实际应用
- 完整的课程结构
- 多种展示方式的对比

## 🎉 总结

**声明式框架是最优雅的设计**，完美体现了CoffeeScript的独特特性：
1. 类定义时执行代码
2. 函数延迟解析
3. setImmediate 延迟执行
4. 任意顺序定义类

**这是不能再简单的语言了，让一切复杂代码去见鬼！**

## 🚀 新认知：结构层次与设计纯粹性

### 核心理念

**古时候的写作方式**：
- 用纸张写作（先写内容）
- 装订成册（多少页一册呢）
- 一册多少卷呢（一册有多少卷）
- 整个封面怎么写呢（给整本书写封面）

**我们的 API 完美支持这种写作方式**：
- 先写所有的内容（幻灯片）
- 然后装订成册（节）
- 然后组织成一册（演示文稿）

### 完整结构层次

```
Presentation（书）
└── Section（册）
    └── Chapter（章）
        └── Node（节）
            └── Slide（幻灯片）
```

**允许省略中间任何一层**：
- Presentation → Slide（最简单）
- Presentation → Section → Slide
- Presentation → Section → Chapter → Slide
- Presentation → Section → Chapter → Node → Slide（完整结构）

### 关键设计原则

1. **物理和逻辑分离**
   - Presentation（物理上的）
   - Section（物理上的）
   - Chapter（逻辑上的）
   - Node（逻辑上的）
   - Slide（物理上的）

2. **词根不重复**
   - Section（册）
   - Chapter（章）
   - Node（节）
   - 避免与 PPTX 的 Section 冲突

3. **每一层本身就是封面**
   - 每一层只需要提供名字
   - 名字就是封面的名字
   - 不需要单独定义"封面"类

4. **每一层都有自己的风格**
   - Presentation → 整体风格
   - Section → 册风格
   - Chapter → 章风格
   - Node → 节风格
   - Slide → 幻灯片风格

5. **继承机制自动切换风格**
   - 用户 extend Presentation → 获得 Presentation 的风格
   - 用户 extend Section → 自动切换成 Section 风格
   - 用户 extend Chapter → 自动切换成 Chapter 风格
   - 用户 extend Node → 自动切换成 Node 风格
   - 用户 extend Slide → 自动切换成 Slide 风格

6. **设计纯粹**
   - 去掉多余的东西
   - 不需要单独定义"封面"类
   - 不需要单独定义"封面Slide"
   - 每一层只需要提供名字

### 实际应用价值

1. **用户可以随意调整结构**
   - 从 Presentation → Section
   - 从 Section → Chapter
   - 从 Chapter → Node
   - 从 Node → Slide

2. **我们的代码也不需要有任何改动**
   - 继承机制自动切换风格
   - 不需要修改任何代码

3. **都是自然的**
   - 同样的名字，不同的风格
   - 就像"换衣服"机制

4. **生成速度又飞快，毫秒级**
   - 用户可以随意调整结构
   - 生成速度又飞快，毫秒级
   - 所以太容易了

### 应用场景

**场景1：本来给我1小时讲课，现在给我5分钟**
- 那我肯定要改PPTX呀，可麻烦了
- 但是在我们工具里面，太简单了
- 生成速度又飞快，毫秒级
- 所以太容易了

**场景2：本来给我完整课程，现在给我精简版**
- 那我肯定要改PPTX呀，可麻烦了
- 但是在我们工具里面，太简单了
- 生成速度又飞快，毫秒级
- 所以太容易了

**场景3：本来给我学术版，现在给我商业版**
- 那我肯定要改PPTX呀，可麻烦了
- 但是在我们工具里面，太简单了
- 生成速度又飞快，毫秒级
- 所以太容易了

---

**最后更新**: 2026-03-05
