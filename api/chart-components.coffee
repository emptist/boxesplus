# BoxesPlus - Reveal.js 图表组件库
# 简化复杂图表的创建

# ============ PDCA 循环 ============
pdcaSlide = (opts = {}) ->
  { title, size } = opts
  size = size || 140
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || 'PDCA循环'}</h2>
    <div style="position: relative; width: 600px; height: 420px; margin: 20px auto;">
      <svg width="600" height="420" style="position: absolute; top: 0; left: 0;">
        <defs>
          <marker id="arrowhead-#{Date.now()}" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
            <polygon points="0 0, 10 3.5, 0 7" fill="#718096"/>
          </marker>
        </defs>
        <path d="M 300 40 Q 480 40 520 160" stroke="#cbd5e0" stroke-width="3" fill="none" marker-end="url(#arrowhead-#{Date.now()})"/>
        <path d="M 520 260 Q 520 400 380 400" stroke="#cbd5e0" stroke-width="3" fill="none" marker-end="url(#arrowhead-#{Date.now()})"/>
        <path d="M 220 400 Q 80 400 80 260" stroke="#cbd5e0" stroke-width="3" fill="none" marker-end="url(#arrowhead-#{Date.now()})"/>
        <path d="M 80 160 Q 120 40 300 40" stroke="#cbd5e0" stroke-width="3" fill="none" marker-end="url(#arrowhead-#{Date.now()})"/>
      </svg>
      
      <div style="position: absolute; top: 10px; right: 70px; width: #{size}px; height: #{size}px; background: linear-gradient(135deg, #3182ce, #2b6cb0); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; box-shadow: 0 4px 15px rgba(49,130,206,0.4);">
        <strong style="font-size: 0.8em;">PLAN</strong>
        <span style="font-size: 0.6em; opacity: 0.9;">计划</span>
      </div>
      
      <div style="position: absolute; bottom: 40px; right: 20px; width: #{size}px; height: #{size}px; background: linear-gradient(135deg, #38a169, #2f855a); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; box-shadow: 0 4px 15px rgba(56,161,105,0.4);">
        <strong style="font-size: 0.8em;">DO</strong>
        <span style="font-size: 0.6em; opacity: 0.9;">执行</span>
      </div>
      
      <div style="position: absolute; bottom: 40px; left: 20px; width: #{size}px; height: #{size}px; background: linear-gradient(135deg, #d69e2e, #b7791f); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; box-shadow: 0 4px 15px rgba(214,158,46,0.4);">
        <strong style="font-size: 0.8em;">CHECK</strong>
        <span style="font-size: 0.6em; opacity: 0.9;">检查</span>
      </div>
      
      <div style="position: absolute; top: 10px; left: 70px; width: #{size}px; height: #{size}px; background: linear-gradient(135deg, #e53e3e, #c53030); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; box-shadow: 0 4px 15px rgba(229,62,62,0.4);">
        <strong style="font-size: 0.8em;">ACTION</strong>
        <span style="font-size: 0.6em; opacity: 0.9;">处理</span>
      </div>
      
      <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #1a365d; color: white; width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em; text-align: center; box-shadow: 0 4px 20px rgba(26,54,93,0.5);">
        持续<br>改进
      </div>
    </div>
  </section>
  """

# ============ SWOT 分析 ============
swotSlide = (opts = {}) ->
  { title, strengths, weaknesses, opportunities, threats } = opts
  
  strengths = strengths || ["优势1", "优势2"]
  weaknesses = weaknesses || ["劣势1", "劣势2"]
  opportunities = opportunities || ["机会1", "机会2"]
  threats = threats || ["威胁1", "威胁2"]
  
  listHtml = (items) ->
    items.map((item) -> "<li>#{item}</li>").join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || 'SWOT分析'}</h2>
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 30px;">
      <div style="background: #c6f6d5; padding: 20px; border-radius: 8px;">
        <h4 style="color: #276749; margin: 0 0 10px 0;">✅ 优势 Strengths</h4>
        <ul style="font-size: 0.7em; margin: 0; padding-left: 20px;">#{listHtml(strengths)}</ul>
      </div>
      <div style="background: #fed7d7; padding: 20px; border-radius: 8px;">
        <h4 style="color: #c53030; margin: 0 0 10px 0;">⚠️ 劣势 Weaknesses</h4>
        <ul style="font-size: 0.7em; margin: 0; padding-left: 20px;">#{listHtml(weaknesses)}</ul>
      </div>
      <div style="background: #bee3f8; padding: 20px; border-radius: 8px;">
        <h4 style="color: #2b6cb0; margin: 0 0 10px 0;">🔮 机会 Opportunities</h4>
        <ul style="font-size: 0.7em; margin: 0; padding-left: 20px;">#{listHtml(opportunities)}</ul>
      </div>
      <div style="background: #feebc8; padding: 20px; border-radius: 8px;">
        <h4 style="color: #c05621; margin: 0 0 10px 0;">🚨 威胁 Threats</h4>
        <ul style="font-size: 0.7em; margin: 0; padding-left: 20px;">#{listHtml(threats)}</ul>
      </div>
    </div>
  </section>
  """

# ============ 时间线 ============
timelineSlide = (opts = {}) ->
  { title, events } = opts
  
  events = events || [
    { title: "第一阶段", desc: "描述", color: "#3182ce" }
    { title: "第二阶段", desc: "描述", color: "#38a169" }
  ]
  
  eventHtml = (event, i) ->
    """
    <div style="position: relative; margin-bottom: 25px; padding-left: 40px;">
      <div style="position: absolute; left: 0; top: 0; background: #{event.color}; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em;">#{i + 1}</div>
      <h4 style="margin: 0; color: #1a365d; font-size: 0.9em;">#{event.title}</h4>
      <p style="font-size: 0.65em; color: #718096; margin: 5px 0 0 0;">#{event.desc}</p>
    </div>
    """
  
  eventsHtml = events.map((e, i) -> eventHtml(e, i)).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '时间线'}</h2>
    <div style="margin-top: 30px; padding-left: 20px; border-left: 4px solid #3182ce;">
      #{eventsHtml}
    </div>
  </section>
  """

# ============ 流程图 ============
flowchartSlide = (opts = {}) ->
  { title, steps } = opts
  
  steps = steps || [
    { text: "步骤1", color: "#3182ce" }
    { text: "步骤2", color: "#38a169" }
    { text: "步骤3", color: "#d69e2e" }
    { text: "步骤4", color: "#e53e3e" }
  ]
  
  stepHtml = (step, i) ->
    """
    <div style="background: #{step.color}; color: white; padding: 12px 25px; border-radius: 6px; font-size: 0.75em;">#{step.text}</div>
    """
  
  arrowHtml = """
    <div style="width: 30px; height: 2px; background: #cbd5e0;"></div>
    <div style="font-size: 20px; color: #cbd5e0;">→</div>
    <div style="width: 30px; height: 2px; background: #cbd5e0;"></div>
  """
  
  stepsHtml = steps.map((s, i) -> 
    stepHtml(s, i) + (if i < steps.length - 1 then arrowHtml else "")
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '流程图'}</h2>
    <div style="display: flex; align-items: center; justify-content: center; margin-top: 50px; flex-wrap: wrap; gap: 5px;">
      #{stepsHtml}
    </div>
  </section>
  """

# ============ 组织架构图 ============
orgChartSlide = (opts = {}) ->
  { title, levels } = opts
  
  levels = levels || [
    { text: "院长", color: "#1a365d" }
    { text: ["副院长1", "副院长2"], color: "#2b6cb0" }
    { text: ["科室1", "科室2", "科室3"], color: "#3182ce" }
  ]
  
  levelHtml = (level, i) ->
    items = if Array.isArray(level.text) then level.text else [level.text]
    itemsHtml = items.map((item) -> 
      "<div style=\"background: #{level.color}; color: white; padding: 10px 25px; border-radius: 6px; font-size: 0.7em; margin: 0 5px;\">#{item}</div>"
    ).join("")
    
    """
    <div style="display: flex; justify-content: center; gap: 15px; margin: 10px 0;">
      #{itemsHtml}
    </div>
    """
  
  arrowHtml = """
    <div style="width: 3px; height: 25px; background: #cbd5e0; margin: 0 auto;"></div>
  """
  
  levelsHtml = levels.map((l, i) -> 
    levelHtml(l, i) + (if i < levels.length - 1 then arrowHtml else "")
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '组织架构'}</h2>
    <div style="margin-top: 30px; text-align: center;">
      #{levelsHtml}
    </div>
  </section>
  """

# ============ 对比表格 ============
comparisonSlide = (opts = {}) ->
  { title, headers, rows } = opts
  
  headers = headers || ["维度", "方案A", "方案B"]
  rows = rows || [
    ["优点", "免费", "稳定"]
    ["缺点", "功能少", "收费"]
  ]
  
  headerHtml = headers.map((h) -> "<th style=\"padding: 12px; background: #1a365d; color: white;\">#{h}</th>").join("")
  
  rowHtml = (row, i) ->
    bg = if i % 2 == 0 then "#f7fafc" else "white"
    cells = row.map((cell) -> "<td style=\"padding: 10px; border-bottom: 1px solid #e2e8f0; font-size: 0.7em;\">#{cell}</td>").join("")
    "<tr style=\"background: #{bg};\">#{cells}</tr>"
  
  rowsHtml = rows.map((r) -> rowHtml(r, rows.indexOf(r))).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '对比分析'}</h2>
    <table style="width: 90%; margin: 30px auto; border-collapse: collapse; font-size: 0.7em;">
      <tr>#{headerHtml}</tr>
      #{rowsHtml}
    </table>
  </section>
  """

# ============ 卡片网格 ============
cardsSlide = (opts = {}) ->
  { title, cards } = opts
  
  cards = cards || [
    { title: "卡片1", content: "内容1", color: "#ebf8ff" }
    { title: "卡片2", content: "内容2", color: "#f0fff4" }
    { title: "卡片3", content: "内容3", color: "#fffaf0" }
  ]
  
  cardHtml = (card) ->
    """
    <div style="flex: 1; background: #{card.color}; border-radius: 10px; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); min-width: 200px;">
      <h3 style="margin: 0 0 10px 0; font-size: 0.85em; color: #1a365d;">#{card.title}</h3>
      <p style="margin: 0; font-size: 0.7em; color: #4a5568;">#{card.content}</p>
    </div>
    """
  
  cardsHtml = cards.map((c) -> cardHtml(c)).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '特点'}</h2>
    <div style="display: flex; gap: 20px; margin-top: 40px; justify-content: center; flex-wrap: wrap;">
      #{cardsHtml}
    </div>
  </section>
  """

# ============ 列表页 ============
listSlide = (opts = {}) ->
  { title, items } = opts
  
  items = items || ["要点1", "要点2", "要点3"]
  
  itemHtml = (item, i) ->
    """
    <div style="display: flex; align-items: flex-start; margin-bottom: 15px;">
      <div style="background: #3182ce; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em; margin-right: 15px; flex-shrink: 0;">#{i + 1}</div>
      <div style="font-size: 0.75em; color: #2d3748; padding-top: 5px;">#{item}</div>
    </div>
    """
  
  itemsHtml = items.map((item, i) -> itemHtml(item, i)).join("")
  
  """
  <section>
    <h2 style="color: #1a365d;">#{title || '内容'}</h2>
    <div style="margin-top: 30px; padding: 0 20px;">
      #{itemsHtml}
    </div>
  </section>
  """

# ============ 封面页 ============
titleSlide = (opts = {}) ->
  { title, subtitle, gradient } = opts
  
  gradient = gradient || "linear-gradient(135deg, #1a365d 0%, #2c5282 100%)"
  
  """
  <section style="text-align: center; background: #{gradient};">
    <h1 style="color: white; font-size: 2.2em; margin-bottom: 20px;">#{title || '标题'}</h1>
    <h3 style="color: #90cdf4; font-size: 1.2em;">#{subtitle || ''}</h3>
  </section>
  """

# ============ 章节页 ============
sectionSlide = (opts = {}) ->
  { title, subtitle } = opts
  
  """
  <section style="text-align: center; background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);">
    <h1 style="color: white; font-size: 2.5em;">#{title || '章节'}</h1>
    <h2 style="color: #90cdf4; margin-top: 20px;">#{subtitle || ''}</h2>
  </section>
  """

# ============ 结束页 ============
endSlide = (opts = {}) ->
  { title, subtitle } = opts
  
  """
  <section style="text-align: center; background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);">
    <h1 style="color: white; font-size: 3em;">#{title || '谢谢!'}</h1>
    <h3 style="color: #90cdf4; margin-top: 20px;">#{subtitle || ''}</h3>
  </section>
  """

module.exports = {
  titleSlide, sectionSlide, endSlide, listSlide, cardsSlide
  pdcaSlide, swotSlide, timelineSlide, flowchartSlide, orgChartSlide
  comparisonSlide
}
