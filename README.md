JavaScript YAML Command-line Utilities
======================================

Command-line utilities to convert [YAML](http://yaml.org/) files to JSON files and vice versa.

js-yaml-cli is based on [js-yaml](http://github.com/nodeca/js-yaml)
and provides a more sophisticated command-line interface 
than that one [js-yaml](http://github.com/nodeca/js-yaml) comes along with. js-yaml-cli can be used, for example, to
set-up a [WebStorm](http://www.jetbrains.com/webstorm) file watcher for YAML files.

Currently, js-yaml-cli depends on [js-yaml](http://github.com/nodeca/js-yaml) 2.1.3.

The scripts of js-yaml-cli run under [Node.js](http://nodejs.org/).

## Installation

js-yaml-cli depends on [Node.js](http://nodejs.org/) and [npm](http://npmjs.org/). It's
installed globally using npm:

```
npm install -g js-yaml-cli
```

If you want you can install js-yaml-cli locally (type `npm install js-yaml-cli` in the project directory you want)
but a global installation is the recommended way.

Once installed, you should have access to the commands `yaml2json` and `json2yaml`.

## Usage

### YAML to JSON

`yaml2json -h` shows:

~~~
usage: yaml2json [-h] [-v] [-V] [-q] [-c] [-m] [-f] [-o OUTPUT] [-e ENC]
                 [-d DIRECTORY] [-r] [-t]
                 [SOURCE]

Parse a given YAML file, serialize it to JavaScript and store it as JSON file.

Positional arguments:
  SOURCE                YAML file to process, UTF-8 encoded, without BOM.
                        Input file encoding can be changed using option -e.
                        If SOURCE denotes a directory all .YAML and .YML
                        files in that directory are parsed and serialized to
                        JSON. If option -r is specified all files in all
                        subdirectories are processed, also. If argument
                        SOURCE is not present then yaml2json listens for and
                        processes input over stdio. Output is then written to
                        stdout. In this case, the program works in quiet mode.
                         Nothing else than user data is written to stdout.
                        Only errors are written to stderr.

Optional arguments:
  -h, --help            Show this help message and exit.
  -v, --version         Show program's version number and exit.
  -V, --verbose         print extra information per each processed file
  -q, --quiet, --silent
                        be extra quiet
  -c, --compact         display errors in compact mode
  -m, --force-multiple  by default each YAML input file is handled as if it
                        contains multiple documents. Therefore, the resulting
                        JSON file contains an array of these documents. If a
                        YAML source file contains only one document, it's not
                        stored as an array with one element but directly,
                        without the enclosing array. Option -m can be used to
                        force storing single-document YAML file as an array
                        with one element. This option may be usefull if the
                        source file may contain a single document which is an
                        array.
  -f, --fail-fast       fail as soon as an error occurs when processing
                        multiple files (SOURCE is a directory)
  -o OUTPUT, --output OUTPUT
                        set the file path for the resulting JSON file
  -e ENC, --encoding ENC
                        use encoding ENC for reading the YAML source file.
                        Allowed values are: 'hex', 'utf8', 'utf-8', 'ascii',
                        'binary', 'base64', 'ucs2' 'ucs-2', 'utf16le',
                        'utf-16le'
  -d DIRECTORY, --directory DIRECTORY
                        set the output directory for resulting JSON file
  -r, --recurse         recurse into directories if SOURCE denotes a directory
  -t, --trace           show stack trace on error

The resulting JavaScript object is stored in a .json file in the same directory as the source file.
~~~

### JSON to YAML

`json2yaml -h` shows:

## History

See [CHANGELOG](/CHANGELOG.md)
