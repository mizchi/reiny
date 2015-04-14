PEG = require 'pegjs'
coffee = require 'pegjs-coffee-plugin'
path = require 'path'
fs = require 'fs'

# Run
grammar = fs.readFileSync(path.join __dirname, 'grammar.pegcoffee').toString()
parser = PEG.buildParser grammar, plugins: [coffee]
util = require 'util'

module.exports = parse = (src) ->
  parser.parse src
