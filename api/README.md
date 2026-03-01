# BoxesPlus API

## 推荐用法

使用 `api/elegant.coffee` - 极简诗式 API：

```coffee
{ generateHtml } = require "./api/elegant"

课程 = 
  title: "标题"
  slides: [
    { type: "title", title: "封面" }
    { type: "cards", title: "目标", cards: [...] }
    { type: "pdca" }
    { type: "swot", strengths: [...], weaknesses: [...] }
    { type: "end" }
  ]

generateHtml 课程, "output.html"
```

详细文档见根目录 `README.md`

## 核心文件

| 文件 | 用途 |
|------|------|
| `api/elegant.coffee` | 主 API |
| `api/serve.coffee` | 本地服务器 |
| `api/reveal-to-pdf.coffee` | HTML → PDF |

## 快速运行

```bash
cd boxesplus
coffee api/elegant.coffee
```
