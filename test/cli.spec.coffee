shell = require 'shelljs'
path = require 'path'
bin = 'node ' + path.resolve path.join __dirname, '..', 'bin', 'phonegap.js'

describe '$ phonegap [options] commands', () ->
  beforeEach () ->
    spyOn process.stdout, 'write'

  it 'should support no arguments', () ->
    process = shell.exec bin + '', { silent: true }
    expect(process.output).toMatch('Usage:')

  it 'should support commands', () ->
    process = shell.exec bin + ' version', { silent: true }
    expect(process.output).toMatch /^\w+\.\w+\.\w+/

  it 'should support options', () ->
    process = shell.exec bin + ' --version', { silent: true }
    expect(process.output).toMatch /^\w+\.\w+\.\w+/