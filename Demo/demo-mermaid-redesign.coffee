# BoxesPlus - 用 Mermaid 重设计 ASCII 图表

fs = require "fs"

# ============ 生成 Reveal.js HTML ============
htmlContent = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>用 Mermaid 重新设计 ASCII 图表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
    <style>
        .reveal .slides section { font-size: 28px; }
        .reveal .slides h3 { color: #1a365d; }
    </style>
</head>
<body>
    <div class="reveal">
        <div class="slides">
            <!-- 封面 -->
            <section data-background-gradient="linear-gradient(135deg, #1a365d, #2c5282)">
                <h1 style="color:#fff">用 Mermaid 重新设计</h1>
                <p style="color:#fff;opacity:0.9">表达含义，而不是重现线条</p>
                <p style="color:#fff;opacity:0.7;font-size:24px">医疗质量管理与安全课程</p>
            </section>
            
            <!-- 1. 质量管理体系 - 用 subgraph 层级展示 -->
            <section>
                <h3>1. 医疗质量管理体系</h3>
                <div class="mermaid">
flowchart TB
    subgraph TOP [顶层设计]
        direction LR
        T1(质量方针) --> T2(质量目标) --> T3(质量文化)
    end
    
    subgraph MID [组织支撑]
        direction LR
        M1(质量组织) --> M2(质量制度) --> M3(质量流程)
    end
    
    subgraph BOT [执行管控]
        direction LR
        B1(质量控制) --> B2(质量保证) --> B3(质量改进)
    end
    
    TOP --> MID --> BOT
    
    classDef top fill:#e6f3ff,stroke:#3182ce,stroke-width:2px,rx:8,ry:8
    classDef mid fill:#e6ffed,stroke:#38a169,stroke-width:2px,rx:8,ry:8
    classDef bot fill:#fffaf0,stroke:#d69e2e,stroke-width:2px,rx:8,ry:8
    classDef top,MID,BOT container
                </div>
            </section>
            
            <!-- 2. PDCA 循环 - 用圆形节点 -->
            <section>
                <h3>2. PDCA 持续改进循环</h3>
                <div class="mermaid">
flowchart TB
    P(计划<br/>Plan) --> D(执行<br/>Do)
    D --> C(检查<br/>Check)
    C --> A(处理<br/>Action)
    A -.->|持续改进| P
    
    P2[分析现状<br/>识别问题<br/>制定计划]:::detail
    D2[落实措施<br/>执行方案<br/>记录过程]:::detail
    C2[检查效果<br/>对比目标<br/>发现问题]:::detail
    A2[总结经验<br/>标准化<br/>遗留问题入下轮]:::detail
    
    P --> P2
    D --> D2
    C --> C2
    A --> A2
    
    style P fill:#3182ce,color:#fff,stroke:none,rx:40,ry:40
    style D fill:#38a169,color:#fff,stroke:none,rx:40,ry:40
    style C fill:#d69e2e,color:#fff,stroke:none,rx:40,ry:40
    style A fill:#e53e3e,color:#fff,stroke:none,rx:40,ry:40
    style P2 fill:#f7fafc,stroke:#ccc,stroke-dasharray:4
    style D2 fill:#f7fafc,stroke:#ccc,stroke-dasharray:4
    style C2 fill:#f7fafc,stroke:#ccc,stroke-dasharray:4
    style A2 fill:#f7fafc,stroke:#ccc,stroke-dasharray:4
    linkStyle default stroke:#1a365d,stroke-width:2px
                </div>
            </section>
            
            <!-- 3. 不良事件闭环 - 用更清晰的流程 -->
            <section>
                <h3>3. 不良事件闭环管理</h3>
                <div class="mermaid">
flowchart LR
    A([📋 事件报告]) --> B([🔍 原因分析])
    B --> C([🔧 整改措施])
    C --> D([📊 效果评估])
    D -->|闭环| A
    
    A1(逐级上报) -.-> A
    B1(RCA分析) -.-> B
    B1 --> B2(根因识别)
    C1(责任落实) -.-> C
    C1 --> C2(制度完善)
    D1(持续监测) -.-> D
    
    style A fill:#ebf8ff,stroke:#3182ce,stroke-width:2
    style B fill:#faf5ff,stroke:#805ad5,stroke-width:2
    style C fill:#f0fff4,stroke:#38a169,stroke-width:2
    style D fill:#fffaf0,stroke:#d69e2e,stroke-width:2
                </div>
            </section>
            
            <!-- 4. 组织架构 - 用更好的布局 -->
            <section>
                <h3>4. 质量管理组织架构</h3>
                <div class="mermaid">
flowchart TB
    subgraph 决策层
        质量管理委员会
    end
    
    subgraph 管理层
        direction LR
        质控部 --> 医务部 --> 护理部 --> 科研教学
    end
    
    subgraph 执行层
        direction LR
        科室1 & 科室2 & 科室3 & 科室4
    end
    
    质量管理委员会 --> 质控部
    质控部 --> 科室1
    质控部 --> 科室2
    医务部 --> 科室3
    护理部 --> 科室4
    
    style 质量管理委员会 fill:#1a365d,color:#fff,stroke:none,rx:8
    style 质控部,医务部,护理部,科研教学 fill:#2c5282,color:#fff,stroke:none,rx:6
    style 科室1,科室2,科室3,科室4 fill:#3182ce,color:#fff,stroke:none,rx:6
                </div>
            </section>
            
            <!-- 5. 数据生命周期 - 用渐变效果 -->
            <section>
                <h3>5. 数据资产生命周期</h3>
                <div class="mermaid">
flowchart LR
    A[📥 采集] --> B[💾 存储] --> C[⚙️ 处理] --> D[📈 分析] --> E[🚀 应用]
    
    A1(源头获取) -.-> A
    B1(数据湖) -.-> B
    B1 --> B2(数据仓库)
    C1(清洗转换) -.-> C
    D1(可视化) -.-> D
    D1 --> D2(BI报表)
    E1(决策支持) -.-> E
    E1 --> E2(业务应用)
    
    style A fill:#e6f3ff,stroke:#3182ce,stroke-width:2
    style B fill:#e6ffed,stroke:#38a169,stroke-width:2
    style C fill:#fffaf0,stroke:#d69e2e,stroke-width:2
    style D fill:#faf5ff,stroke:#805ad5,stroke-width:2
    style E fill:#ffe3e3,stroke:#e53e3e,stroke-width:2
                </div>
            </section>
            
            <!-- 6. 品牌金字塔 - 用层级展示 -->
            <section>
                <h3>6. 医院品牌层次</h3>
                <div class="mermaid">
flowchart TB
    subgraph 精神层
        direction LR
        文化品牌
    end
    
    subgraph 物质层
        direction LR
        技术品牌 & 服务品牌
    end
    
    subgraph 符号层
        direction LR
        视觉识别
    end
    
    文化品牌 --> 技术品牌
    文化品牌 --> 服务品牌
    技术品牌 --> 视觉识别
    服务品牌 --> 视觉识别
    
    style 文化品牌 fill:#805ad5,color:#fff,stroke:none,rx:12,stroke-width:4
    style 技术品牌 fill:#3182ce,color:#fff,stroke:none,rx:10
    style 服务品牌 fill:#38a169,color:#fff,stroke:none,rx:10
    style 视觉识别 fill:#d69e2e,color:#fff,stroke:none,rx:8
                </div>
            </section>
            
            <!-- 7. 质量文件层级 - 用时间线样式 -->
            <section>
                <h3>7. 质量体系文件层级</h3>
                <div class="mermaid">
flowchart TB
    L1(📋 质量手册<br/>质量方针/目标/框架):::level1
    L2(📄 程序文件<br/>管理制度/操作流程):::level2
    L3(📝 作业指导书<br/>技术标准/操作规范):::level3
    L4(📊 质量记录<br/>表单/报表/档案):::level4
    
    L1 --> L2 --> L3 --> L4
    
    classDef level1 fill:#1a365d,color:#fff,stroke:none,rx:8
    classDef level2 fill:#2c5282,color:#fff,stroke:none,rx:6
    classDef level3 fill:#3182ce,color:#fff,stroke:none,rx:4
    classDef level4 fill:#63b3ed,color:#fff,stroke:none,rx:4
                </div>
            </section>
            
            <!-- 8. 患者安全目标 - 用卡片 -->
            <section>
                <h3>8. 患者安全目标 (2023版)</h3>
                <div class="mermaid">
flowchart TB
    subgraph g1 [安全识别]
        G1(正确识别患者身份)
        G2(强化手术安全核查)
    end
    
    subgraph g2 [用药安全]
        G3(确保用药安全)
        G4(提升用药安全水平)
    end
    
    subgraph g3 [感染防控]
        G5(减少医院相关性感染)
    end
    
    subgraph g4 [风险管理]
        G6(落实不良事件报告)
        G7(预防患者跌倒/坠床)
        G8(加强医疗器械监管)
    end
    
    g1 & g2 & g3 & g4
    
    style G1,G2 fill:#ebf8ff,stroke:#3182ce
    style G3,G4 fill:#f0fff4,stroke:#38a169
    style G5 fill:#fffaf0,stroke:#d69e2e
    style G6,G7,G8 fill:#faf5ff,stroke:#805ad5
                </div>
            </section>
            
            <!-- 9. 围手术期管理 - 用泳道图 -->
            <section>
                <h3>9. 围手术期安全管理</h3>
                <div class="mermaid">
flowchart TB
    subgraph 术前
        P1(手术指征评估) --> P2(知情同意) --> P3(术前准备核查)
    end
    
    subgraph 术中
        I1(手术安全核查) --> I2(手术记录) --> I3(应急处理)
    end
    
    subgraph 术后
        A1(术后交接) --> A2(术后访视) --> A3(并发症防治)
    end
    
    P3 --> I1
    I3 --> A1
    
    style 术前 fill:#e6f3ff,stroke:#3182ce,stroke-dasharray:4
    style 术中 fill:#fffaf0,stroke:#d69e2e,stroke-dasharray:4
    style 术后 fill:#e6ffed,stroke:#38a169,stroke-dasharray:4
    style P1,P2,P3,I1,I2,I3,A1,A2,A3 fill:#fff,stroke:#333
                </div>
            </section>
            
            <!-- 10. 柏拉图 - 用 Mermaid 饼图 -->
            <section>
                <h3>10. 柏拉图 - 二八法则</h3>
                <div class="mermaid">
pie title 问题分布 (80/20法则)
    "核心问题 (20%)" : 80
    "次要问题 (80%)" : 20
                </div>
                <p style="font-size:18px;color:#666">80%的问题由20%的原因导致</p>
            </section>
            
            <!-- 结束 -->
            <section data-background-gradient="linear-gradient(135deg, #38a169, #276749)">
                <h2 style="color:#fff">总结</h2>
                <ul style="color:#fff">
                    <li>用形状表达类型</li>
                    <li>用颜色表达层级</li>
                    <li>用样式表达状态</li>
                    <li>用布局表达关系</li>
                </ul>
            </section>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
    <script>
        mermaid.initialize({ 
            startOnLoad: true,
            theme: 'default',
            flowchart: { 
                curve: 'basis',
                padding: 20
            }
        });
        Reveal.initialize({
            hash: true,
            transition: 'slide'
        });
    </script>
</body>
</html>
"""

fs.writeFileSync "outputs/mermaid-redesign.html", htmlContent
console.log "✅ Created: outputs/mermaid-redesign.html"
