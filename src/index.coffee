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

exports.compile = compile = (source, options = {}) ->
  compile = require './compiler'
  ast = parse(source, options)
  code = compile(ast, options = {})

  """
  var reiny = require('reiny');
  var runtime = reiny.runtime;
  var xtend = reiny.xtend;
  module.exports = #{code};
  """

exports.print = (source, options = {}) ->
  beautify = require('js-beautify').js_beautify
  code = compile source, options
  console.log beautify(code, indent_size: 2)
