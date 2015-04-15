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

# console.log(inspect ast, {depth: null});

code = compile(ast)

console.log """
global.React = require('react');
var runtime = require('coppe');
module.exports = #{beautify(code, indent_size: 2)}
console.log(React.renderToStaticMarkup(module.exports()));
"""
