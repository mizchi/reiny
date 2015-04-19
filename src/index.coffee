exports.parse = parse = (source) ->
  parse = require '../parser'
  preprocess = require './preprocess'
  try
    return parse preprocess source
  catch e
    console.error e
    throw 'ast parse error'

wrapCodeWithExport = (code) ->
  """
  "use strict";
  var reiny = require('reiny/runtime');
  var __runtime = reiny.runtime;
  var __extend = reiny.xtend;
  module.exports = #{code};
  """

beautify = require('js-beautify').js_beautify

exports.compile = compile = (source, options = {}) ->
  compile = require './compiler'
  ast = parse(source, options)
  code = compile(ast, options = {})
  beautify wrapCodeWithExport code

exports._compile = _compile = (ast, options = {}) ->
  compile = require './compiler'
  code = compile(ast, options = {})
  beautify wrapCodeWithExport code
