reiny = require('../lib/index')
{inspect} = require('util')
path = require('path')
fs =require('fs')

argv = require('minimist')(process.argv.slice(2))

printBeautifiedCode = (source, options = {}) ->
  code = reiny.compile source, options

printAst = (source, options = {}) ->
  code = reiny.parse source, options
  inspect code, depth: null

[target] = argv._

run = (target, argv) ->
  targetPath = path.join process.cwd(), target
  source = fs.readFileSync(targetPath).toString()

  code = reiny.compile source
  # TODO: auto generate filename by extname
  if argv.out or argv.o
    # console.log process.cwd(), argv.out ? argv.o
    outputPath = path.join process.cwd(), (argv.out ? argv.o)
    fs.writeFileSync(outputPath, code)
  else
    console.log code

run(argv._[0], argv)
