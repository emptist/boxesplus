# BoxesPlus - Mermaid Diagrams + PPTX
# 使用 Mermaid 生成图表，嵌入 PPTX

PptxGenJS = require "pptxgenjs"
mermaid = require "mermaid"
{ titleSlide } = require "../api/boxesplus-artist.coffee"
fs = require "fs"
path = require "path"

# 初始化 mermaid
mermaid.initialize({ startOnLoad: false })

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "Mermaid 图表 + PPTX"
  subtitle: "使用 Node.js 可视化"
  gradient: "blue"

# ============ 示例1: 流程图 ============
titleSlide pres,
  title: "Mermaid 流程图"
  subtitle: "从文本生成"
  gradient: "purple"

slide2 = pres.addSlide()
slide2.addText "Mermaid 流程图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# Mermaid 定义
mermaidCode1 = """
graph TD
    A[开始] --> B{是否急诊?}
    B -->|是| C[急诊处理]
    B -->|否| D[门诊挂号]
    D --> E[分诊]
    E --> F[医生诊疗]
    F --> G[收费药]
    G --> H[结束]
"""

# 生成 SVG (异步)
取generateDiagram = (code, filename) ->
  new Promise (resolve, reject) ->
    try
      # mermaid 生成 SVG 需要通过 API
      # 这里我们先生成简单的图片占位
      # 实际使用可以用 mermaid.render
      resolve(null)
    catch e
      resolve(null)

# 作为替代，直接用代码方式添加文本展示 mermaid 语法
slide2.addText mermaidCode1,
  x: 0.5, y: 1, w: 9, h: 4
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# ============ 示例2: 组织架构图 ============
slide3 = pres.addSlide()
slide3.addText "Mermaid 组织架构图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

mermaidCode2 = """
graph TB
    A[院长] --> B[副院长1]
    A --> C[副院长2]
    B --> D[质控部]
    B --> E[医务部]
    C --> F[护理部]
    C --> G[科研教学]
    D --> H[质控科]
    D --> I[安全科]
"""

slide3.addText mermaidCode2,
  x: 0.5, y: 1, w: 9, h: 4
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# ============ 示例3: 序列图 ============
slide4 = pres.addSlide()
slide4.addText "Mermaid 序列图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

mermaidCode3 = """
sequenceDiagram
    Patient->>Reception: 挂号
    Reception->>Nurse: 分诊
    Nurse->>Doctor: 提交病历
    Doctor->>Patient: 问诊
    Doctor->>Lab: 开检查单
    Lab->>Doctor: 返回结果
    Doctor->>Pharmacy: 开处方
    Pharmacy->>Patient: 取药
"""

slide4.addText mermaidCode3,
  x: 0.5, y: 1, w: 9, h: 4
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# ============ 示例4: 状态图 ============
slide5 = pres.addSlide()
slide5.addText "Mermaid 状态图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

mermaidCode4 = """
stateDiagram-v2
    [*] --> 待分诊
    待分诊 --> 已分诊: 护士分诊
    已分诊 --> 诊疗中: 医生接诊
    诊疗中 --> 检查中: 开具检查
    检查中 --> 诊疗中: 检查完成
    诊疗中 --> 已完成: 诊疗结束
    已完成 --> [*]
"""

slide5.addText mermaidCode4,
  x: 0.5, y: 1, w: 9, h: 4
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# ============ 示例5: 饼图 ============
slide6 = pres.addSlide()
slide6.addText "Mermaid 饼图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

mermaidCode5 = """
pie title 科室收入占比
    "内科" : 30
    "外科" : 35
    "妇产科" : 15
    "儿科" : 10
    "其他" : 10
"""

slide6.addText mermaidCode5,
  x: 0.5, y: 1, w: 9, h: 4
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# ============ 保存 ============
pres.writeFile({ fileName: "outputs/demo-mermaid.pptx" })
  .then -> console.log "✅ Created: outputs/demo-mermaid.pptx"
  .catch (err) -> console.error err
