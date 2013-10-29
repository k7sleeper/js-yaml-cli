fs = require 'fs'
util = require 'util'
path = require 'path'
yaml = require 'js-yaml'
exitCodes = require '../exit-codes'

doTheWork = (modArgs, cb) ->
  srcFile = modArgs.file
  destFile = path.join path.dirname(srcFile), path.basename(srcFile, path.extname(srcFile)) + '.json'

  fs.readFile srcFile, {encoding: 'utf8'}, (error, input) ->
    if error
      if 'ENOENT' == error.code
        console.error "File not found: #{srcFile}"
        cb exitCodes.FILE_NOT_FOUND

      console.error modArgs.trace and error.stack or error.message or String error
      cb exitCodes.FILE_ACCESS_ERROR

    try
      output = JSON.parse input
      isYaml = false
    catch error
      if error instanceof SyntaxError
        try
          output = []
          yaml.loadAll input, ((doc) -> output.push(doc)), {}
          isYaml = true;

          if 0 == output.length
            output = null
          else if 1 == output.length
            output = output[0]
        catch error
          if modArgs.trace and error.stack
            console.error error.stack
          else
            console.error error.toString modArgs.compact

        cb exitCodes.JSON_PARSING_ERROR
      else
        console.error modArgs.trace and error.stack or error.message or String error
        cb exitCodes.JSON_PARSING_ERROR

    if isYaml
      if modArgs.json
        resultString = JSON.stringify output, null, '  '
      else
        resultString = "\n" + util.inspect(output, false, 10, true) + "\n"
      fs.writeFileSync destFile, resultString
      cb exitCodes.OK
    else
      console.log yaml.dump(output)

module.exports = doTheWork
