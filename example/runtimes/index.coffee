global.m = require 'mithril'
global.deku = require 'deku'
global.React = require 'react'
global.hg = require 'mercury'
global.h = hg.h

props = {greeting: 'hello', items: [1, 2]}

window.addEventListener 'DOMContentLoaded', ->
  C = React.createClass
    render: -> require('./react')(@props)

  React.render(
    React.createElement(C, props)
    document.querySelector('#react')
  )

  el = require('./mithril')(props)
  m.render(
    document.querySelector('#mithril')
    el
  )
  
  hg.app(
    document.querySelector('#mercury')
    hg.state({})
    -> require('./mercury')(props)
  )
