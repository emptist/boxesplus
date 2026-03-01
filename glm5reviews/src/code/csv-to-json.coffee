#!/usr/bin/env coffee

# Excel to JSON Converter
# Converts Excel course definition to JSON format

fs = require "fs"
path = require "path"

# Simple CSV parser (for now, can be extended to use xlsx library)
parseCSV = (content) ->
  lines = content.split('\n')
  headers = lines[0].split(',').map (h) -> h.trim().replace(/^"|"$/g, '')
  
  rows = []
  for line in lines[1..]
    continue if line.trim() == ''
    
    # Handle quoted values
    values = []
    current = ''
    inQuotes = false
    
    for char in line
      if char == '"'
        inQuotes = !inQuotes
      else if char == ',' and !inQuotes
        values.push(current.trim())
        current = ''
      else
        current += char
    values.push(current.trim())
    
    row = {}
    for header, i in headers
      row[header] = values[i] || ''
    rows.push(row)
  
  { headers, rows }

# Convert CSV to JSON course format
csvToJSON = (csvPath) ->
  content = fs.readFileSync(csvPath, 'utf-8')
  { headers, rows } = parseCSV(content)
  
  course =
    meta: {}
    slides: []
  
  currentSlide = null
  
  for row in rows
    type = row['type'] || row['Type']
    
    # Handle meta row
    if type == 'meta'
      course.meta[row['key'] || row['Key']] = row['value'] || row['Value']
      continue
    
    # Handle slide rows
    if type
      # Save previous slide
      if currentSlide
        course.slides.push(currentSlide)
      
      # Start new slide
      currentSlide = { type: type }
      
      # Add common properties
      if row['title'] then currentSlide.title = row['title']
      if row['subtitle'] then currentSlide.subtitle = row['subtitle']
      if row['gradient'] then currentSlide.gradient = row['gradient']
      if row['number'] then currentSlide.number = row['number']
      if row['author'] then currentSlide.author = row['author']
      if row['quote'] then currentSlide.quote = row['quote']
      if row['columns'] then currentSlide.columns = parseInt(row['columns'])
      
      # Handle list items
      if type == 'list'
        currentSlide.items = []
        if row['items'] then currentSlide.items = row['items'].split('|').map (i) -> i.trim()
      
      # Handle cards
      if type == 'card'
        currentSlide.cards = []
        currentSlide.columns = currentSlide.columns || 2
      
      # Handle table
      if type == 'table'
        currentSlide.headers = []
        currentSlide.rows = []
        if row['headers'] then currentSlide.headers = row['headers'].split('|').map (h) -> h.trim()
      
      # Handle comparison
      if type == 'comparison'
        currentSlide.left = { title: '', items: [] }
        currentSlide.right = { title: '', items: [] }
      
      # Handle timeline
      if type == 'timeline'
        currentSlide.events = []
      
      # Handle charts
      if type == 'barChart' or type == 'pieChart'
        currentSlide.data = []
        if type == 'pieChart'
          currentSlide.labels = []
          currentSlide.values = []
    
    # Handle continuation rows (for multi-row content)
    else if currentSlide
      # Add list item
      if currentSlide.type == 'list' and row['item']
        currentSlide.items.push(row['item'])
      
      # Add card
      if currentSlide.type == 'card' and row['card_title']
        currentSlide.cards.push
          title: row['card_title']
          content: row['card_content'] || ''
          color: row['card_color'] || null
      
      # Add table row
      if currentSlide.type == 'table' and row['row']
        currentSlide.rows.push(row['row'].split('|').map (c) -> c.trim())
      
      # Add timeline event
      if currentSlide.type == 'timeline' and row['event_date']
        currentSlide.events.push
          date: row['event_date']
          title: row['event_title'] || ''
          desc: row['event_desc'] || ''
      
      # Add comparison items
      if currentSlide.type == 'comparison'
        if row['left_title'] then currentSlide.left.title = row['left_title']
        if row['right_title'] then currentSlide.right.title = row['right_title']
        if row['left_item'] then currentSlide.left.items.push(row['left_item'])
        if row['right_item'] then currentSlide.right.items.push(row['right_item'])
      
      # Add chart data
      if currentSlide.type == 'barChart' and row['chart_name']
        currentSlide.data.push
          name: row['chart_name']
          labels: (row['chart_labels'] || '').split('|').map (l) -> l.trim()
          values: (row['chart_values'] || '').split('|').map (v) -> parseFloat(v.trim())
      
      if currentSlide.type == 'pieChart'
        if row['chart_labels'] then currentSlide.labels = row['chart_labels'].split('|').map (l) -> l.trim()
        if row['chart_values'] then currentSlide.values = row['chart_values'].split('|').map (v) -> parseFloat(v.trim())
  
  # Save last slide
  if currentSlide
    course.slides.push(currentSlide)
  
  course

# Main
main = ->
  args = process.argv.slice(2)
  
  if args.length == 0
    console.log "Usage: coffee csv-to-json.coffee <input.csv> [output.json]"
    console.log ""
    console.log "CSV Format:"
    console.log "  type,title,subtitle,..."
    console.log "  meta,key,value,..."
    console.log "  title,医院管理总览,体系与趋势,..."
    console.log "  list,课程信息,,items"
    console.log "  ,,,item1|item2|item3"
    process.exit 0
  
  csvPath = args[0]
  outputPath = args[1] || csvPath.replace('.csv', '.json')
  
  unless fs.existsSync(csvPath)
    console.error "❌ CSV file not found: #{csvPath}"
    process.exit 1
  
  course = csvToJSON(csvPath)
  
  fs.writeFileSync(outputPath, JSON.stringify(course, null, 2))
  console.log "✅ Created: #{outputPath}"
  console.log "   Slides: #{course.slides.length}"

main()
