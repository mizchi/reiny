# postprocess
Babel = require "babel-core"
camelize = require 'camelize'

transformCode = (code) ->
  Babel.transform(code)
    .code
    .replace('\"use strict\";\n', '')
    .replace('\'use strict\';\n', '')

buildProps = (node) ->
  obj = {}
  classNames = []

  if node.props?
    obj.__mergeables = node.props.children.filter (p) -> p.type is 'mergeable-object'

    props = node.props.children.filter (p) -> p.type is 'property'
    for i in props
      if i.key is 'className'
        classNames.push i.expr
      else
        obj[i.key] = _compile(i.expr)

  # style
  if node.styles?
    style = {}
    for s in node.styles.children
      # camelize for react style
      style[camelize s.key] = _compile(s.expr)
    obj.style = style

  # classes and id
  if node.value?.modifiers?
    for m in node.value.modifiers
      switch m.type
        when 'className' then classNames.push {type:'string', value: m.value}
        when 'id'  then obj.id  = '\'' + m.value + '\''
        when 'ref' then obj.ref = '\'' + m.value + '\''
        when 'key' then obj.key = '\'' + m.value + '\''
  if classNames.length > 0
    code = classNames
      .map((e) -> _compile(e))
      .join(',')
    obj.className = '[' + code + '].join(" ")'
  obj

_wrapStr = (s) -> '\'' + s + '\''
expandObj = (obj) ->
  kv =
    for k, v of obj when k not in ['__mergeables']
      if v instanceof Object
        _wrapStr(k) + ': ' + expandObj(v)
      else
        _wrapStr(k) + ':' + v
  ret = '{' + kv.join(',') + '}'
  if obj.__mergeables?.length
    objs = obj.__mergeables
      .map((m) -> m.key)
      .join(',')
    "__extend({}, #{objs}, #{ret})"
  else
    ret

isUpperCase = (text) ->
  text.toUpperCase() is text

buildPropTypes = (propTypeLines) ->
  propTypes = {}
  for propType in propTypeLines
    # console.error "key", propType
    propertyName = propType.value.propertyName
    typeName = propType.value.typeExpr.typeName
    typeCode =
      if propType.value.typeExpr.isArray
        "_T.arrayOf(_T.#{typeName})"
      else
        "_T.#{typeName}"

    unless propType.value.typeExpr.optional
      typeCode += ".isRequired"

    propTypes[propertyName] = typeCode

  # console.error propTypes
  # console.error expandObj propTypes
  expandObj propTypes

_compile = (node) ->
  switch node.type
    when 'directElement'
      "$.direct(#{node.value})"

    when 'element'
      props = buildProps(node)
      propsStr = expandObj props
      elementCode =
        if isUpperCase(node.value.elementType[0])
          _compile(type:'identifier', value:node.value.elementType)
        else
          _compile(type:'string', value:node.value.elementType)

      unless node.children
        return "$(#{elementCode}, #{propsStr})"

      if node.children.type in ['identifier', 'boolean', 'number', 'string', 'inlineText', 'embededExpr','thisIdentifier']
        return "$(#{elementCode}, #{propsStr}, #{_compile node.children})"

      children = node.children?.map (child) -> _compile(child)
      childrenCode = 'function(){' + (children?.join(';') ? '') + ';}'
      "$(#{elementCode}, #{propsStr}, #{childrenCode})"

    when 'code'
      transformCode node.value

    when 'multilineCode'
      transformCode node.value

    when 'embededExpr'
      node.value

    when 'free'
      node.value

    when 'propTypeDeclaration'
      throw 'propTypeDeclaration is only allowed on toplevel'

    when 'if'
      condCode = _compile node.condition

      children = node.body.map (child) -> _compile(child)
      childrenCode = children.join(';')

      ifCode = """
      if(#{condCode}) { #{childrenCode} }
      """

      if node.consequents?.length
        for consequent in node.consequents
          consequentCondCode = _compile consequent.condition
          consequentCode =
            consequent.body
              .map((child) -> _compile(child))
              .join(';')

          ifCode += "else if(#{consequentCondCode}) { #{consequentCode} }"

      if node.alternate?
        alternateChildrenCode =
          node.alternate.body
            .map((child) -> _compile(child))
            .join(';')
        ifCode += "else { #{alternateChildrenCode} }"

      ifCode

    when 'forIn'
      bodyCode = node.body
        .map((c) -> _compile(c) + ';')
        .join('')
      """
      for(var __i in #{_compile node.right}) {
        #{if node.second? then "var #{node.second.value} = __i;" else ""}
        var #{node.left.value} = #{_compile node.right}[__i];
        #{bodyCode};
      }
      """

    when 'forOf'
      bodyCode = node.body
        .map((c) -> _compile(c) + ';')
        .join('')
      """
      for(var __i in #{_compile node.right}) {
        #{if node.second? then "var #{node.second.value} = __i;" else ""}
        var #{node.left.value} = #{_compile node.right}[__i];
        #{bodyCode};
      }
      """

    when 'comment'
      "/* #{node.value} */"

    when 'text'
      # "$('span', {}, '#{node.value}')"
      code =
        if typeof node.value is 'string'
          _wrapStr node.value
        else
          _compile(node.value)

      "$.text(#{code})"

    when 'inlineText'
      "\'#{node.value}\'"

    when 'string'
      "\'#{node.value}\'"
    when 'number'
      "#{node.value}"
    when 'boolean'
      "#{node.value}"
    when 'identifier'
      node.value
    when 'thisIdentifier'
      "self\.#{node.value}"
    else
      throw 'unknow node: ' + node.type

# ProgramNode => string
module.exports = (node, options = {}) ->
  exportTarget = options.export ? 'module.exports'
  codes = node.body
    .filter((n) -> n.type isnt 'propTypeDeclaration')
    .map((n) -> _compile(n))

  propTypes = node.body.filter (n) -> n.type is 'propTypeDeclaration'
  propTypesCode = propTypes
    .map((propType) -> 'var ' + propType.value.propertyName + ' = self.' + propType.value.propertyName + ';')
    .join('\n')

  result = """
  "use strict";
  #{exportTarget} = function(self) {
    var reiny = require('reiny');
    var __extend = reiny.xtend;
    if(self == null) self = {};
    #{propTypesCode}
    return reiny.runtime(function($){
      #{codes.join('\n')}
    }, {target: '#{options.target ? 'react'}'});
  }
  """

  if propTypes.length > 0
    result += '\nvar _T = React.PropTypes;\nmodule.exports.propTypes =' + buildPropTypes(propTypes)

  result
