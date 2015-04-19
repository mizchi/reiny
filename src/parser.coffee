PEG = require 'pegjs'
coffee = require 'pegjs-coffee-plugin'
path = require 'path'
fs = require 'fs'

# Run
grammarFiles = [
  'grammars/_entry.pegcoffee'
  'grammars/statement.pegcoffee'
  'grammars/expression.pegcoffee'
  'grammars/primitive.pegcoffee'
]

getGrammarSource = ->
  grammarFiles
    .map (fname) ->
      fs.readFileSync(path.join __dirname, fname).toString()
    .join('\n')

grammar = getGrammarSource()
parser = PEG.buildParser grammar, plugins: [coffee]

module.exports = parse = (src) ->
  parser.parse src
