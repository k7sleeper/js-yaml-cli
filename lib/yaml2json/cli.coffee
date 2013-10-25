ArgumentParser = require('argparse').ArgumentParser
xUtils = require '../utils'

pkg = xUtils.pkg

cli = new ArgumentParser
  prog:     'yaml2json'
  description: 'Parse a given YAML file, serialize it to JavaScript and store it as JSON file.'
  epilog: 'The resulting JavaScript object is stored in a .json file in the same directory as the source file.'
  version:  pkg.version
  addHelp:  true

cli.addArgument ['-V', '--verbose'],
  help:   'allow verbose output'
  action: 'storeTrue'

cli.addArgument ['-q', '--quiet', '--silent'],
  help:   'be quiet'
  action: 'storeTrue'

cli.addArgument ['-c', '--compact'],
  help:   'display errors in compact mode'
  action: 'storeTrue'

cli.addArgument ['-j', '--to-json'],
  help:   'output a non-funky boring JSON'
  dest:   'json'
  action: 'storeTrue'

cli.addArgument ['-o', '--output'],
  help:   'set the output file path for resulting JSON file'
  nargs:  1

cli.addArgument ['-e', '--encoding'],
  help:   'use encoding ENC for reading the the YAML source file. Allowed values are:'
  nargs:  1
  metavar: 'ENC'

cli.addArgument ['-d', '--directory'],
  help:   'set the output directory for resulting JSON file'
  nargs:  1

cli.addArgument ['-s', '--stdio'],
  help:   'listen for and process file over stdio'
  action: 'storeTrue'

cli.addArgument ['-t', '--trace'],
  help:   'show stack trace on error'
  action: 'storeTrue'

cli.addArgument ['file'],
  help: "YAML File to process, UTF-8 encoded, without BOM. Input file encoding can be changed using option -e."

module.exports = cli.parseArgs()

