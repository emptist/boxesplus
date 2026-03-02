# BoxesPlus - Mermaid 幻灯片 API

> 生成 Mermaid 图表驱动的演示文稿

## 安装

```bash
cd boxesplus
npm install
```

## 快速开始

```coffee
{ generateHtml, CHARTS } = require "./api/mermaid-slides.coffee"

课程 =
  title: "课程标题"
  slides: [
    { type: "title", title: "封面" }
    { type: "mermaid", title: "图表", content: CHARTS.pdca, scale: "1.0" }
  ]

generateHtml 课程, "output.html"
```

然后用 puppeteer 导出 PDF。

## 图表模板

```coffee
CHARTS.pdca           # PDCA循环
CHARTS.pareto         # 饼图
CHARTS.qualitySystem  # 质量管理体系
CHARTS.eventLoop      # 事件闭环
CHARTS.dataLifecycle  # 数据生命周期
CHARTS.brandPyramid  # 品牌金字塔
```

## 缩放

```coffee
{ scale: "0.9" }  # 缩小10%
{ scale: "1.0" }  # 默认
{ scale: "1.2" }  # 放大20%
```

## 核心技巧

### 纵横交换
- 用 `flowchart LR` 代替 `flowchart TD`
- 避免高瘦图表

### 节点命名
- 使用中文全名，避免 `A1`, `B2` 等缩写
- Mermaid 8.14 在 PDF 渲染时可能显示缩写
