
yaml2json = (pgmArgs, cb) ->
  impl = require './yaml2json/main'
  impl pgmArgs, cb

json2yaml = (pgmArgs, cb) ->
  json2yaml = require './json2yaml/main'
  json2yaml pgmArgs, cb

module.exports = {
  yaml2json
  json2yaml
}