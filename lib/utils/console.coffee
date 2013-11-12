colors = require 'colors'

toExport = {}

scriptName = undefined

###
 Console Log.

 Passes the parameters to `console.log`.

 Outputs:

     $ [phonegap] message
###
toExport.log = () ->
  args = Array::slice.call arguments
  args.unshift "[#{scriptName}]".cyan
  console.log.apply @, args

###
Console Warning.

Passes the parameters to `console.warn`.

Outputs:

    $ [warning] message
###
toExport.warn = () ->
  args = Array::slice.call arguments
  args.unshift ' [warning]'.yellow
  console.log.apply @, args

###
Console Error.

Passes the parameters to `console.error`.

Outputs:

    $ [error] message
###
toExport.error = () ->
  args = Array::slice.call arguments
  args.unshift '   [error]'.red
  console.log.apply @, args

###
RAW Console Log.

Passes the parameters to `console.log` with no prefix.

Outputs:

    $ message
###
toExport.raw = () ->
  args = Array::slice.call arguments
  console.log.apply @, args

# -----------------------------------------------------------------------------

module.exports = ($scriptName) ->
  if not $scriptName then throw new Error "Missing argument 'scriptName'!"
  scriptName = $scriptName
  toExport

# -----------------------------------------------------------------------------

if require.main == module
  console.error "#{module.filename} must not be the main module!"
  console.info "#{module.filename} is an implementation module only!"
