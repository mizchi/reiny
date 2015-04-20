{ok, equal} = require 'assert'

preprocess = require '../src/preprocess'

code = '''
// a
b
/* aaa */

/*
  bbb
  */
'''

console.log preprocess code
