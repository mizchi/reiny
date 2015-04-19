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

template.reiny

```
---
let Foo = React.createClass({
  render: () => {
    return React.createElement('div', {className: 'foo'});
  }
})
---

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
  - let o = {'data-a': 'aaa', 'data-b': 'bbb'};
  foo(
    > o
    onClick = {- function(){console.log('foo')} -}
  )
```

```
npm install -g reiny
reiny template.reiny -o template.js
```

or node module

```js
var reiny = require('reiny/lib');
reiny.compile('foo.bar(prop=1) text');
```

## How to Use

Use template with runner

```
npm install reiny --save-dev
```

```js
global.React = require('react');
var template = require('./template'); // compiled source
console.log(React.renderToStaticMarkup(
  template({items: [1, 100]}
)));
```

```html
<div style="background-color:red;">
  <ul>
    <li>1</li>

    <li>100</li>
  </ul><a>hoge fuga aaa</a><span>aaaa bbbb</span>
</div>
```

## How to develop

```
./script/build
```

## LICENSE

MIT
