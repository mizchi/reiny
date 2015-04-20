fs = require 'fs'
path = require 'path'
reiny = require('../src/index')
{inspect} = require('util')
esprima = require('esprima')

# Try to parse
list = [
  'classname'
  'code'
  'comment'
  'custom-element'
  'direct-element'
  'embeded-code'
  'example'
  'for'
  'if'
  'header'
  'identifier'
  'prop-types'
  # 'inline-expr'
  'indent'
  'modifiers'
  'style'
  'mergeable-object'
  'text'
]

if target = process.argv[3] ? process.argv[2]
  styleCompile = require '../src/style-compiler'

  # exec
  console.error 'exec', target

  source = fs.readFileSync(path.join process.cwd(), target).toString()
  ast = reiny.parse(source)
  console.error inspect ast, depth: null # show ast
  code = styleCompile(ast) # show code
  console.log code
  # execTemp()
