fs = require 'fs'
path = require 'path'

{inspect} = require('util')

source = fs.readFileSync(path.join __dirname, 'fixtures/example.reiny').toString()
reiny = require('../src/index')

# console.error inspect reiny.parse(source), depth: null
# ast = reiny.parse(source)
# console.log reiny._compile(ast)
reiny.print(source)
