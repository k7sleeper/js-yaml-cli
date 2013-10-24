fs = require 'fs'
util = require 'util'
path = require 'path'
yamlParser = require 'js-yaml'

cli = require './impl/yaml2json/args'

options = cli.process()

srcFile = options.file
destFile = path.join path.dirname(srcFile), path.basename(srcFile, path.extname(srcFile)) + '.json'

# /////////////////////////////////////////////////////////////////////////////

fs.readFile srcFile, {encoding: 'utf8'}, (error, input) ->
  if error
    if 'ENOENT' == error.code
      console.error "File not found: #{srcFile}"
      process.exit 2

    console.error options.trace and error.stack or error.message or String error
    process.exit 1

  try
    jsObjects = []
    yamlParser.loadAll input, ((jsObject) -> jsObjects.push(jsObject)), {}

    if 0 == jsObjects.length
      output = null
    else if 1 == output.length
      output = output[0]
  catch error
    if options.trace and error.stack
      console.error error.stack
    else
      console.error error.toString options.compact
    process.exit 1

  if options.json
    resultString = JSON.stringify output, null, '  '
  else
    resultString = "\n" + util.inspect(output, false, 10, true) + "\n"
  fs.writeFileSync destFile, resultString

  process.exit 0