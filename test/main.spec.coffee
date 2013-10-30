fs = require 'fs'
shell = require 'shelljs'
path = require 'path'
require 'jasmine-expect'

yaml2json = require('../lib').yaml2json
exitCodes = require '../lib/exit-codes'

TEST_DATA_ROOT_DIR = path.join 'test', 'data'
sample1 =
  yamlSourceFile: path.join TEST_DATA_ROOT_DIR, 'sample1.yaml'
  jsonTargetFile: path.join TEST_DATA_ROOT_DIR, 'sample1.json'
  expectedJsonFileContent: path.join TEST_DATA_ROOT_DIR, 'sample1.expected.json'
NOT_EXISTENT_FILE = path.join TEST_DATA_ROOT_DIR, 'not-existent-file.yaml'
INVALID_YAML_FILE = path.join TEST_DATA_ROOT_DIR, 'invalid-file.yaml'

describe 'yaml2json should work', () ->
  beforeEach () ->
    for fn in [sample1.jsonTargetFile]
      fs.unlink fn, (err) ->
        if err and err.code != 'ENOENT'
          console.error "Error removing file #{fn}!"
          console.error err.message or String err
  afterEach () ->

  it "and rc should be #{exitCodes.OK}", (done) ->
    yaml2json
      sourceFile: sample1.yamlSourceFile
    , (rc) ->
      expect(rc).toBe exitCodes.OK
      expect(fs.existsSync sample1.jsonTargetFile).toBe true
      done()

describe 'yaml2json should fail', () ->
  beforeEach () ->
  afterEach () ->

  it 'if source file does not exist', (done) ->
    yaml2json
      sourceFile: NOT_EXISTENT_FILE
    , (rc) ->
      expect(rc).toBe exitCodes.FILE_NOT_FOUND
      done()

  it 'if source file has syntax errors', (done) ->
    yaml2json
      sourceFile: INVALID_YAML_FILE
    , (rc) ->
      expect(rc).toBe exitCodes.YAML_PARSING_ERROR
      done()
