#!/usr/bin/env coffee

# C01课程图表 - 一次成型版
# 在生成时就控制好尺寸，避免后续调整

fs = require "fs"

# ============================================
# Mermaid图表定义（一次成型）
# ============================================

PDCA图 = """
flowchart LR
  P[PLAN<br/>计划]
  D[DO<br/>执行]
  C[CHECK<br/>检查]
  A[ACTION<br/>处理]
  P --> D
  D --> C
  C --> A
  A -->|持续改进| P
"""

体系图 = """
flowchart LR
  subgraph 顶层设计
    方针[方针]
    目标[目标]
    文化[文化]
  end
  subgraph 组织保障
    组织[组织]
    制度[制度]
    流程[流程]
  end
  subgraph 执行控制
    控制[控制]
    保证[保证]
    改进[改进]
  end
  方针 --> 组织
  目标 --> 制度
  文化 --> 流程
  组织 --> 控制
  制度 --> 保证
  流程 --> 改进
"""

闭环图 = """
flowchart TD
  报告[/"1.事件报告"/]
  调查["2.初步调查"]
  分析{"3.根本原因分析"}
  改进["4.改进措施"]
  评估["5.效果评估"]
  标准[/"6.标准化"/]
  报告 --> 调查
  调查 --> 分析
  分析 --> 改进
  改进 --> 评估
  评估 --> 标准
"""

危急值图 = """
sequenceDiagram
  participant 检验科 as 检验科
  participant 临床科室 as 临床科室
  participant 质控部门 as 质控部门
  
  检验科->>临床科室: 检测到危急值
  临床科室-->>检验科: 确认接收
  临床科室->>质控部门: 上报处理措施
  质控部门-->>临床科室: 审核确认
"""

组织架构图 = """
classDiagram
  class 质量委员会 {
    +主席
    +委员
    +制定方针()
    +审核目标()
  }
  class 质控部门 {
    +主任
    +质控员
    +日常监督()
    +数据分析()
  }
  class 科室质控组 {
    +组长
    +成员
    +科室自查()
    +问题整改()
  }
  class 全院职工 {
    +医师
    +护士
    +执行规范()
    +报告事件()
  }
  质量委员会 --> 质控部门
  质控部门 --> 科室质控组
  科室质控组 --> 全院职工
"""

风险管理图 = """
stateDiagram-v2
  [*] --> 正常
  正常 --> 风险评估: 定期评估
  风险评估 --> 高风险: 发现风险
  高风险 --> 干预措施: 启动干预
  干预措施 --> 安全: 风险消除
  安全 --> 正常: 恢复常态
  安全 --> [*]
"""

# ============================================
# 生成HTML（一次成型）
# ============================================

html = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>C01医疗质量与安全管理课程图表（一次成型版）</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      max-width: 1000px;
      margin: 0 auto;
      padding: 2em;
    }
    h1 {
      text-align: center;
      color: #2B579A;
    }
    h2 {
      color: #2B579A;
      border-bottom: 2px solid #2B579A;
      padding-bottom: 0.5em;
    }
    section {
      margin: 3em 0;
      padding: 2em;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      background: #ffffff;
    }
    .mermaid-container {
      text-align: center;
      margin: 2em 0;
      padding: 2em;
      background: #f9f9f9;
      border-radius: 8px;
      min-height: 400px;
      max-height: 800px;
      overflow: auto;
    }
    .mermaid {
      font-size: 14px;
      display: inline-block;
      width: 100%;
      max-width: 900px;
    }
    .mermaid svg {
      max-width: 100% !important;
      height: auto !important;
      max-height: 750px !important;
    }
  </style>
</head>
<body>
  <h1>C01医疗质量与安全管理课程图表（一次成型版）</h1>
  
  <section>
    <h2>PDCA循环</h2>
    <div class="mermaid-container">
      <div class="mermaid">
#{PDCA图}
      </div>
    </div>
  </section>
  
  <section>
    <h2>医疗质量管理体系</h2>
    <div class="mermaid-container">
      <div class="mermaid">
#{体系图}
      </div>
    </div>
  </section>
  
  <section>
    <h2>不良事件闭环管理</h2>
    <div class="mermaid-container">
      <div class="mermaid">
#{闭环图}
      </div>
    </div>
  </section>
  
  <section>
    <h2>危急值管理流程</h2>
    <div class="mermaid-container">
      <div class="mermaid">
#{危急值图}
      </div>
    </div>
  </section>
  
  <section>
    <h2>质量管理组织架构</h2>
    <div class="mermaid-container">
      <div class="mermaid">
#{组织架构图}
      </div>
    </div>
  </section>
  
  <section>
    <h2>患者安全风险管理</h2>
    <div class="mermaid-container">
      <div class="mermaid">
#{风险管理图}
      </div>
    </div>
  </section>
  
  <script>
    mermaid.initialize({
      startOnLoad: true,
      theme: 'default',
      securityLevel: 'loose',
      flowchart: {
        useMaxWidth: true,
        htmlLabels: true,
        curve: 'basis'
      },
      sequence: {
        useMaxWidth: true,
        diagramMarginX: 10,
        diagramMarginY: 10
      },
      class: {
        useMaxWidth: true
      },
      state: {
        useMaxWidth: true
      }
    });
  </script>
</body>
</html>
"""

fs.writeFileSync "../output/C01课程图表-一次成型版.html", html, "utf-8"
console.log "✅ 一次成型版生成完成"
console.log "   文件: C01课程图表-一次成型版.html"
console.log "   共 6 个图表"
console.log "\n一次成型策略："
console.log "  • 使用LR布局（左右），避免过高"
console.log "  • CSS限制最大宽度900px，最大高度750px"
console.log "  • Mermaid配置useMaxWidth: true"
console.log "  • 字体大小14px，适中清晰"
console.log "  • 容器max-height: 800px，超出可滚动"
