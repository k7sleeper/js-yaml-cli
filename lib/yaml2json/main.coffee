fs = require 'fs'
util = require 'util'
path = require 'path'
readdirp = require 'readdirp'
yaml = require 'js-yaml'
_ = require 'lodash'
_s = require 'underscore.string'
exitCodes = require '../exit-codes'

# -----------------------------------------------------------------------------

processYamlFile = (srcFile, destFile, options, cb) ->
  fs.readFile srcFile, {encoding: 'utf8'}, (error, input) ->
    if error
      console.error options.trace and error.stack or error.message or String error
      if cb then cb exitCodes.FILE_ACCESS_ERROR
      return

    fileName = path.basename srcFile
    try
      jsObjects = []
      res = yaml.loadAll input, ((jsObject) ->
        jsObjects.push(jsObject)), { filename: fileName, strict: true}
      if 0 == jsObjects.length
        jsObjects = null
      else if 1 == jsObjects.length
        jsObjects = jsObjects[0]
    catch error
      if options.trace and error.stack
        console.error error.stack
      else
        console.error error.toString options.compact
      cb exitCodes.YAML_PARSING_ERROR if cb
      return

    if options.json
      resultString = JSON.stringify jsObjects, null, '  '
    else
      resultString = "\n" + util.inspect(jsObjects, false, 10, true) + "\n"
    fs.writeFileSync destFile, resultString

    if cb then cb exitCodes.OK
    return

# -----------------------------------------------------------------------------

doTheWork = (modArgs, cb) ->
  srcFile = modArgs.sourceFile

  callCb = (rc) -> if cb then _.defer cb, rc

  if _s.trim(srcFile) == '-'
    # handle input over stdio
  else
    try
      fstat = fs.statSync srcFile
    catch error
      if 'ENOENT' == error.code
        console.error "File not found: #{srcFile}"
        callCb exitCodes.FILE_NOT_FOUND
        return
      console.error modArgs.trace and error.stack or error.message or String error
      callCb exitCodes.FILE_ACCESS_ERROR
      return
    if fstat.isFile()
      destFile = path.join path.dirname(srcFile), path.basename(srcFile, path.extname(srcFile)) + '.json'
      processYamlFile srcFile, destFile, modArgs, cb
    else if fstat.isDirectory()
      srcDir = srcFile
      fileStream = readdirp { root: srcDir, fileFilter: ['*.yaml', '*.yml'] }
      fileStream.on 'data', (entry) ->
        srcFile = path.join srcDir, entry.path
        destFile = path.join srcDir, entry.parentDir, path.basename(entry.name, path.extname(entry.name)) + '.json'
        processYamlFile srcFile, destFile, modArgs, (exitCode) ->
      # fileStream.on 'end', () -> if cb then cb exitCodes.OK
      fileStream.on 'close', () -> if cb then cb exitCodes.OK
    else
      console.error "Invalid file type of YAML source file! Given file '#{srcFile}' neither denotes a file nor a directory."
      callCb exitCodes.FILE_ACCESS_ERROR
      return

module.exports = doTheWork
