#!/usr/bin/env coffee

# 对角线布局技巧演示
# 将"高瘦"的流程图改为"宽而矮"的对角线布局

fs = require "fs"

# ============================================
# 示例：8个连续步骤的流程图
# ============================================

# 原始版本（高瘦离谱）
原始版本 = """
flowchart TD
  步骤1[步骤1]
  步骤2[步骤2]
  步骤3[步骤3]
  步骤4[步骤4]
  步骤5[步骤5]
  步骤6[步骤6]
  步骤7[步骤7]
  步骤8[步骤8]
  步骤1 --> 步骤2 --> 步骤3 --> 步骤4
  步骤4 --> 步骤5 --> 步骤6 --> 步骤7 --> 步骤8
"""

# 优化版本1：对角线布局（宽而矮）
对角线版本 = """
flowchart LR
  步骤1[步骤1] --> 步骤2[步骤2] --> 步骤3[步骤3] --> 步骤4[步骤4]
  步骤1 --> 步骤5[步骤5] --> 步骤6[步骤6] --> 步骤7[步骤7] --> 步骤8[步骤8]
  步骤2 --> 步骤6
  步骤3 --> 步骤7
  步骤4 --> 步骤8
"""

# 优化版本2：蛇形布局（更紧凑）
蛇形版本 = """
flowchart LR
  步骤1[步骤1] --> 步骤2[步骤2] --> 步骤3[步骤3] --> 步骤4[步骤4]
  步骤4 -->|继续| 步骤5[步骤5] --> 步骤6[步骤6] --> 步骤7[步骤7] --> 步骤8[步骤8]
"""

# 优化版本3：分层布局（使用subgraph）
分层版本 = """
flowchart LR
  subgraph 第一阶段
    步骤1[步骤1] --> 步骤2[步骤2]
  end
  subgraph 第二阶段
    步骤3[步骤3] --> 步骤4[步骤4]
  end
  subgraph 第三阶段
    步骤5[步骤5] --> 步骤6[步骤6]
  end
  subgraph 第四阶段
    步骤7[步骤7] --> 步骤8[步骤8]
  end
  第一阶段 --> 第二阶段 --> 第三阶段 --> 第四阶段
"""

# ============================================
# 实际应用：优化C01课程的图表
# ============================================

# 图表3：不良事件闭环管理（6个步骤）
闭环图_对角线 = """
flowchart LR
  报告[/"1.事件报告"/] --> 调查["2.初步调查"]
  调查 --> 分析{"3.根本原因分析"}
  分析 --> 改进["4.改进措施"]
  改进 --> 评估["5.效果评估"]
  评估 --> 标准[/"6.标准化"/]
  
  报告 -.->|循环| 标准
"""

# 图表5：质量管理组织架构（4个层级）
组织架构_对角线 = """
flowchart LR
  委员会[质量委员会] --> 质控[质控部门]
  委员会 -.->|指导| 科室[科室质控组]
  质控 --> 科室 --> 职工[全院职工]
  
  委员会 -.->|监督| 职工
"""

# ============================================
# 生成HTML
# ============================================

html = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>对角线布局技巧演示</title>
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
    .技巧说明 {
      background: #fff3cd;
      border-left: 4px solid #ffc107;
      padding: 1em;
      margin: 1em 0;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <h1>对角线布局技巧演示</h1>
  
  <section>
    <h2>示例：8个连续步骤</h2>
    <div class="技巧说明">
      <strong>技巧说明：</strong>将连续垂直的流程改为对角线或蛇形布局，避免"高瘦离谱"
    </div>
    
    <h3>原始版本（高瘦离谱）</h3>
    <div class="mermaid-container">
      <div class="mermaid">
#{原始版本}
      </div>
    </div>
    
    <h3>优化版本1：对角线布局（宽而矮）</h3>
    <div class="mermaid-container">
      <div class="mermaid">
#{对角线版本}
      </div>
    </div>
    
    <h3>优化版本2：蛇形布局（紧凑）</h3>
    <div class="mermaid-container">
      <div class="mermaid">
#{蛇形版本}
      </div>
    </div>
    
    <h3>优化版本3：分层布局（清晰）</h3>
    <div class="mermaid-container">
      <div class="mermaid">
#{分层版本}
      </div>
    </div>
  </section>
  
  <section>
    <h2>实际应用：C01课程图表优化</h2>
    
    <h3>不良事件闭环管理（对角线布局）</h3>
    <div class="mermaid-container">
      <div class="mermaid">
#{闭环图_对角线}
      </div>
    </div>
    
    <h3>质量管理组织架构（对角线布局）</h3>
    <div class="mermaid-container">
      <div class="mermaid">
#{组织架构_对角线}
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

fs.writeFileSync "../output/对角线布局技巧演示.html", html, "utf-8"
console.log "✅ 对角线布局技巧演示生成完成"
console.log "   文件: 对角线布局技巧演示.html"
console.log "\n技巧总结："
console.log "  • 对角线布局：将连续垂直改为对角线"
console.log "  • 蛇形布局：第一行从左到右，第二行从右到左"
console.log "  • 分层布局：使用subgraph组织内容"
console.log "  • 虚线连接：表示辅助关系，避免混乱"
console.log "  • 目标：将'高瘦'改为'宽而矮'"
