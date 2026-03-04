# GLM5 Reviews - 项目规则

## 📋 项目概述

本项目是**reviewer AI的工作空间**，专注于PPTX和RevealJS演示文稿的自动生成。

## ⚠️ 重要说明

### 身份和位置

- **当前工作目录**：`/Users/jk/gits/hub/consult_strategy/boxesplus/glm5reviews`
- **身份**：reviewer AI助手
- **工作空间**：`glm5reviews`（用于review和探索）
- **真正的项目**：`/Users/jk/gits/hub/consult_strategy/boxesplus`

### 项目关系

```
boxesplus/                    # 真正的项目
├── api/                      # 项目核心代码
├── Demo/                      # 项目示例代码
├── glm5reviews/              # reviewer AI工作空间（本目录）
│   ├── .trae/
│   │   └── rules/
│   │       └── project_rules.md
│   ├── AI_REVIEWS/           # 📋 报告目录
│   │   └── boxesplus-comprehensive-review.md
│   ├── ReviewerLab/              # 🔬 ReviewerLab目录
│   │   ├── my-workspace/      # 之前的my-workspace
│   │   ├── reviewer-workspace/ # 之前的reviewer-workspace
│   │   └── src/             # 之前的src
│   ├── README.md
│   └── project_rules.md
├── md_sources/
├── resources/
└── scripts/
```

### 注意事项

1. **glm5reviews是工作空间**：不是真正的项目，是reviewer AI用于review和探索的目录
2. **真正的项目在上级目录**：`/Users/jk/gits/hub/consult_strategy/boxesplus`
3. **review报告针对真正的项目**：review报告中的代码路径应该指向`boxesplus`项目
4. **不要混淆工作空间和项目**：工作空间是为了review和探索，项目是真正的代码库
5. **review报告存放位置**：`AI_REVIEWS/` 目录，所有review报告都应该放在这里
6. **review报告命名规范**：使用描述性的文件名，如`boxesplus-comprehensive-review.md`

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
├── src/                          # 源代码
│   ├── code/                     # 核心代码
│   │   ├── markdown转换器.coffee    # Markdown到CSON转换器
│   │   ├── boxesplus.coffee         # 统一API入口
│   │   ├── 中文表达.coffee           # 中文API
│   │   ├── 双侧编程.coffee           # 双侧编程实现
│   │   ├── 真正的诗式PPTX.coffee    # 诗式API
│   │   ├── 散文式PPTX.coffee        # 散文式API
│   │   ├── 极简诗式PPTX.coffee      # 极简诗式API
│   │   ├── JSON定义解析.coffee       # JSON解析器
│   │   ├── 自然语言表达.coffee       # 自然语言解析
│   │   ├── csv-to-json.coffee        # CSV到JSON转换
│   │   ├── json-to-pptx.coffee       # JSON到PPTX转换
│   │   └── revealjs生成器.coffee      # RevealJS生成器
│   └── examples/                  # 示例代码
│       ├── 生成C01课程.coffee        # C01课程生成脚本
│       ├── 双侧编程-数据驱动.coffee   # 双侧编程示例
│       └── ...
├── reviewer-workspace/            # 审查工作区
│   ├── data/                    # 数据文件（JSON格式）
│   └── data2/                   # 数据文件（CSON格式）
│       ├── A01医院管理总览课程.coffee
│       ├── C01医疗质量与安全管理课程.coffee
│       └── ...
├── notes/                        # 笔记和教案
│   ├── C01医疗质量与安全管理课程详细教案.md
│   └── ...
├── output/                       # 输出文件
│   ├── *.pptx                    # 生成的PPTX文件
│   ├── *.html                    # 生成的HTML文件
│   └── *.pdf                    # 生成的PDF文件
└── .gitignore                    # Git忽略规则
```

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

## 📝 使用方法

### 1. Markdown到CSON转换

```bash
cd src/code
coffee markdown转换器.coffee \
  "/path/to/教案.md" \
  "/path/to/输出.coffee"
```

### 2. CSON到PPTX生成

```bash
cd src/examples
coffee 生成C01课程.coffee
```

### 3. 直接使用API

```coffee
# 引入API
{演示文稿, 幻灯片} = require "../code/boxesplus.coffee"

# 创建演示文稿
演示 = 演示文稿.开始 "课程标题"

# 添加幻灯片
演示.添加
  类型: "封面页"
  标题: "课程标题"
  副标题: "副标题"

# 保存
演示.保存 "output/课程.pptx"
```

## 🔧 技术栈

- **CoffeeScript**: 主要开发语言
- **PptxGenJS**: PPTX生成库
- **RevealJS**: HTML演示框架
- **Node.js**: 运行环境

## 📝 开发规范

1. **代码风格**: 使用CoffeeScript，中文变量名
2. **注释**: 代码中不添加注释
3. **提交**: 重要更改后及时提交代码
4. **文档**: 完成任务后更新文档

## 📌 最近更新（2026-03-01）

### 已完成
- ✅ 优化卡片页实现（固定高度和字体）
- ✅ 添加自动判断规则（超过5行或单行超过50字）
- ✅ 改进Markdown转换器
- ✅ 成功转换C01课程（37页PPTX）
- ✅ 修复.gitignore（移除.coffee排除规则）
- ✅ 探索Mermaid图表集成

### 关键发现
1. **卡片页应该固定布局**：参考"双侧编程-数据驱动.pptx"的实现
2. **内容多时用表格页**：表格可以自动调整行高，不会溢出
3. **简单规则最有效**：超过5行或单行超过50字就表格页
4. **务实的态度**：内容多时表格页保证完整显示即可，不追求美观

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

---

**最后更新**: 2026-03-01
