# BoxesPlus - 扩展错误类型
# 特定领域的错误类

class BoxesError extends Error
  constructor: (message, details = {}) ->
    super message
    @name = "BoxesError"
    @details = details
    @timestamp = new Date().toISOString()

class NetworkError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "NetworkError"
    @statusCode = details.statusCode
    @url = details.url

class FileError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "FileError"
    @filePath = details.filePath
    @operation = details.operation

class ParseError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "ParseError"
    @line = details.line
    @column = details.column

class ValidationError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "ValidationError"
    @field = details.field
    @value = details.value

class TemplateError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "TemplateError"
    @templateName = details.templateName

class RenderError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "RenderError"
    @slideIndex = details.slideIndex

class ExportError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "ExportError"
    @format = details.format
    @outputPath = details.outputPath

class ConfigError extends BoxesError
  constructor: (message, details = {}) ->
    super message, details
    @name = "ConfigError"
    @configKey = details.configKey

Errors = {
  BoxesError
  NetworkError
  FileError
  ParseError
  ValidationError
  TemplateError
  RenderError
  ExportError
  ConfigError
}

module.exports = Errors
