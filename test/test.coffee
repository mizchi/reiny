fs = require 'fs'
path = require 'path'
reiny = require('../src/index')
{inspect} = require('util')
esprima = require('esprima')

# Try to parse
list = [
  'classname'
  'code'
  'embeded-code'
  'example'
  'for'
  'indent'
  'mergeable-object'
  'text'
]

for i in list
  source = fs.readFileSync(path.join __dirname, "fixtures/#{i}.reiny").toString()
  try
    ast = reiny.parse(source)
    try
      compiled = reiny._compile ast
      Function compiled
    catch e
      console.error e
      throw i + ' invalid output'

  catch e
    console.error e
    throw i + ' parse failed'

# console.log 'args',
if target = process.argv[3] ? process.argv[2]
  console.error 'exec', target
  source = fs.readFileSync(path.join process.cwd(), target).toString()

  ast = reiny.parse(source)
  console.error inspect ast, depth: null # show ast
  console.log reiny._compile(ast) # show code
