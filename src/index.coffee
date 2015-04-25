{js_beautify} = require('js-beautify')
compile = require './compiler'

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
  code = compile(ast, options)
  js_beautify code

# string => string
exports.compile = compile = (source, options = {}) ->
  ast = parse(source, options)
  _compile(source, options)
