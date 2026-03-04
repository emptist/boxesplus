# Declarative PPTX API

**声明式PPTX生成框架 - 让PPTX生成变得简单优雅**

## 🎯 核心理念

**人 = 数据（内容）**，**衣服 = 幻灯片类型**

同样的数据，只需要改变继承的类，就可以换不同的展示方式！

## ✨ 特性

- **声明式设计**：用户只需要定义类，不需要调用任何东西
- **任意顺序**：类定义顺序无关，自由写作
- **多种类型**：17种幻灯片类型，满足各种展示需求
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
└── examples/                 # 示例代码
    ├── self.coffee           # 简单示例
    ├── you.coffee            # 测试示例
    └── E02品牌建设课程.coffee # 完整示例
```

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

---

**最后更新**: 2026-03-04
