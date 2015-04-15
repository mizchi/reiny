fs = require 'fs'
path = require 'path'
beautify = require('js-beautify').js_beautify

compile = require '../src/compiler'
parse = require '../src/parser'

# Run
source = fs.readFileSync(path.join __dirname, 'source.reiny').toString()
ast = parse(source)
code = compile(ast)

header = "global.React = require('react');\n"

code = beautify(code, indent_size: 2);
console.log header + beautify(code, indent_size: 2)
# console.log util.inspect ast, {depth: null}
