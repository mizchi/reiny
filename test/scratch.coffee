fs = require 'fs'
path = require 'path'

{inspect} = require('util')

source = fs.readFileSync(path.join __dirname, 'fixtures/example.reiny').toString()
reiny = require('../src/index')
reiny.print(source)
