# BoxesPlus - ASCII → Mermaid → Reveal.js/PPTX

PptxGenJS = require "pptxgenjs"
fs = require "fs"
path = require "path"

pres = new PptxGenJS()

# ============ 封面 ============
slide0 = pres.addSlide()
slide0.background = { type: "solid", color: "1a365d" }
slide0.addText "ASCII → Mermaid 演示",
  x: 0.5, y: 2, w: 9, h: 1.5
  fontSize: 44, color: "ffffff", bold: true, align: "center"
slide0.addText "用 Mermaid 重现 ASCII 图表",
  x: 1, y: 4, w: 8, h: 0.8
  fontSize: 20, color: "ffffff", align: "center", transparency: 20

# ============ 1. 流程图: 不良事件闭环 ============
# ASCII source:
# ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
# │ 事件报告│───→│原因分析│───→│整改措施│───→│效果评价│
# └─────────┘    └─────────┘    └─────────┘    └─────────┘
#      ↑                                                 │
#      └─────────────────────────────────────────────────┘

slide1 = pres.addSlide()
slide1.addText "1. 流程图 - 不良事件闭环", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true

mermaidCode1 = """
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评价]
    D -->|持续改进| A
"""

slide1.addText mermaidCode1,
  x: 0.5, y: 1, w: 5, h: 3
  fontSize: 10, fontFace: "Courier New", color: "333333"

# ============ 2. 层级架构图 ============
# ASCII source:
# ┌─────────────────────────────────────────┐
# │         医疗质量管理体系架构             │
# ├─────────────────────────────────────────┤
# │         ┌─────────────────┐            │
# │         │   质量方针      │            │
# │         │   质量目标      │            │
# │         │   质量文化      │            │
# │         └────────┬────────┘            │
# │                  │                      │
# │         ┌────────┴────────┐            │
# │         │   质量组织      │            │
# ...

slide2 = pres.addSlide()
slide2.addText "2. 层级架构图 - 质量管理体系", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true

mermaidCode2 = """
flowchart TB
    subgraph 方针目标
        A1[质量方针]:::blue
        A2[质量目标]:::blue
        A3[质量文化]:::blue
    end
    
    subgraph 组织制度
        B1[质量组织]:::green
        B2[质量制度]:::green
        B3[质量流程]:::green
    end
    
    subgraph 管控改进
        C1[质量控制]:::orange
        C2[质量保证]:::orange
        C3[质量改进]:::orange
    end
    
    A1 & A2 & A3 --> B1 & B2 & B3
    B1 & B2 & B3 --> C1 & C2 & C3
    
    classDef blue fill:#e6f3ff,stroke:#3182ce
    classDef green fill:#e6ffed,stroke:#38a169
    classDef orange fill:#fffaf0,stroke:#d69e2e
"""

slide2.addText mermaidCode2,
  x: 0.5, y: 1, w: 5, h: 4
  fontSize: 10, fontFace: "Courier New", color: "333333"

# ============ 3. PDCA 循环 ============
# ASCII source:
#          ┌─────────┐
#          │   P    │ 计划
#          └────┬────┘
#               │
#     ┌────────┴────────┐
#     │                 │
# ┌──┴──┐         ┌──┴──┐
# │  C  │         │  D  │
# │检查  │         │ 执行 │
# └──┬──┘         └──┬──┘
#    │                 │
#    └────────┬────────┘
#             │
#          ┌──┴──┐
#          │  A  │
#          │ 处理 │
#          └─────┘

slide3 = pres.addSlide()
slide3.addText "3. PDCA 循环", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true

mermaidCode3 = """
flowchart TB
    P[PLAN<br/>计划]:::plan --> D
    D[DO<br/>执行]:::do --> C
    C[CHECK<br/>检查]:::check --> A
    A[ACTION<br/>处理]:::action -->|持续改进| P
    
    linkStyle 0,1,2,3 stroke:#3182ce,stroke-width:2px
    classDef plan fill:#3182ce,color:#fff
    classDef do fill:#38a169,color:#fff
    classDef check fill:#d69e2e,color:#fff
    classDef action fill:#e53e3e,color:#fff
"""

slide3.addText mermaidCode3,
  x: 0.5, y: 1, w: 5, h: 3.5
  fontSize: 10, fontFace: "Courier New", color: "333333"

# ============ 4. 组织架构 ============
# ASCII from D01:
#     A[院长] --> B[副院长1]
#     A --> C[副院长2]
#     B --> D[质控部]
#     B --> E[医务部]
#     C --> F[护理部]
#     C --> G[科研教学]

slide4 = pres.addSlide()
slide4.addText "4. 组织架构图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true

mermaidCode4 = """
flowchart TB
    院长 --> 副院长1
    院长 --> 副院长2
    副院长1 --> 质控部
    副院长1 --> 医务部
    副院长2 --> 护理部
    副院长2 --> 科研教学
    质控部 --> 质控科
    质控部 --> 安全科
"""

slide4.addText mermaidCode4,
  x: 0.5, y: 1, w: 5, h: 4
  fontSize: 10, fontFace: "Courier New", color: "333333"

# ============ 5. 数据流程 ============
# ASCII from F05:
# ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐
# │采集 │→ │存储 │→ │处理 │→ │分析 │→ │应用 │
# └─────┘   └─────┘   └─────┘   └─────┘   └─────┘

slide5 = pres.addSlide()
slide5.addText "5. 数据生命周期", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true

mermaidCode5 = """
flowchart LR
    A[采集] --> B[存储]
    B --> C[处理]
    C --> D[分析]
    D --> E[应用]
    
    style A fill:#e6f3ff,stroke:#3182ce
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#fffaf0,stroke:#d69e2e
    style D fill:#faf5ff,stroke:#805ad5
    style E fill:#ffe3e3,stroke:#e53e3e
"""

slide5.addText mermaidCode5,
  x: 0.5, y: 1, w: 5, h: 3
  fontSize: 10, fontFace: "Courier New", color: "333333"

# ============ 6. 品牌金字塔 ============
# ASCII from E02:
#            ┌─────────┐
#            │  文化   │  ← 精神层
#            │  品牌   │
#            └────┬────┘
#                 │
#       ┌─────────┴─────────┐
#       │                   │
# ┌─────┴─────┐     ┌──────┴──────┐
# │   服务    │     │   技术     │  ← 物质层
# │   品牌    │     │   品牌    │
# └───────────┘     └────────────┘

slide6 = pres.addSlide()
slide6.addText "6. 品牌金字塔", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true

mermaidCode6 = """
flowchart TB
    subgraph 精神层
        A[文化品牌]
    end
    
    subgraph 物质层
        B[服务品牌]
        C[技术品牌]
    end
    
    subgraph 符号层
        D[标识品牌]
    end
    
    A --> B
    A --> C
    B --> D
    C --> D
    
    style A fill:#faf5ff,stroke:#805ad5,stroke-width:2px
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#e6f3ff,stroke:#3182ce
    style D fill:#fffaf0,stroke:#d69e2e
"""

slide6.addText mermaidCode6,
  x: 0.5, y: 1, w: 5, h: 4
  fontSize: 10, fontFace: "Courier New", color: "333333"

# ============ 保存 PPTX ============
pres.writeFile({ fileName: "outputs/ascii-to-mermaid.pptx" })
  .then -> console.log "✅ Created: outputs/ascii-to-mermaid.pptx"
  .catch (err) -> console.error err

# ============ 同时生成 Reveal.js HTML ============
htmlContent = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>ASCII → Mermaid 演示</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
</head>
<body>
    <div class="reveal">
        <div class="slides">
            <section data-background-color="#1a365d">
                <h1 style="color:#fff">ASCII → Mermaid 演示</h1>
                <p style="color:#fff;opacity:0.8">用 Mermaid 重现 ASCII 图表</p>
            </section>
            
            <section>
                <h3>1. 流程图 - 不良事件闭环</h3>
                <div class="mermaid">
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评价]
    D -->|持续改进| A
                </div>
            </section>
            
            <section>
                <h3>2. 层级架构图 - 质量管理体系</h3>
                <div class="mermaid">
flowchart TB
    subgraph 方针目标
        A1[质量方针]
        A2[质量目标]
        A3[质量文化]
    end
    subgraph 组织制度
        B1[质量组织]
        B2[质量制度]
        B3[质量流程]
    end
    subgraph 管控改进
        C1[质量控制]
        C2[质量保证]
        C3[质量改进]
    end
    A1 & A2 & A3 --> B1 & B2 & B3
    B1 & B2 & B3 --> C1 & C2 & C3
                </div>
            </section>
            
            <section>
                <h3>3. PDCA 循环</h3>
                <div class="mermaid">
flowchart TB
    P[PLAN<br/>计划] --> D
    D[DO<br/>执行] --> C
    C[CHECK<br/>检查] --> A
    A[ACTION<br/>处理] -->|持续改进| P
    style P fill:#3182ce,color:#fff
    style D fill:#38a169,color:#fff
    style C fill:#d69e2e,color:#fff
    style A fill:#e53e3e,color:#fff
                </div>
            </section>
            
            <section>
                <h3>4. 组织架构图</h3>
                <div class="mermaid">
flowchart TB
    院长 --> 副院长1
    院长 --> 副院长2
    副院长1 --> 质控部
    副院长1 --> 医务部
    副院长2 --> 护理部
    副院长2 --> 科研教学
    质控部 --> 质控科
    质控部 --> 安全科
                </div>
            </section>
            
            <section>
                <h3>5. 数据生命周期</h3>
                <div class="mermaid">
flowchart LR
    A[采集] --> B[存储] --> C[处理] --> D[分析] --> E[应用]
    style A fill:#e6f3ff,stroke:#3182ce
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#fffaf0,stroke:#d69e2e
    style D fill:#faf5ff,stroke:#805ad5
    style E fill:#ffe3e3,stroke:#e53e3e
                </div>
            </section>
            
            <section>
                <h3>6. 品牌金字塔</h3>
                <div class="mermaid">
flowchart TB
    A[文化品牌] --> B[服务品牌]
    A --> C[技术品牌]
    B & C --> D[标识品牌]
    style A fill:#faf5ff,stroke:#805ad5,stroke-width:2px
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#e6f3ff,stroke:#3182ce
    style D fill:#fffaf0,stroke:#d69e2e
                </div>
            </section>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
    <script>
        mermaid.initialize({ startOnLoad: true });
        Reveal.initialize();
    </script>
</body>
</html>
"""

fs.writeFileSync "outputs/ascii-to-mermaid.html", htmlContent
console.log "✅ Created: outputs/ascii-to-mermaid.html"
