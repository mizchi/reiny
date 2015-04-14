
# postprocess
Babel = require "babel-core"
CoffeeScript = require 'coffee-script'

code = ''
flatNodes = (nodes) ->
  codes = compile(nodes)
  arr = '[' + codes.join(',') + ']'
  code = """
  #{arr}.map(function(i){return i();}).filter(function(i){return i != null;});
  """

buildProps = (node) ->
  obj = {}

  if node.props?
    for i in node.props.children
      obj[i.key] = i.value.value

  # style
  if node.styles?
    style = {}
    for s in node.styles.children
      style[s.key] = s.value.value
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

  obj.className = classNames.join(' ') || "''"
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
      if node.body.length is 0
        """
        function(){
          return vk.compile(function($){
            $('div')
          });
        }
        """
      # else if body.length is 1
      #   """
      #   function () {
      #     return React.createElement("div");
      #   }
      #   """
      else
        codes = node.body.map (n) -> compile(n)

        """
        function(){
          return vk.compile(function($){
        #{codes.join('\n')}

          });
        }
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

    when 'if' then throw 'not implement yet'
    when 'for' then throw 'not implement yet'
    else
      throw 'unknow node: ' + node.type
