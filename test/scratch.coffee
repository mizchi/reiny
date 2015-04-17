fs = require 'fs'
path = require 'path'

{inspect} = require('util')

source = fs.readFileSync(path.join __dirname, 'fixtures/inline-expr.reiny').toString()
reiny = require('../src/index')
console.error inspect reiny.parse(source), depth: null
reiny.print(source)
