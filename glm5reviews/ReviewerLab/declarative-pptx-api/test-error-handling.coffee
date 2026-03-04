#!/usr/bin/env coffee

# Test error handling and validation

{ Slide, TitleSlide, SWOTSlide, Presentation } = require "./index"

console.log "🧪 Testing error handling and validation...\n"

# Test 1: Valid TitleSlide
console.log "Test 1: Valid TitleSlide"
class TestTitle1 extends TitleSlide
    @副标题: "Test subtitle"

try
    pptxgen = require "pptxgenjs"
    pptx = new pptxgen()
    TestTitle1.toPptx(pptx)
    console.log "✅ Test 1 passed: Valid TitleSlide created\n"
catch error
    console.log "❌ Test 1 failed:", error.message, "\n"

# Test 2: Invalid TitleSlide (副标题 is not a string)
console.log "Test 2: Invalid TitleSlide (副标题 is not a string)"
class TestTitle2 extends TitleSlide
    @副标题: 123

try
    pptxgen = require "pptxgenjs"
    pptx = new pptxgen()
    TestTitle2.toPptx(pptx)
    console.log "❌ Test 2 failed: Should have thrown an error\n"
catch error
    console.log "✅ Test 2 passed: Caught error -", error.message, "\n"

# Test 3: Valid SWOTSlide
console.log "Test 3: Valid SWOTSlide"
class TestSWOT1 extends SWOTSlide
    @优势: "Strength 1"
    @劣势: "Weakness 1"

try
    pptxgen = require "pptxgenjs"
    pptx = new pptxgen()
    TestSWOT1.toPptx(pptx)
    console.log "✅ Test 3 passed: Valid SWOTSlide created\n"
catch error
    console.log "❌ Test 3 failed:", error.message, "\n"

# Test 4: Invalid SWOTSlide (no SWOT properties)
console.log "Test 4: Invalid SWOTSlide (no SWOT properties)"
class TestSWOT2 extends SWOTSlide

try
    pptxgen = require "pptxgenjs"
    pptx = new pptxgen()
    TestSWOT2.toPptx(pptx)
    console.log "❌ Test 4 failed: Should have thrown an error\n"
catch error
    console.log "✅ Test 4 passed: Caught error -", error.message, "\n"

console.log "🎉 All tests completed!"
