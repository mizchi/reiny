fs = require 'fs'
path = require 'path'
reiny = require('../src/index')
{inspect} = require('util')

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
    reiny.parse(source)
  catch e
    throw i + ':' + 'parse failed'

print = (source, options = {}) ->
  beautify = require('js-beautify').js_beautify
  code = compile source, options
  console.log beautify(code, indent_size: 2)

source = fs.readFileSync(path.join __dirname, 'fixtures/example.reiny').toString()
print(source)
# console.error inspect reiny.parse(source), depth: null
# ast = reiny.parse(source)
# console.log reiny._compile(ast)
