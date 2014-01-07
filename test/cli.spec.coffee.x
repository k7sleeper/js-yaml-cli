shell = require 'shelljs'
path = require 'path'
require 'jasmine-expect'

bin = "node #{path.join 'bin', 'yaml2json.js'}"

describe '$ yaml2json', () ->
  beforeEach () ->

  afterEach () ->

  it 'should fail if called without arguments', () ->
    prc = shell.exec bin + ''
    expect(prc.code).toBe 2
    expect(prc.output).toMatch 'error: too few arguments'
    expect(prc.output).toMatch 'usage:'

  describe 'should support option', () ->
    it '--help', () ->
      prc = shell.exec bin + ' --help', { silent: true }
      expect(prc.code).toBe 0
      expect(prc.output).toMatch 'usage:'
      expect(prc.output).toMatch '-h, --help'
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