# Reiny

Template engine for React / Mithril / Mercury

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
// declare propTypes
@greeting: string
@items: number[]

// props and inline style
.main.container(
  data-id = 'this-is-id'
) {
  background-color: #eee
  width: 640px
  height: { 40 * 12 }
  font-size: 1em
}
  // text
  h1 This is a title

  // ref alias by & modifier
  foo&foo

  | expand with span
  span = @greeting

  // if syntax
  if false
    a hoge fuga aaa

  // inline expression
  if { 2 > 1 }
    a(key='fooo') hoge fuga aaa

  // for syntax
  ul
    for i in @items
      li(key=i) = i

  // object mixin as property
  - let o = {'data-a': 'aaa', 'data-b': 'bbb'};
  .foo(
    > o
    onClick = {- function(){console.log('foo')} -}
  )

  // mutli line code
  ---
  let Foo = React.createClass({
    render: () => {
      return React.createElement('div', {className: 'foo'});
    }
  })
  ---
  // CamelCase becomes element reference
  Foo()

  // Embed element direactly
  - var el = React.createElement(Foo, {})
  +(el)

```

```
npm install -g reiny
reiny template.reiny -o template.js
```

or node module

```js
var reiny = require('reiny/lib');
reiny.compile('foo.bar(prop=1) text'); // generate code string
```

## How to Use

Use template with runner

```
npm install reiny --save-dev
```

```js
global.React = require('react');
var template = require('./template');
var C = React.createClass({
  propTypes: template.propTypes || {},
  render: function(){
    return template(this.props);
  }
});

console.log(React.renderToStaticMarkup(
  React.createElement(C, {greeting: 'hello', items: [1, 2]})
));
```

```html
<div data-id="this-is-id" style="background-color:#eee;width:640px;height:480px;font-size:1em;" class="main container">
  <h1>This is a title</h1>
  <span>expand with span</span>
  <span>hello</span>
  <a>hoge fuga aaa</a>
  <ul>
    <li>1</li>
    <li>2</li>
  </ul>
  <div data-a="aaa" data-b="bbb" class="foo"></div>
  <div class="foo"></div>
  <div class="foo"></div>
</div>

```

## SCSS Compiler(experimental)

```
.foo {
  color: 'green'
}
  if true
    if true
      .quux {
        color: #eee
      }
  .bar {
    color: 'red'
  }
    .baz {
      color: 'blue'
    }
    if false
      .fuba {
        color: value
      }
```

to

```
reiny template.reiny --scss
```

```
.foo {
  color:'green';
  .bar {
    color:'red';
    .baz {
      color:'blue';
    }
    .fuba {
      color:$value;
    }
  }
  .quux {
    color:'#eee';
  }
}
```

## How to develop

```
./script/build
```

## LICENSE

MIT
