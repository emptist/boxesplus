#!/usr/bin/env coffee

testValues = [
    "区域认知度 90%"
    "满意度 95%"
    "复诊率 60%"
    "愿意推荐比例 80%"
    "科普短视频，粉丝量100万+"
    "暖心故事，粉丝量50万+"
    "案例分享，粉丝量80万+"
]

pattern = /(\d+\.?\d*\s*%?|\d+\s*[万千万亿]+[+]?)$/

console.log "\nTesting regex pattern:\n"

for value in testValues
    match = value.match(pattern)
    extracted = if match then match[1] else "NO MATCH"
    console.log "\"#{value}\" → \"#{extracted}\""
