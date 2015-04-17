# Reiny

WIP

Everything doesn't work.

## Goal

- Jade like template engine
- Generate react
- inline css
- inline propTypes

## TODO

- [x] Text Node
- [x] IfStatement
- [x] ForStatement
- [x] Runtime
- [x] Embeded Code
- [ ] Agnostic inlineCode posteprocess
- [ ] Arda mixin
- [x] inline value

## Example

from

    ` let onClick = (e) => e.preventDefault();

    ```
    let items = [1, 2, 3]
    let foo = 'hogefuga'
    ```

    div(onClick = onClick){
      backgroundColor = 'red'
    }
      // for syntax
      ul
        for i in items
          li(key=i) = i

      // if syntax
      if true
        a(key="fooo") hoge fuga aaa

      | aaaa bbbb

      ` let o = {'data-a': 'aaa', 'data-b': 'bbb'};
      foo(
        > o
        onClick = {- function(){console.log('foo')} -}
      )

to

```js
"use strict";
var reiny = require('reiny');
var __runtime = reiny.runtime;
var __extend = reiny.xtend;
module.exports = function(__props) {
  if (__props == null) __props = {};
  return __runtime(function($) {

    var onClick = function onClick(e) {
      return e.preventDefault();
    };

    var items = [1, 2, 3];
    var foo = 'hogefuga';
    $('div', {
      onClick: (__props.onClick || onClick),
      style: {
        backgroundColor: 'red'
      }
    }, function() { /*  for syntax */ ;
      $('ul', {}, function() {
        for (var __i in items) {
          var i = items[__i];
          $('li', {
            key: (__props.i || i)
          }, (__props.i || i));;
        };
      }); /*  if syntax */ ;
      if (true) {
        $('a', {
          key: 'fooo'
        }, 'hoge fuga aaa')
      };
      $('span', {}, 'aaaa bbbb');
      var o = {
        'data-a': 'aaa',
        'data-b': 'bbb'
      };;
      $('foo', __extend({}, o, {
        onClick: function() {
          console.log('foo')
        }
      }));
    })
  });
};
```

## Use

```
global.React = require('react');
el = require('./template') // result of reiny.compile(...)
React.renderToStaticMarkup(el);
```

output

```html
<div style="background-color:red;">
    <ul>
        <li>1</li>
        <li>2</li>
        <li>3</li>
    </ul><a>hoge fuga aaa</a><span>aaaa bbbb</span>
    <foo data-a="aaa" data-b="bbb"></foo>
</div>
```
