
yaml2json = (pgmArgs) ->
  impl = require './yaml2json/main'
  impl pgmArgs

json2yaml = (pgmArgs) ->
  json2yaml = require './json2yaml/main'
  json2yaml pgmArgs

module.exports = {
  yaml2json
  json2yaml
}