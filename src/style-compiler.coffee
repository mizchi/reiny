buildStyles = (node) ->
  if node.styles?
    style = {}
    for s in node.styles.children
      style[s.key] = parse(s.expr)
    style
  else
    {}

buildSelectors = (node) ->
  selectors = []
  if node.value?.modifiers?.length
    for m in node.value.modifiers
      switch m.type
        when 'className'
          selectors.push '.' + m.value
        when 'id'
          selectors.push '#' + m.value
  else
    selectors.push node.value.elementType
  selectors

flatten = (listable) ->
  children = listable.map (child) -> parse(child)
  list = children.filter (i) -> i.type isnt 'para'
  for c in children when c.type is 'para'
    if c.children?
      list.push c.children...
  list

parse = (node) ->
  switch node.type
    when 'program'
      codes = node.body
        .map (n) -> parse(n)
      codes

    when 'element'
      styles = buildStyles(node)
      selectors = buildSelectors(node)
      if node.children instanceof Array
        list = flatten(node.children)
        {selector: selectors.join(''), styles, children:list}
      else
        {selector: selectors.join(''), styles}

    when 'if', 'forIn', 'forOf'
      list = flatten(node.body)
      {type: 'para', children:list}

    when 'string'
      "#{node.value}"
    when 'number'
      "#{node.value}"
    when 'identifier'
      '$' + node.value
    when 'thisIdentifier'
      "__props\.#{node.value}"
    else
      null

serializeCSS = (node, parentSelector = '') ->
  selector = parentSelector + '' + node.selector
  styles = ''
  for k, v of node.styles
    styles += '  ' + k + ':' + v + ';\n'
  code = """
  #{selector} {
  #{styles}
  }
  """
  if node.children
    children = node.children
      .map (n) -> serializeCSS(n, selector)
      .join('\n')
  else
    children = ''
  code + '\n' + children

serializeSCSS = (node, prefix = '') ->
  selector = node.selector
  styles = []
  for k, v of node.styles
    styles.push prefix + '  ' + k + ':' + v + ';'
  if node.children
    children = node.children
      .map (n) -> serializeSCSS(n, prefix + '  ')
      .join('\n')
    styles.push children
  """
  #{prefix}#{selector} {
  #{styles.join('\n')}
  #{prefix}}
  """

module.exports = compile = (node, options = {}) ->
  lines = parse(node)

  if lines?.length
    lines.map((node) -> serializeSCSS node).join('\n')
  else
    ''
