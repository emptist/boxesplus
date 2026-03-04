#!/usr/bin/env coffee

# Test New Slide Types

{ 
    SectionSlide, EndSlide, PDCASlide, OrgChartSlide, BoxSlide, MatrixSlide,
    Presentation 
} = require "./index"

console.log "🧪 Testing New Slide Types...\n"

# Test 1: SectionSlide
console.log "Test 1: SectionSlide"
class 第一章 extends SectionSlide
    @编号: "01"
    @副标题: "品牌建设基础"

# Test 2: EndSlide
console.log "Test 2: EndSlide"
class 谢谢聆听 extends EndSlide
    @感谢语: "感谢聆听"
    @联系方式: "contact@example.com"

# Test 3: PDCASlide
console.log "Test 3: PDCASlide"
class 质量管理PDCA extends PDCASlide
    @P: "制定质量目标和计划"
    @D: "执行质量计划"
    @C: "检查质量结果"
    @A: "处理质量问题"

# Test 4: OrgChartSlide
console.log "Test 4: OrgChartSlide"
class 医院组织架构 extends OrgChartSlide
    @顶层: "院长"
    @中层: "副院长, 科室主任"
    @基层: "医生, 护士, 行政人员"

# Test 5: BoxSlide
console.log "Test 5: BoxSlide"
class 品牌建设要素 extends BoxSlide
    @品牌定位: "明确品牌定位"
    @品牌传播: "制定传播策略"
    @品牌管理: "建立管理体系"
    @品牌评估: "定期评估效果"

# Test 6: MatrixSlide
console.log "Test 6: MatrixSlide"
class 波士顿矩阵 extends MatrixSlide
    @明星: "高增长高市场份额"
    @金牛: "低增长高市场份额"
    @问题: "高增长低市场份额"
    @瘦狗: "低增长低市场份额"

# Generate test presentation
console.log "\nGenerating test presentation..."

class TestSection
    @幻灯片: -> [
        第一章
        质量管理PDCA
        医院组织架构
        品牌建设要素
        波士顿矩阵
        谢谢聆听
    ]

class TestNewSlideTypes extends Presentation
    @sections: -> [TestSection]
    @nowYou: @newPresentation()

console.log "\n🎉 Test completed!"
console.log "Check outputs/TestNewSlideTypes.pptx for results"
