fs = require 'fs'
path = require 'path'
beautify = require('js-beautify').js_beautify

compile = require '../src/compiler'
parse = require '../src/parser'
preprocess = require '../src/preprocess'

# Run
{inspect} = require('util')

# source
source = fs.readFileSync(path.join __dirname, 'example.reiny').toString()
try
  ast = parse preprocess source
catch e
  console.error e
  throw 'ast parse error'

console.error(inspect ast, {depth: null});

code = compile(ast)

console.error """
global.React = require('react');
var runtime = require('coppe');
var xtend = require('xtend');
module.exports = #{beautify(code, indent_size: 2)}
console.log(React.renderToStaticMarkup(module.exports()));
"""

console.log """
global.React = require('react');
var runtime = require('coppe');
var xtend = require('xtend');
module.exports = #{beautify(code, indent_size: 2)}
console.log(React.renderToStaticMarkup(module.exports()));
"""
