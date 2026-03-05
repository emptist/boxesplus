# BoxesPlus - 日志系统
# 文件和控制台日志记录

fs = require "fs"
path = require "path"

class Logger
  @level: "info"
  @levels = {
    debug: 0
    info: 1
    warn: 2
    error: 3
  }
  @logFile: "logs/boxesplus.log"
  @enableFile: true
  @enableConsole: true

  @setLevel: (level) ->
    @level = level

  @setLogFile: (filePath) ->
    @logFile = filePath

  @shouldLog: (level) ->
    @levels[level] >= @levels[@level]

  @format: (level, message, data) ->
    timestamp = new Date().toISOString()
    dataStr = if data then " " + JSON.stringify(data) else ""
    "[#{timestamp}] [#{level.toUpperCase()}] #{message}#{dataStr}"

  @log: (level, message, data = {}) ->
    return unless @shouldLog(level)
    
    formatted = @format(level, message, data)
    
    if @enableConsole
      switch level
        when "debug" then console.log formatted
        when "info" then console.log formatted
        when "warn" then console.warn formatted
        when "error" then console.error formatted
    
    if @enableFile
      @writeToFile(formatted)

  @writeToFile: (message) ->
    try
      dir = path.dirname(@logFile)
      fs.mkdirSync(dir, { recursive: true }) unless fs.existsSync(dir)
      fs.appendFileSync(@logFile, message + "\n")
    catch e
      console.error "Failed to write to log file:", e.message

  @debug: (message, data) -> @log("debug", message, data)
  @info: (message, data) -> @log("info", message, data)
  @warn: (message, data) -> @log("warn", message, data)
  @error: (message, data) -> @log("error", message, data)

class ErrorLogger extends Logger
  @errors: []
  @maxErrors: 100

  @logError: (error, context = {}) ->
    errorInfo = {
      name: error.name
      message: error.message
      stack: error.stack
      timestamp: new Date().toISOString()
      context: context
    }
    
    @errors.push(errorInfo)
    @errors = @errors.slice(-@maxErrors) if @errors.length > @maxErrors
    
    @error("Error occurred: #{error.message}", context)

  @getErrors: (filter = {}) ->
    errors = @errors
    
    if filter.name
      errors = errors.filter (e) -> e.name is filter.name
    
    if filter.since
      since = new Date(filter.since)
      errors = errors.filter (e) -> new Date(e.timestamp) > since
    
    errors

  @clearErrors: -> @errors = []

  @getErrorSummary: ->
    summary = {}
    for error in @errors
      name = error.name
      summary[name] = (summary[name] or 0) + 1
    summary

class AuditLogger
  @logs: []
  @logFile: "logs/audit.log"

  @log: (action, details = {}) ->
    entry = {
      action: action
      timestamp: new Date().toISOString()
      user: details.user or "system"
      details: details
    }
    
    @logs.push(entry)
    
    try
      fs.appendFileSync(@logFile, JSON.stringify(entry) + "\n")
    catch e
      console.error "Audit log write failed:", e.message

  @getLogs: (filter = {}) ->
    logs = @logs
    
    if filter.action
      logs = logs.filter (l) -> l.action is filter.action
    
    if filter.since
      since = new Date(filter.since)
      logs = logs.filter (l) -> new Date(l.timestamp) > since
    
    logs

module.exports = { Logger, ErrorLogger, AuditLogger }
