# postprocess
Babel = require "babel-core"

transformCode = (code) ->
  Babel.transform(code)
    .code
    .replace('\"use strict\";\n', '')

buildProps = (node) ->
  obj = {}

  if node.props?
    for i in node.props.children
      obj[i.key] = compile(i.expr)

  # style
  if node.styles?
    style = {}
    for s in node.styles.children
      style[s.key] = compile(s.expr)
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

compileCode = (text) ->

module.exports = compile = (node) ->
  switch node.type
    when 'program'
      codes = node.body.map (n) -> compile(n)
      """
      function(__props) {
        if(__props == null) __props = {};
        return runtime(function($){
          #{codes.join('\n')}
        });
      }
      """
    when 'element'
      props = buildProps(node)
      propsStr = expandObj props
      elementType = node.value.elementType

      unless node.children
        return "$('#{elementType}', #{propsStr})"

      # if node.children.type is 'text'
      #   return "$('#{elementType}', #{propsStr}, #{compile node.children.value})"

      if node.children.type in ['identifier', 'boolean', 'number', 'string', 'inlineText']
        return "$('#{elementType}', #{propsStr}, #{compile node.children})"

      children = node.children?.map (child) -> compile(child)
      childrenCode = 'function(){' + (children?.join(';') ? '') + ';}'
      "$('#{elementType}', #{propsStr}, #{childrenCode})"

    when 'code'
      transformCode node.value

    when 'multilineCode'
      transformCode node.value

    when 'embededCode'
      node.value

    when 'free'
      node.value

    when 'if'
      children = node.body.map (child) -> compile(child)
      childrenCode = children.join(';')
      condCode = compile node.condition

      """
      if(#{condCode}) { #{childrenCode} }
      """

    when 'for'
      bodyCode = node.body
        .map (c) -> compile(c) + ';'
        .join('')
      """
      for(var __i in #{compile node.right}) {
        var #{node.left.value} = #{compile node.right}[__i];
        #{bodyCode};
      }
      """

    when 'text'
      "$('span', {}, '#{node.value}')"

    when 'inlineText'
      "\'#{node.value}\'"

    when 'string'
      "\'#{node.value}\'"
    when 'number'
      "#{node.value}"
    when 'boolean'
      "#{node.value}"
    when 'identifier'
      "(__props\.#{node.value}||#{node.value})"
    else
      throw 'unknow node: ' + node.type
