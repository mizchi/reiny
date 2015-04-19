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

print = (source, options = {}) ->
  beautify = require('js-beautify').js_beautify
  code = reiny.compile source, options
  console.log beautify(code, indent_size: 2)

sourcePath = 'fixtures/text'
source = fs.readFileSync(path.join __dirname, sourcePath+'.reiny').toString()
# print(source)

console.error inspect reiny.parse(source), depth: null
ast = reiny.parse(source)
console.log reiny._compile(ast)
