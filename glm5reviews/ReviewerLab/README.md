# ReviewerLab - 实验室目录

这是reviewer AI的实验和探索工作区。

## 📂 目录结构

```
ReviewerLab/
├── declarative-pptx-api/  # 🎯 声明式PPTX生成框架（核心API）
│   ├── index.coffee      # 核心框架
│   ├── README.md         # 使用文档
│   └── examples/         # 示例代码
├── my-workspace/         # Mermaid图表生成和PPTX转换实验
│   ├── api/             # API实现
│   ├── demo/            # 演示代码
│   └── deprecated/      # 过时的代码
├── reviewer-workspace/   # 数据和审查实验
│   ├── data/            # 数据文件（JSON格式）
│   └── data2/           # 数据文件（CSON格式）
├── src/                 # 代码副本和示例
│   ├── code/            # 核心代码
│   └── examples/        # 示例代码
├── README.md            # 本文件
├── project_rules.md     # 项目规则
└── .gitignore
```

## 🎯 核心成果

### Declarative PPTX API

**声明式PPTX生成框架 - 让PPTX生成变得简单优雅**

#### 核心理念

**人 = 数据（内容）**，**衣服 = 幻灯片类型**

同样的数据，只需要改变继承的类，就可以换不同的展示方式！

#### 特性

- **声明式设计**：用户只需要定义类，不需要调用任何东西
- **任意顺序**：类定义顺序无关，自由写作
- **多种类型**：17种幻灯片类型，满足各种展示需求
- **简单优雅**：完美体现CoffeeScript的独特特性

#### 快速开始

```coffee
{ Slide, ContentSlide, Section, Chapter, Presentation } = require "./declarative-pptx-api"

class 我的演示文稿 extends Presentation
    @sections: -> [第一章]
    @nowYou: @newPresentation()

class 第一章 extends Chapter
    @节: -> [第一节]

class 第一节 extends Section
    @幻灯片: -> [幻灯片1]

class 幻灯片1 extends ContentSlide
    @要点1: "这是第一个要点"
    @要点2: "这是第二个要点"
```

```bash
coffee self.coffee
```

#### 幻灯片类型

- **基础类型**：Slide, TitleSlide, ContentSlide, TwoColumnSlide, TableSlide, CardSlide
- **视觉类型**：ImageSlide, ImageTextSlide, QuoteSlide, NumberSlide
- **图表类型**：ProcessSlide, GanttSlide, TimelineSlide, ComparisonSlide, PyramidSlide, MindmapSlide, SWOTSlide

详见：[declarative-pptx-api/README.md](declarative-pptx-api/README.md)

## 🔬 实验内容

### Mermaid图表生成
- 支持流程图、时序图、类图、状态图
- 自动纵横交换（TD→LR）解决"高瘦离谱"问题
- CSS transform缩放提高图片质量

### PPTX生成
- 使用PptxGenJS生成PPTX
- 支持多种页面类型（封面、章节、列表、卡片、表格）
- 自动判断内容多少选择合适布局

### PDF/PPTX转换
- Puppeteer截图方案
- Mermaid CLI方案
- HTML to PDF方案

## 📝 使用方法

### 使用声明式PPTX API
```bash
cd ReviewerLab
coffee declarative-pptx-api/examples/E02品牌建设课程.coffee
```

### 查看实验内容
```bash
cd ReviewerLab
ls -la
```

### 运行实验代码
```bash
cd ReviewerLab/my-workspace/demo
coffee E02课程PPTX-完整版.coffee
```

## 📞 联系方式

如有问题或建议，请通过以下方式联系：
- 提交Issue
- 发送Pull Request

---

**最后更新**: 2026-03-04
