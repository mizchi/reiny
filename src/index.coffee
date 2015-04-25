{js_beautify} = require('js-beautify')
PEG = require 'pegjs'
coffee = require 'pegjs-coffee-plugin'
fs = require 'fs'
path = require 'path'

# Run
grammarFiles = [
  '../grammars/_entry.pegcoffee'
  '../grammars/statement.pegcoffee'
  '../grammars/expression.pegcoffee'
  '../grammars/primitive.pegcoffee'
]

getGrammarSource = ->
  grammarFiles
    .map((fname) ->
      fs.readFileSync(path.join __dirname, fname).toString()
    )
    .join('\n')

grammar = getGrammarSource()
parser = PEG.buildParser grammar, plugins: [coffee]

# string => AST
exports.parse = parse = (source, options = {}) ->
  preprocess = require './preprocess'
  preprocessed = preprocess source
  try
    return parser.parse preprocessed, options
  catch e
    formatter = require('./format-error')
    throw new Error (formatter source, e)

# AST => string
exports._compile = _compile = (ast, options = {}) ->
  compile = require './compiler'
  js_beautify(compile(ast, options))

# string => string
exports.compile = (source, options = {}) ->
  ast = parse(source, options)
  _compile(ast, options)
