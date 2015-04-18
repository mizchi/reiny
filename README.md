# Reiny

Template engine for React

```
npm install reiny --save
```

- gulp: [mizchi/gul-reiny](https://github.com/mizchi/gul-reiny "mizchi/gul-reiny")
- browserify: [mizchi/reinify](https://github.com/mizchi/reinify "mizchi/reinify")

## Goals

- Jade like template engine
- Generate react element
- Inline css friendly
- Inline babel preprocessor
- (WIP) Inline propTypes

## Example

Runner

```js
global.React = require('react');
var template = require('./template'); // compiled source
console.log(React.renderToStaticMarkup(
  template({items: [1, 100]}
)));
```

from

<pre>
```
let Foo = React.createClass({
  render: () => {
    return React.createElement('div', {className: 'foo'});
  }
})
```

div() {
  backgroundColor = 'red'
}
  // CamelCase becomes reference
  Foo()

  // unicode
  span(
    key="--🐑--"
  )

  // ref with &
  span&foo()

  // for syntax
  ul
    for i in @items
      li(key=i) = i

  // if syntax
  if false
    a hoge fuga aaa

  // inline expression
  if { 2 > 1 }
    a(key='fooo') hoge fuga aaa

  // text
  | aaaa bbbb

  // object mixin as property
  ` let o = {'data-a': 'aaa', 'data-b': 'bbb'};
  foo(
    > o
    onClick = {- function(){console.log('foo')} -}
  )
</pre>

```
global.React = require('react');
var template = require('./template'); // compiled source
console.log(React.renderToStaticMarkup(
  template({items: [1, 100]}
)));
```

```
<div class="template-root"><div style="background-color:red;"></div><Foo></Foo><span></span><span></span><ul><li>1</li><li>100</li></ul><a>hoge fuga aaa</a><span>aaaa bbbb</span><foo data-a="aaa" data-b="bbb"></foo></div>
```

## TODO

- [x] Indent block
- [x] Text Node
- [x] IfStatement
- [x] ForInStatement
- [x] ForOfStatement
- [x] Runtime
- [x] Embeded expression
- [x] Unicode
- [x] Vriable as element type
- [x] gulp plugin
- [x] browserify plugin
- [x] CLI interface
- [ ] Register
- [ ] Agnostic inlineCode preprocessor (Coffee/Babel/TypeScriptSimple)
- [ ] Type Parameters statement for React propTypes
- [ ] Inject shared helper

## LICENSE

MIT
