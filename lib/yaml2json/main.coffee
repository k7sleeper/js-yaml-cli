fs = require 'fs'
util = require 'util'
path = require 'path'
readdirp = require 'readdirp'
yaml = require 'js-yaml'
_ = require 'lodash'
_s = require 'underscore.string'
exitCodes = require '../exit-codes'
console = (require '../utils/console')('yaml2json')

# -----------------------------------------------------------------------------

processYamlFile = (srcFile, destFile, options, cb) ->
  fs.readFile srcFile, {encoding: 'utf8'}, (error, input) ->
    if error
      console.error options.trace and error.stack or error.message or String error
      if cb then cb exitCodes.FILE_ACCESS_ERROR
      return

    fileName = path.basename srcFile
    processYamlString input, fileName, options, (rc, jsonString) ->
      if rc == exitCodes.OK
        fs.writeFileSync destFile, jsonString
      cb rc

# -----------------------------------------------------------------------------

processYamlString = (yamlString, fn, options, cb) ->
  # Boolean(fn) == true <=> source of yamlString is a file
  jsObjects = []
  yamlParserOptions = { strict: true}
  yamlParserOptions.filename = fn if fn
  try
    yaml.loadAll yamlString, ((jsObject) -> jsObjects.push(jsObject)), yamlParserOptions
    if 0 == jsObjects.length
      jsObjects = null
    else if 1 == jsObjects.length
      jsObjects = jsObjects[0]
  catch error
    if options.trace and error.stack
      console.error error.stack
    else
      console.error error.toString options.compact
    cb exitCodes.YAML_PARSING_ERROR
    return
  resultString = JSON.stringify jsObjects, null, '  '
  cb exitCodes.OK, resultString

# -----------------------------------------------------------------------------

doTheWork = (modArgs, cb) ->
  srcFile = modArgs.sourceFile

  callCb = (rc) -> if cb then _.defer cb, rc

  if _s.trim(srcFile) == '-'
    # read input from stdio and parse it as YAML input
    process.stdin.resume()
    process.stdin.setEncoding 'utf8'
    yamlInputString = ''
    process.stdin.on 'data', (chunk) ->
      yamlInputString += chunk
    process.stdin.on 'end', () ->
      processYamlString yamlInputString, null, modArgs, (rc, jsonString) ->
        if rc == exitCodes.OK
          process.stdout.write jsonString
        cb rc
  else
    try
      fstat = fs.statSync srcFile
    catch error
      if 'ENOENT' == error.code
        console.error "File not found: '#{srcFile}'"
        callCb exitCodes.FILE_NOT_FOUND
        return
      console.error modArgs.trace and error.stack or error.message or String error
      callCb exitCodes.FILE_ACCESS_ERROR
      return
    if fstat.isFile()
      destFile = path.join path.dirname(srcFile), path.basename(srcFile, path.extname(srcFile)) + '.json'
      processYamlFile srcFile, destFile, modArgs, callCb
    else if fstat.isDirectory()
      srcDir = srcFile
      fileStream = readdirp { root: srcDir, fileFilter: ['*.yaml', '*.yml'] }
      fileStream.on 'data', (entry) ->
        srcFile = path.join srcDir, entry.path
        destFile = path.join srcDir, entry.parentDir, path.basename(entry.name, path.extname(entry.name)) + '.json'
        processYamlFile srcFile, destFile, modArgs, (exitCode) ->
      # fileStream.on 'end', () -> if cb then cb exitCodes.OK
      fileStream.on 'close', () -> callCb exitCodes.OK
    else
      # this code should never be reached
      console.error ("Invalid file type of YAML source file! Given file '#{srcFile}'" +
                          " neither denotes a file nor a directory.")
      callCb exitCodes.FILE_ACCESS_ERROR
      return

module.exports = doTheWork
