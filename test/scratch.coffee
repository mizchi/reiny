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

# source
source = fs.readFileSync(path.join __dirname, 'for.reiny').toString()
ast = parse(source)

console.error(inspect ast, {depth: null});

code = compile(ast)

console.error """
global.React = require('react');
var runtime = require('coppe');
module.exports = #{beautify(code, indent_size: 2)}
console.log(React.renderToStaticMarkup(module.exports()));
"""

console.log """
global.React = require('react');
var runtime = require('coppe');
module.exports = #{beautify(code, indent_size: 2)}
console.log(React.renderToStaticMarkup(module.exports()));
"""
