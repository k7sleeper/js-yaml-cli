fs = require 'fs'
util = require 'util'
path = require 'path'
yaml = require 'js-yaml'
_ = require 'lodash'
exitCodes = require '../exit-codes'

doTheWork = (modArgs, cb) ->
  srcFile = modArgs.file
  destFile = path.join path.dirname(srcFile), path.basename(srcFile, path.extname(srcFile)) + '.json'

  fs.readFile srcFile, {encoding: 'utf8'}, (error, input) ->
    if error
      if 'ENOENT' == error.code
        console.error "File not found: #{srcFile}"
        cb exitCodes.FILE_NOT_FOUND if cb
        return
      console.error modArgs.trace and error.stack or error.message or String error
      cb exitCodes.FILE_ACCESS_ERROR if cb
      return

    fileName = path.basename srcFile
    try
      jsObjects = []
      res = yaml.loadAll input, ((jsObject) -> jsObjects.push(jsObject)), { filename: fileName, strict: true}
      if 0 == jsObjects.length
        jsObjects = null
      else if 1 == jsObjects.length
        jsObjects = jsObjects[0]
    catch error
      if modArgs.trace and error.stack
        console.error error.stack
      else
        console.error error.toString modArgs.compact
      cb exitCodes.YAML_PARSING_ERROR if cb
      return

    if modArgs.json
      resultString = JSON.stringify jsObjects, null, '  '
    else
      resultString = "\n" + util.inspect(jsObjects, false, 10, true) + "\n"
    fs.writeFileSync destFile, resultString

    cb exitCodes.OK if cb
    return

module.exports = doTheWork
