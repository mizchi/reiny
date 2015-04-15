# postprocess
Babel = require "babel-core"
CoffeeScript = require 'coffee-script'

code = ''

expr2code = (expr) ->
  switch expr.type
    when 'string'
      "\'#{expr.value}\'"
    when 'number'
      "#{expr.value}"
    when 'boolean'
      "#{expr.value}"
    when 'identifier'
      "#{expr.value}"
    else
      throw 'unknown node'

buildProps = (node) ->
  obj = {}

  if node.props?
    for i in node.props.children
      obj[i.key] = expr2code(i.expr)

  # style
  if node.styles?
    style = {}
    for s in node.styles.children
      style[s.key] = expr2code(s.expr)
    obj.style = style

  # classes and id
  if node.value?.modifiers?
    classNames =
      if obj.className then [obj.className] else []
    for m in node.value.modifiers
      switch m.type
        when 'className' then classNames.push m.value
        when 'id' then obj.id = m.value
        when 'ref' then obj.key = m.value
  if classNames.length > 0
    obj.className = classNames.join(' ')
  obj

expandObj = (obj) ->
  kv =
    for k, v of obj
      if v instanceof Object
        k + ': ' + expandObj(v)
      else
        k + ':' + v
  '{' + kv.join(',') + '}'

module.exports = compile = (node) ->
  switch node.type
    when 'program'
      codes = node.body.map (n) -> compile(n)
      """
      var runtime = require('coppe');
      module.exports = function() {
      return runtime(function($){
      // ----- start -----
        #{codes.join('\n')}
      // ----- end ----
      });
      }
      console.log(React.renderToStaticMarkup(module.exports()));
      """
    when 'element'
      props = buildProps(node)
      propsStr = expandObj props

      elementType = node.value.elementType

      children = node.children?.map (child) -> compile(child)

      childrenSrc = 'function(){' + (children?.join(';') ? '') + '}'
      """
      $('#{elementType}', #{propsStr}, #{childrenSrc})
      """

    when 'inlineCode'
      code = Babel.transform(node.value).code
      code.replace('\"use strict\";\n', '')

    when 'if'
      children = node.body.map (child) -> compile(child)
      childrenSrc = children.join(';')
      condSrc = expr2code node.condition
      """
      if(#{condSrc}) { #{childrenSrc} }
      """

    when 'for'
      children = node.body.map (child) -> compile(child)
      childrenSrc = children.join(';')
      """
      for(var #{node.left.value} in #{node.right.value}) {#{childrenSrc}}
      """
    else
      throw 'unknow node: ' + node.type
