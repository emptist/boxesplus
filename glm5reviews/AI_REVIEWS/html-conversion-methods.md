# HTML到PDF/PPTX转换方案对比

## 方案对比

### 1. HTML → PDF

| 方案 | 工具/库 | 优点 | 缺点 | 推荐度 |
|------|---------|------|------|--------|
| **Puppeteer** | puppeteer | 渲染准确，支持现代CSS | 依赖Chrome，体积大 | ⭐⭐⭐⭐ |
| **wkhtmltopdf** | wkhtmltopdf | 命令行工具，轻量 | 渲染可能不准确 | ⭐⭐⭐ |
| **html-pdf** | html-pdf | 简单易用 | 基于PhantomJS（已停止维护） | ⭐⭐ |
| **pdf-lib** | pdf-lib | 纯JS，无外部依赖 | 需要手动渲染HTML | ⭐⭐ |
| **Playwright** | playwright | 类似Puppeteer，支持多浏览器 | 依赖浏览器 | ⭐⭐⭐⭐ |

### 2. HTML → PPTX

| 方案 | 工具/库 | 优点 | 缺点 | 推荐度 |
|------|---------|------|------|--------|
| **LibreOffice** | libreoffice --headless | 官方支持，质量高 | 需要安装LibreOffice | ⭐⭐⭐⭐⭐ |
| **Pandoc** | pandoc | 支持多种格式 | HTML→PPTX效果一般 | ⭐⭐⭐ |
| **officegen** | officegen | 纯JS，无外部依赖 | 功能有限 | ⭐⭐ |
| **PptxGenJS + 截图** | pptxgenjs + puppeteer | 效果好 | 需要截图 | ⭐⭐⭐ |

## 推荐方案

### 方案1：wkhtmltopdf + LibreOffice（轻量级）

```bash
# 安装
brew install wkhtmltopdf
brew install --cask libreoffice

# 使用
wkhtmltopdf input.html output.pdf
libreoffice --headless --convert-to pptx input.html
```

### 方案2：纯JS方案（无外部依赖）

```coffee
# HTML → PDF：使用pdf-lib（需要手动渲染）
# HTML → PPTX：使用LibreOffice（需要安装）
```

### 方案3：使用主项目的方法

主项目已经实现了：
- `reveal-to-pdf.coffee` - 使用Puppeteer
- `export-pdf.coffee` - 使用Puppeteer
- `dual-output.coffee` - 使用Puppeteer

## 结论

**对于BoxesPlus项目**：
- ✅ **推荐使用Puppeteer**：主项目已经在用，渲染效果最好
- ✅ **LibreOffice作为备选**：用于HTML→PPTX转换
- ⚠️ **wkhtmltopdf**：可以作为轻量级替代方案

**对于GLM5Reviews实践**：
- 可以尝试不同方案，积累经验
- 但最终应该与主项目保持一致

---

**创建日期**: 2026-03-02
