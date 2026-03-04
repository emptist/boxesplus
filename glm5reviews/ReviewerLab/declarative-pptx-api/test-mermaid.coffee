#!/usr/bin/env coffee

{ MermaidSlide, Section, Presentation } = require "./index"

class TestPDCA extends MermaidSlide
    @图表: """
flowchart LR
    P[PLAN<br/>计划] --> D[DO<br/>执行]
    D --> C[CHECK<br/>检查]
    C --> A[ACTION<br/>处理]
    A -.->|持续改进| P
    
    style P fill:#3182ce,color:#fff,stroke:none,rx:30
    style D fill:#38a169,color:#fff,stroke:none,rx:30
    style C fill:#d69e2e,color:#fff,stroke:none,rx:30
    style A fill:#e53e3e,color:#fff,stroke:none,rx:30
    """

class TestFlowchart extends MermaidSlide
    @diagram: """
flowchart TB
    A[开始] --> B{判断}
    B -->|是| C[执行A]
    B -->|否| D[执行B]
    C --> E[结束]
    D --> E
    """

class TestSection extends Section
    @幻灯片: -> [TestPDCA, TestFlowchart]

class TestMermaidPresentation extends Presentation
    @sections: -> [TestSection]
    @nowYou: @generateHtml()
