exports.xtend = require 'xtend'
exports.runtime = require 'coppe'

exports.parse = parse = (source) ->
  parse = require './parser'
  preprocess = require './preprocess'
  try
    return parse preprocess source
  catch e
    console.error e
    throw 'ast parse error'

wrapCodeWithExport = (code) ->
  """
  "use strict";
  var reiny = require('reiny');
  var __runtime = reiny.runtime;
  var __extend = reiny.xtend;
  module.exports = #{code};
  """

exports.compile = compile = (source, options = {}) ->
  compile = require './compiler'
  ast = parse(source, options)
  code = compile(ast, options = {})
  wrapCodeWithExport code

exports._compile = _compile = (ast, options = {}) ->
  compile = require './compiler'
  code = compile(ast, options = {})
  wrapCodeWithExport code

exports.print = (source, options = {}) ->
  beautify = require('js-beautify').js_beautify
  code = compile source, options
  console.log beautify(code, indent_size: 2)
