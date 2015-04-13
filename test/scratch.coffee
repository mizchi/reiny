PEG = require 'pegjs'
coffee = require 'pegjs-coffee-plugin'

# Define your grammar
fs = require 'fs'
path = require 'path'
grammar = fs.readFileSync(path.join __dirname, '../src/reiny.pegcoffee').toString()
source = fs.readFileSync(path.join __dirname, 'source.reiny').toString()

# Run
parser = PEG.buildParser grammar, plugins: [coffee]
util = require 'util'

# console.log util.inspect parser.parse source, false, null
console.log util.inspect (parser.parse source), {depth: null}
