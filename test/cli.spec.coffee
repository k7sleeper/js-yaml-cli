shell = require 'shelljs'
path = require 'path'
require 'jasmine-expect'

bin = 'node ' + path.join 'bin', 'yaml2json.js'

describe '$ yaml2json', () ->
  beforeEach () ->
    spyOn process.stdout, 'write'

  afterEach () ->

  it 'should fail if called without arguments', () ->
    process = shell.exec bin + '', { silent: true }
    expect(process.code).toBe 2
    expect(process.output).toMatch 'error: too few arguments'
    expect(process.output).toMatch 'usage:'

  describe 'should support option', () ->
    it '--help', () ->
      process = shell.exec bin + ' --help', { silent: true }
      expect(process.code).toBe 0
      expect(process.output).toMatch 'usage:'
      expect(process.output).toMatch '-h, --help'
    it '-h', () ->
      process = shell.exec bin + ' -h', { silent: true }
      expect(process.code).toBe 0
      expect(process.output).toMatch 'usage:'
      expect(process.output).toMatch '-h, --help'
    it '--version', () ->
      process = shell.exec bin + ' --version', { silent: true }
      expect(process.code).toBe 0
      expect(process.output).toMatch /^\w+\.\w+\.\w+/
    it '-v', () ->
      process = shell.exec bin + ' -v', { silent: true }
      expect(process.code).toBe 0
      expect(process.output).toMatch /^\w+\.\w+\.\w+/