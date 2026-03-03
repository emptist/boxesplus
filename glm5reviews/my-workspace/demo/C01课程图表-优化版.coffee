#!/usr/bin/env coffee

# C01课程图表 - 优化版
# 解决"高瘦离谱"的问题

fs = require "fs"

# ============================================
# 优化策略
# ============================================

# 图表3: 不良事件闭环管理（6个节点，TD布局→高瘦）
# 优化：改为LR布局，或者拆分为2个小图

闭环图_优化版 = """
flowchart LR
  报告[/"1.事件报告"/]
  调查["2.初步调查"]
  分析{"3.根本原因分析"}
  改进["4.改进措施"]
  评估["5.效果评估"]
  标准[/"6.标准化"/]
  报告 --> 调查 --> 分析 --> 改进 --> 评估 --> 标准
"""

# 图表5: 质量管理组织架构（classDiagram，4个类）
# 优化：改为flowchart LR，更简洁

组织架构图_优化版 = """
flowchart LR
  委员会[质量委员会<br/>主席、委员<br/>制定方针、审核目标]
  质控[质控部门<br/>主任、质控员<br/>日常监督、数据分析]
  科室[科室质控组<br/>组长、成员<br/>科室自查、问题整改]
  职工[全院职工<br/>医师、护士<br/>执行规范、报告事件]
  委员会 --> 质控 --> 科室 --> 职工
"""

# 图表6: 患者安全风险管理（stateDiagram-v2，5个状态）
# 优化：改为flowchart LR，更直观

风险管理图_优化版 = """
flowchart LR
  正常[正常状态]
  评估[风险评估]
  高风险[高风险]
  干预[干预措施]
  安全[安全状态]
  正常 -->|定期评估| 评估 -->|发现风险| 高风险 -->|启动干预| 干预 -->|风险消除| 安全 -->|恢复常态| 正常
"""

# ============================================
# 其他图表（保持不变）
# ============================================

PDCA图 = """
flowchart LR
  P[PLAN<br/>计划]
  D[DO<br/>执行]
  C[CHECK<br/>检查]
  A[ACTION<br/>处理]
  P --> D --> C --> A -->|持续改进| P
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

# ============================================
# 生成HTML
# ============================================

html = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>C01医疗质量与安全管理课程图表（优化版）</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      max-width: 1200px;
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
    }
    .mermaid {
      font-size: 14px;
      display: inline-block;
      width: 100%;
    }
    .mermaid svg {
      max-width: 100% !important;
      height: auto !important;
    }
  </style>
</head>
<body>
  <h1>C01医疗质量与安全管理课程图表（优化版）</h1>
  
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
#{闭环图_优化版}
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
#{组织架构图_优化版}
      </div>
    </div>
  </section>
  
  <section>
    <h2>患者安全风险管理</h2>
    <div class="mermaid-container">
      <div class="mermaid">
#{风险管理图_优化版}
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
      }
    });
  </script>
</body>
</html>
"""

fs.writeFileSync "../output/C01课程图表-优化版.html", html, "utf-8"
console.log "✅ 优化版生成完成"
console.log "   文件: C01课程图表-优化版.html"
console.log "   共 6 个图表"
console.log "\n优化策略："
console.log "  • 所有flowchart使用LR布局（左右）"
console.log "  • classDiagram改为flowchart LR（更简洁）"
console.log "  • stateDiagram改为flowchart LR（更直观）"
console.log "  • 简化节点文本，减少换行"
console.log "  • 避免高瘦离谱的图表"
