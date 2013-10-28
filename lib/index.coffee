
yaml2json = (pgmArgs) ->
  yaml2json = require '.yaml2json/main'
  yaml2json pgmArgs

json2yaml = (pgmArgs) ->
  json2yaml = require '.json2yaml/main'
  json2yaml pgmArgs

module.exports = {
  yaml2json
  json2yaml
}