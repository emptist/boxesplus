# 医疗质量课程 - 真正的代码稿子

这个文件展示如何让 Markdown 内容真正起作用！

---

## 课程信息

课程名称：医院医疗质量与安全管理
课程定位：医院管理核心模块课程
课程时长：12小时（2天）

---

## 第一章：医疗质量管理概述

### 医疗质量概念

医疗质量是指医疗服务在满足患者及其家属健康需求方面所达到的程度。

**狭义**：诊疗质量
**广义**：技术+服务+管理+环境

### 医疗质量维度

| 维度 | 内容 |
|------|------|
| 结构质量 | 人员、设备、制度、环境 |
| 过程质量 | 诊疗流程、操作规范 |
| 结果质量 | 诊疗效果、患者结局 |

### 质量管理原则

| 原则 | 说明 |
|------|------|
| 患者导向 | 以患者安全为中心 |
| 领导重视 | 最高管理者主导 |
| 全员参与 | 质量安全，人人有责 |

---

## 代码部分：解析 Markdown 并生成 PPTX

    fs = require "fs"
    marked = require "marked"
    PptxGenJS = require "pptxgenjs"
    
    # 读取当前文件
    content = fs.readFileSync __filename, "utf-8"
    
    # 提取 Markdown 部分（非缩进的内容）
    lines = content.split "\n"
    markdownLines = []
    inCode = false
    
    for line in lines
        if line.match /^    /
            inCode = true
        else if inCode and line.match /^\S/
            inCode = false
        
        if not inCode
            markdownLines.push line
    
    markdownContent = markdownLines.join "\n"
    
    # 解析 Markdown
    tokens = marked.lexer markdownContent
    
    # 创建演示文稿
    pptx = new PptxGenJS()
    pptx.title = "医疗质量课程"
    
    # 解析并生成幻灯片
    currentSlide = null
    slideContent = []
    
    for token in tokens
        switch token.type
            when "heading"
                if currentSlide
                    # 添加之前的幻灯片
                    addSlide pptx, currentSlide, slideContent
                
                # 开始新的幻灯片
                currentSlide = token.text
                slideContent = []
            
            when "table"
                # 表格内容
                slideContent.push 
                    type: "table"
                    header: token.header
                    rows: token.rows
            
            when "paragraph"
                # 段落内容
                slideContent.push 
                    type: "paragraph"
                    text: token.text
            
            when "list"
                # 列表内容
                slideContent.push 
                    type: "list"
                    items: token.items
    
    # 添加最后一个幻灯片
    if currentSlide
        addSlide pptx, currentSlide, slideContent
    
    # 辅助函数：添加幻灯片
    addSlide = (pptx, title, content) ->
        slide = pptx.addSlide()
        
        # 标题
        slide.addText title,
            x: 0.5, y: 0.3, w: 9, h: 0.6
            fontSize: 28, bold: true, color: "366092"
        
        # 内容
        y = 1.2
        for item in content
            switch item.type
                when "paragraph"
                    slide.addText item.text,
                        x: 0.5, y: y, w: 9, h: 0.5
                        fontSize: 14
                    y += 0.6
                
                when "table"
                    rows = [item.header]
                    rows = rows.concat item.rows
                    slide.addTable rows,
                        x: 0.5, y: y, w: 9, h: 3
                        fontSize: 14
                        border: { pt: 1, color: "CCCCCC" }
                    y += 3.5
                
                when "list"
                    text = (item.text for item in item.items).join "\n"
                    slide.addText text,
                        x: 0.5, y: y, w: 9, h: 2
                        fontSize: 14
                    y += 2.5
    
    # 保存
    pptx.writeFile "outputs/医疗质量课程-自动生成.pptx"
    console.log "✅ 已生成：outputs/医疗质量课程-自动生成.pptx"
    console.log "📊 共 #{pptx.slides.length} 张幻灯片"
