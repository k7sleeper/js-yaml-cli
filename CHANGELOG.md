# Changelog

## 0.4.0 - 2013-11-08
- removed command-line option `-j`. Correct JSON will be generated without having to specify a command-line option.
  Other formats may be generated using a command-line option, later.

## 0.3.0 - 2013-10-30
- added `"use strict"` to both scripts in `bin`
- supports reading YAML input from stdin

## 0.2.0 - 2013-10-30
- many fixes
- added command-line options `-r`, `-m`, `f`
- argument `SOURCE` may also be a directory and is optional
- improved help text
- improved documentation
- added `npm` `prepublish` script to compile `.coffee` files to `.js` ones

## 0.1.0 - 2013-10-29
- First public release
