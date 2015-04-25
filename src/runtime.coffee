runtime = (block, options = {}) ->
  switch options.target ? 'react'
    when 'react'   then require('virdy/runtime/react')(block, options)
    when 'mithril' then require('virdy/runtime/mithril')(block, options)
    when 'mercury' then require('virdy/runtime/mercury')(block, options)
    when 'deku'    then require('virdy/runtime/deku')(block, options)

module.exports = runtime
module.exports.runtime = runtime
runtime.xtend = xtend = require 'xtend'

# createReactComponent(template:(props:Object) => ReactElement, ...mixins): ReactComponent
#
# Example.
# Component = reiny.createReactComponent require('./template'),
#   onClick: -> console.log 'cliced'
runtime.createReactComponent = (template, mixins...) ->
  React.createClass xtend({},
    propTypes: template.propTypes
    render: -> template(xtend {}, @, @props)
  , mixins...)
