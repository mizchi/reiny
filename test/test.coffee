fs = require 'fs'
path = require 'path'
reiny = require('../src/index')
{inspect} = require('util')

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

for i in list
  source = fs.readFileSync(path.join __dirname, "fixtures/#{i}.reiny").toString()
  try
    ast = reiny.parse(source)
    try
      compiled = reiny._compile ast
      Function compiled
    catch e
      console.error i + ' invalid output'
      console.error e
      process.exit(1)

  catch e
    console.error e
    throw i + ' parse failed'

# exec
execTemp = (code) ->
  global.React = require('react')
  eval(code
    .replace("module.exports", "global.__tmp")
    .replace("require('reiny/runtime')", "require('../src/runtime')")
  )
  c = React.createClass
    propTypes: __tmp.propTypes ? {}
    render: -> __tmp()
  console.error React.renderToStaticMarkup React.createElement(c, {})

if target = process.argv[3] ? process.argv[2]
  console.error 'exec', target

  source = fs.readFileSync(path.join process.cwd(), target).toString()
  ast = null
  try
    ast = reiny.parse(source)
  catch e
    formatter = require('../src/format-error.coffee')
    throw new Error (formatter source, e)

  console.error inspect ast, depth: null # show ast
  code = reiny._compile(ast)
  console.log code # show code
  # execTemp(code)
