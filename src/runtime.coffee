runtime = (block, options = {}) ->
  switch options.target ? 'react'
    when 'react'   then require('virdy/runtime/react')(block, options)
    when 'mithril' then require('virdy/runtime/mithril')(block, options)
    when 'mercury' then require('virdy/runtime/mercury')(block, options)
    when 'deku'    then require('virdy/runtime/deku')(block, options)

module.exports = runtime
module.exports.runtime = runtime
module.exports.xtend = require 'xtend'
