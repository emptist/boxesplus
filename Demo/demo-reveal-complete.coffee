# BoxesPlus - Reveal.js 完整演示
# 测试复杂关系图的呈现效果

# 本地 Reveal.js 配置
revealConfig = {
  hash: true
  slideNumber: true
  transition: 'slide'
  backgroundTransition: 'fade'
  center: false
  width: 1280
  height: 720
  margin: 0.04
}

# 幻灯片数据
slides = []

# ============ 封面 ============
slides.push
  content: '''
    <section style="text-align: center;">
      <h1 style="color: #1a365d; font-size: 2.5em;">医院品牌建设与传播管理</h1>
      <h3 style="color: #2c5282;">E02 品牌建设课程</h3>
      <p style="color: #718096; margin-top: 40px;">Reveal.js 完整演示</p>
      <p style="font-size: 0.6em; color: #a0aec0;">使用本地 Reveal.js + 复杂图表</p>
    </section>
  '''

# ============ 课程目标 ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">课程目标</h2>
      <div style="display: flex; gap: 20px; margin-top: 40px;">
        <div style="flex: 1; background: #ebf8ff; border-radius: 10px; padding: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <h3 style="color: #2b6cb0;">📚 知识目标</h3>
          <ul style="font-size: 0.7em; text-align: left;">
            <li>掌握品牌管理理论</li>
            <li>熟悉品牌建设要素</li>
            <li>了解传播策略</li>
          </ul>
        </div>
        <div style="flex: 1; background: #f0fff4; border-radius: 10px; padding: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <h3 style="color: #276749;">💪 能力目标</h3>
          <ul style="font-size: 0.7em; text-align: left;">
            <li>制定品牌战略</li>
            <li>设计传播方案</li>
            <li>处理品牌危机</li>
          </ul>
        </div>
        <div style="flex: 1; background: #fffaf0; border-radius: 10px; padding: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <h3 style="color: #c05621;">⭐ 素质目标</h3>
          <ul style="font-size: 0.7em; text-align: left;">
            <li>培养品牌思维</li>
            <li>提升专业化水平</li>
          </ul>
        </div>
      </div>
    </section>
  '''

# ============ 章节：品牌管理概述 ============
slides.push
  content: '''
    <section style="text-align: center; background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);">
      <h1 style="color: white; font-size: 3em;">第一章</h1>
      <h2 style="color: #90cdf4;">医院品牌管理概述</h2>
      <p style="color: #a0aec0; margin-top: 40px;">1小时</p>
    </section>
  '''

# ============ 流程图 - 品牌建设流程 ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">品牌建设流程</h2>
      <div style="display: flex; align-items: center; justify-content: center; margin-top: 30px;">
        <div style="background: #2b6cb0; color: white; padding: 15px 25px; border-radius: 8px;">调研分析</div>
        <div style="width: 50px; height: 3px; background: #cbd5e0;"></div>
        <div style="font-size: 30px; color: #cbd5e0;">→</div>
        <div style="width: 50px; height: 3px; background: #cbd5e0;"></div>
        <div style="background: #38a169; color: white; padding: 15px 25px; border-radius: 8px;">战略规划</div>
        <div style="width: 50px; height: 3px; background: #cbd5e0;"></div>
        <div style="font-size: 30px; color: #cbd5e0;">→</div>
        <div style="width: 50px; height: 3px; background: #cbd5e0;"></div>
        <div style="background: #d69e2e; color: white; padding: 15px 25px; border-radius: 8px;">执行落地</div>
        <div style="width: 50px; height: 3px; background: #cbd5e0;"></div>
        <div style="font-size: 30px; color: #cbd5e0;">→</div>
        <div style="width: 50px; height: 3px; background: #cbd5e0;"></div>
        <div style="background: #e53e3e; color: white; padding: 15px 25px; border-radius: 8px;">评估优化</div>
      </div>
    </section>
  '''

# ============ 组织架构图 ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">品牌管理组织架构</h2>
      <div style="margin-top: 30px; text-align: center;">
        <!-- 顶层 -->
        <div style="background: #1a365d; color: white; padding: 15px 40px; border-radius: 8px; display: inline-block;">医院品牌委员会</div>
        
        <!-- 箭头 -->
        <div style="width: 3px; height: 30px; background: #cbd5e0; margin: 10px auto;"></div>
        
        <!-- 第二层 -->
        <div style="display: flex; justify-content: center; gap: 20px;">
          <div style="background: #2b6cb0; color: white; padding: 12px 30px; border-radius: 8px;">品牌总监</div>
          <div style="background: #2b6cb0; color: white; padding: 12px 30px; border-radius: 8px;">市场部</div>
          <div style="background: #2b6cb0; color: white; padding: 12px 30px; border-radius: 8px;">宣传部</div>
        </div>
        
        <!-- 箭头 -->
        <div style="width: 3px; height: 30px; background: #cbd5e0; margin: 10px auto;"></div>
        
        <!-- 第三层 -->
        <div style="display: flex; justify-content: center; gap: 15px;">
          <div style="background: #3182ce; color: white; padding: 10px 20px; border-radius: 6px; font-size: 0.8em;">品牌策划</div>
          <div style="background: #3182ce; color: white; padding: 10px 20px; border-radius: 6px; font-size: 0.8em;">市场推广</div>
          <div style="background: #3182ce; color: white; padding: 10px 20px; border-radius: 6px; font-size: 0.8em;">新媒体运营</div>
          <div style="background: #3182ce; color: white; padding: 10px 20px; border-radius: 6px; font-size: 0.8em;">公共关系</div>
          <div style="background: #3182ce; color: white; padding: 10px 20px; border-radius: 6px; font-size: 0.8em;">活动执行</div>
        </div>
      </div>
    </section>
  '''

# ============ 循环图 - PDCA ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">品牌持续改进 - PDCA循环</h2>
      <div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
        <div style="position: relative; width: 400px; height: 400px;">
          <!-- PLAN -->
          <div style="position: absolute; top: 0; left: 50%; transform: translateX(-50%); background: #3182ce; color: white; padding: 15px 30px; border-radius: 50%;">
            <strong>PLAN</strong><br><span style="font-size: 0.6em;">计划</span>
          </div>
          <!-- DO -->
          <div style="position: absolute; top: 50%; right: 0; transform: translateY(-50%); background: #38a169; color: white; padding: 15px 30px; border-radius: 50%;">
            <strong>DO</strong><br><span style="font-size: 0.6em;">执行</span>
          </div>
          <!-- CHECK -->
          <div style="position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); background: #d69e2e; color: white; padding: 15px 30px; border-radius: 50%;">
            <strong>CHECK</strong><br><span style="font-size: 0.6em;">检查</span>
          </div>
          <!-- ACTION -->
          <div style="position: absolute; top: 50%; left: 0; transform: translateY(-50%); background: #e53e3e; color: white; padding: 15px 30px; border-radius: 50%;">
            <strong>ACTION</strong><br><span style="font-size: 0.6em;">处理</span>
          </div>
          <!-- 中心 -->
          <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #1a365d; color: white; padding: 20px; border-radius: 50%; width: 100px; height: 100px; display: flex; align-items: center; justify-content: center; font-size: 0.8em;">
            持续<br>改进
          </div>
        </div>
      </div>
    </section>
  '''

# ============ 矩阵图 - SWOT ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">品牌战略分析 - SWOT</h2>
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 30px;">
        <div style="background: #c6f6d5; padding: 20px; border-radius: 8px;">
          <h4 style="color: #276749; margin: 0 0 10px 0;">✅ 优势 Strengths</h4>
          <ul style="font-size: 0.6em; margin: 0; padding-left: 20px;">
            <li>技术领先</li>
            <li>专家团队</li>
            <li>品牌积累</li>
          </ul>
        </div>
        <div style="background: #fed7d7; padding: 20px; border-radius: 8px;">
          <h4 style="color: #c53030; margin: 0 0 10px 0;">⚠️ 劣势 Weaknesses</h4>
          <ul style="font-size: 0.6em; margin: 0; padding-left: 20px;">
            <li>传播投入不足</li>
            <li>新媒体弱</li>
            <li>品牌认知度</li>
          </ul>
        </div>
        <div style="background: #bee3f8; padding: 20px; border-radius: 8px;">
          <h4 style="color: #2b6cb0; margin: 0 0 10px 0;">🔮 机会 Opportunities</h4>
          <ul style="font-size: 0.6em; margin: 0; padding-left: 20px;">
            <li>政策支持</li>
            <li>市场需求增长</li>
            <li>新媒体红利</li>
          </ul>
        </div>
        <div style="background: #feebc8; padding: 20px; border-radius: 8px;">
          <h4 style="color: #c05621; margin: 0 0 10px 0;">🚨 威胁 Threats</h4>
          <ul style="font-size: 0.6em; margin: 0; padding-left: 20px;">
            <li>竞争激烈</li>
            <li>舆论风险</li>
            <li>成本上升</li>
          </ul>
        </div>
      </div>
    </section>
  '''

# ============ 时间线 - 品牌建设里程碑 ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">品牌建设时间线</h2>
      <div style="margin-top: 30px; padding-left: 50px; border-left: 4px solid #3182ce;">
        <div style="position: relative; margin-bottom: 30px;">
          <div style="position: absolute; left: -62px; top: 0; background: #3182ce; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em;">1</div>
          <h4 style="margin: 0; color: #1a365d;">第一阶段：调研诊断 (1-2月)</h4>
          <p style="font-size: 0.6em; color: #718096;">品牌现状调研、竞品分析、患者感知</p>
        </div>
        <div style="position: relative; margin-bottom: 30px;">
          <div style="position: absolute; left: -62px; top: 0; background: #38a169; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em;">2</div>
          <h4 style="margin: 0; color: #1a365d;">第二阶段：战略规划 (3-4月)</h4>
          <p style="font-size: 0.6em; color: #718096;">品牌定位、视觉设计、传播策略</p>
        </div>
        <div style="position: relative; margin-bottom: 30px;">
          <div style="position: absolute; left: -62px; top: 0; background: #d69e2e; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em;">3</div>
          <h4 style="margin: 0; color: #1a365d;">第三阶段：执行落地 (5-10月)</h4>
          <p style="font-size: 0.6em; color: #718096;">线上推广、线下活动、媒体合作</p>
        </div>
        <div style="position: relative;">
          <div style="position: absolute; left: -62px; top: 0; background: #e53e3e; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em;">4</div>
          <h4 style="margin: 0; color: #1a365d;">第四阶段：评估优化 (11-12月)</h4>
          <p style="font-size: 0.6em; color: #718096;">效果评估、持续改进、总结汇报</p>
        </div>
      </div>
    </section>
  '''

# ============ 饼图 - 品牌传播渠道 ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">品牌传播渠道分布</h2>
      <div style="display: flex; justify-content: space-around; margin-top: 30px;">
        <div style="width: 45%;">
          <svg viewBox="0 0 100 100" style="transform: rotate(-90deg);">
            <circle cx="50" cy="50" r="40" fill="transparent" stroke="#3182ce" stroke-width="20" stroke-dasharray="100.53 251.33" />
            <circle cx="50" cy="50" r="40" fill="transparent" stroke="#38a169" stroke-width="20" stroke-dasharray="75.4 251.33" stroke-dashoffset="-100.53" />
            <circle cx="50" cy="50" r="40" fill="transparent" stroke="#d69e2e" stroke-width="20" stroke-dasharray="50.27 251.33" stroke-dashoffset="-175.93" />
            <circle cx="50" cy="50" r="40" fill="transparent" stroke="#e53e3e" stroke-width="20" stroke-dasharray="25.13 251.33" stroke-dashoffset="-226.2" />
          </svg>
        </div>
        <div style="width: 45%; font-size: 0.7em;">
          <div style="display: flex; align-items: center; margin-bottom: 15px;">
            <div style="width: 20px; height: 20px; background: #3182ce; border-radius: 4px; margin-right: 10px;"></div>
            <span>新媒体 (40%)</span>
          </div>
          <div style="display: flex; align-items: center; margin-bottom: 15px;">
            <div style="width: 20px; height: 20px; background: #38a169; border-radius: 4px; margin-right: 10px;"></div>
            <span>口碑传播 (30%)</span>
          </div>
          <div style="display: flex; align-items: center; margin-bottom: 15px;">
            <div style="width: 20px; height: 20px; background: #d69e2e; border-radius: 4px; margin-right: 10px;"></div>
            <span>传统媒体 (20%)</span>
          </div>
          <div style="display: flex; align-items: center;">
            <div style="width: 20px; height: 20px; background: #e53e3e; border-radius: 4px; margin-right: 10px;"></div>
            <span>院内传播 (10%)</span>
          </div>
        </div>
      </div>
    </section>
  '''

# ============ 柱状图 - 品牌指数 ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">品牌影响力季度变化</h2>
      <div style="margin-top: 30px; display: flex; align-items: flex-end; justify-content: space-around; height: 300px; padding: 0 50px;">
        <div style="display: flex; flex-direction: column; align-items: center;">
          <div style="width: 60px; background: linear-gradient(to top, #3182ce, #63b3ed); border-radius: 4px 4px 0 0; height: 150px;"></div>
          <div style="margin-top: 10px; font-size: 0.7em;">Q1</div>
          <div style="font-size: 0.6em; color: #718096;">65</div>
        </div>
        <div style="display: flex; flex-direction: column; align-items: center;">
          <div style="width: 60px; background: linear-gradient(to top, #38a169, #68d391); border-radius: 4px 4px 0 0; height: 180px;"></div>
          <div style="margin-top: 10px; font-size: 0.7em;">Q2</div>
          <div style="font-size: 0.6em; color: #718096;">72</div>
        </div>
        <div style="display: flex; flex-direction: column; align-items: center;">
          <div style="width: 60px; background: linear-gradient(to top, #d69e2e, #f6e05e); border-radius: 4px 4px 0 0; height: 210px;"></div>
          <div style="margin-top: 10px; font-size: 0.7em;">Q3</div>
          <div style="font-size: 0.6em; color: #718096;">80</div>
        </div>
        <div style="display: flex; flex-direction: column; align-items: center;">
          <div style="width: 60px; background: linear-gradient(to top, #e53e3e, #fc8181); border-radius: 4px 4px 0 0; height: 250px;"></div>
          <div style="margin-top: 10px; font-size: 0.7em;">Q4</div>
          <div style="font-size: 0.6em; color: #718096;">90</div>
        </div>
      </div>
      <div style="text-align: center; margin-top: 20px; font-size: 0.7em; color: #718096;">品牌影响力指数 (满分100)</div>
    </section>
  '''

# ============ 对比表格 ============
slides.push
  content: '''
    <section>
      <h2 style="color: #1a365d;">传统 vs 现代品牌传播</h2>
      <table style="width: 100%; font-size: 0.65em; margin-top: 20px; border-collapse: collapse;">
        <tr style="background: #1a365d; color: white;">
          <th style="padding: 15px; text-align: left;">维度</th>
          <th style="padding: 15px; text-align: center;">传统模式</th>
          <th style="padding: 15px; text-align: center;">现代模式</th>
        </tr>
        <tr style="background: #f7fafc;">
          <td style="padding: 12px; border-bottom: 1px solid #e2e8f0;">传播渠道</td>
          <td style="padding: 12px; text-align: center; border-bottom: 1px solid #e2e8f0;">电视、报纸、广播</td>
          <td style="padding: 12px; text-align: center; background: #c6f6d5; border-bottom: 1px solid #e2e8f0;">微信、抖音、小红书</td>
        </tr>
        <tr>
          <td style="padding: 12px; border-bottom: 1px solid #e2e8f0;">传播方式</td>
          <td style="padding: 12px; text-align: center; border-bottom: 1px solid #e2e8f0;">单向传播</td>
          <td style="padding: 12px; text-align: center; background: #c6f6d5; border-bottom: 1px solid #e2e8f0;">双向互动</td>
        </tr>
        <tr style="background: #f7fafc;">
          <td style="padding: 12px; border-bottom: 1px solid #e2e8f0;">成本</td>
          <td style="padding: 12px; text-align: center; border-bottom: 1px solid #e2e8f0;">高</td>
          <td style="padding: 12px; text-align: center; background: #c6f6d5; border-bottom: 1px solid #e2e8f0;">低</td>
        </tr>
        <tr>
          <td style="padding: 12px; border-bottom: 1px solid #e2e8f0;">效果评估</td>
          <td style="padding: 12px; text-align: center; border-bottom: 1px solid #e2e8f0;">困难</td>
          <td style="padding: 12px; text-align: center; background: #c6f6d5; border-bottom: 1px solid #e2e8f0;">精准</td>
        </tr>
      </table>
    </section>
  '''

# ============ 结束页 ============
slides.push
  content: '''
    <section style="text-align: center; background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);">
      <h1 style="color: white; font-size: 3em;">谢谢!</h1>
      <h3 style="color: #90cdf4; margin-top: 20px;">BoxesPlus + Reveal.js</h3>
      <p style="color: #a0aec0; margin-top: 40px;">本地离线 | 复杂图表 | 精美呈现</p>
    </section>
  '''

# ============ 生成 HTML ============
fs = require "fs"

html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>医院品牌建设课程 - Reveal.js 完整版</title>
  <link rel="stylesheet" href="reveal.js/css/reveal.css">
  <link rel="stylesheet" href="reveal.js/css/theme/white.css">
  <style>
    .reveal .slides section { text-align: left; }
    .reveal { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; }
  </style>
</head>
<body>
  <div class="reveal">
    <div class="slides">
"""

for slide in slides
  html += slide.content

html += """
    </div>
  </div>
  <script src="reveal.js/js/reveal.js"></script>
  <script>
    Reveal.initialize({
      hash: true,
      slideNumber: true,
      transition: 'slide',
      backgroundTransition: 'fade',
      center: false,
      width: 1280,
      height: 720,
      margin: 0.04
    });
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/reveal-complete.html", html
console.log "✅ Created: outputs/reveal-complete.html"
console.log "打开方式: outputs/reveal-complete.html?print-pdf"
