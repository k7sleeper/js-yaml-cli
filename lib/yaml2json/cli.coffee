ArgumentParser = require('argparse').ArgumentParser
xUtils = require '../utils'

pkg = xUtils.pkg

cli = new ArgumentParser
  prog       : 'yaml2json'
  description: 'Parse a given YAML file, serialize it to JavaScript and store it as JSON file.'
  epilog     : 'The resulting JavaScript object is stored in a .json file in the same directory as the source file.'
  version    :  pkg.version
  addHelp    :  true

cli.addArgument ['-V', '--verbose'],
  help:   'print extra information per each processed file'
  action: 'storeTrue'

cli.addArgument ['-q', '--quiet', '--silent'],
  help:   'be extra quiet'
  action: 'storeTrue'

cli.addArgument ['-c', '--compact'],
  help:   'display errors in compact mode'
  action: 'storeTrue'

cli.addArgument ['-m', '--force-multiple'],
  help:   """by default each YAML input file is handled as if it contains multiple documents.
             Therefore, the resulting JSON file contains an array of these documents.
             If a YAML source file contains only one document, it's not stored as an array with one element but
             directly, without the enclosing array.
             Option -m can be used to force storing single-document YAML file as an array with one element.
             This option may be usefull if the source file may contain a single document which is an array.
          """
  dest:   'forceMultipleDocuments'
  action: 'storeTrue'

cli.addArgument ['-f', '--fail-fast'],
  help:   'fail as soon as an error occurs when processing multiple files (SOURCE is a directory)'
  dest:   'failFast'
  action: 'storeTrue'

cli.addArgument ['-o', '--output'],
  help:   'set the file path for the resulting JSON file'
  nargs:  1

cli.addArgument ['-e', '--encoding'],
  help:   """use encoding ENC for reading the YAML source file. Allowed values are:
             'hex', 'utf8', 'utf-8', 'ascii', 'binary', 'base64', 'ucs2'
             'ucs-2', 'utf16le', 'utf-16le'
          """
  nargs:  1
  metavar: 'ENC'

cli.addArgument ['-d', '--directory'],
  help:   'set the output directory for resulting JSON file'
  nargs:  1

cli.addArgument ['-r', '--recurse'],
  help:   'recurse into directories if SOURCE denotes a directory'
  action: 'storeTrue'

cli.addArgument ['-t', '--trace'],
  help:   'show stack trace on error'
  action: 'storeTrue'

cli.addArgument ['sourceFile'],
  metavar: 'SOURCE'
  help: """YAML file to process, UTF-8 encoded, without BOM.
          Input file encoding can be changed using option -e.
          If SOURCE denotes a directory all .YAML and .YML files in that directory
          are parsed and serialized to JSON.
          If option -r is specified all files in all subdirectories are processed, also.
          If argument SOURCE is not present then yaml2json listens for and processes input over stdio.
          Output is then written to stdout. In this case, the program works in quiet mode. Nothing else than
          user data is written to stdout. Only errors are written to stderr.
        """
  nargs: '?'
  defaultValue: '-'

module.exports = cli.parseArgs()