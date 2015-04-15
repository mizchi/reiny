fs = require 'fs'
path = require 'path'
beautify = require('js-beautify').js_beautify

compile = require '../src/compiler'
parse = require '../src/parser'

# Run
{inspect} = require('util')
# indent
# source = fs.readFileSync(path.join __dirname, 'indent.reiny').toString()
# ast = parse(source)
#
# console.log(inspect ast, {depth: null});

# source
source = fs.readFileSync(path.join __dirname, 'source.reiny').toString()
ast = parse(source)

console.log(inspect ast, {depth: null});

code = compile(ast)

pre = "global.React = require('react');\n"
post = ""

code = beautify(code, indent_size: 2);
console.log pre + beautify(code, indent_size: 2) + post
# console.log util.inspect ast, {depth: null}
