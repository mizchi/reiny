reiny = require('../lib/index')
beautify = require('js-beautify').js_beautify
{inspect} = require('util')
path = require('path')
fs =require('fs')

argv = require('minimist')(process.argv.slice(2))

printBeautifiedCode = (source, options = {}) ->
  code = reiny.compile source, options
  beautify(code, indent_size: 2)

printAst = (source, options = {}) ->
  code = reiny.parse source, options
  inspect code, depth: null

[target] = argv._

run = (target, argv) ->
  targetPath = path.join process.cwd(), target
  source = fs.readFileSync(targetPath).toString()

  code = printBeautifiedCode(source, argv)
  # TODO: auto generate filename by extname
  if argv.out or argv.o
    outputPath = path.join process.cwd(), argv.out
    fs.writeFileSync(outputPath, code)
    console.log 'write js'
  else
    console.log code

run(argv._[0], argv)
