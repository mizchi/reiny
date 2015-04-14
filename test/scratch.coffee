fs = require 'fs'
path = require 'path'
beautify = require('js-beautify').js_beautify

compile = require '../src/compiler'
parse = require '../src/parser'

# Run
source = fs.readFileSync(path.join __dirname, 'source.reiny').toString()
ast = parse(source)
code = compile(ast)

console.log beautify(code, indent_size: 2)
# console.log util.inspect ast, {depth: null}
