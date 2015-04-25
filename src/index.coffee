{js_beautify} = require('js-beautify')

# string => AST
exports.parse = parse = (source, options = {}) ->
  parse = require '../parser'
  preprocess = require './preprocess'
  try
    preprocessed = preprocess source
    return parse preprocessed, options
  catch e
    console.error e
    throw 'ast parse error'

# AST => string
exports._compile = _compile = (ast, options = {}) ->
  compile = require './compiler'
  js_beautify(compile(ast, options))

# string => string
exports.compile = (source, options = {}) ->
  ast = parse(source, options)
  _compile(ast, options)
