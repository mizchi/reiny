# Reiny

WIP

Everything doesn't work.

## Goal

- Jade like template engine
- Generate react
- inline css
- inline propTypes

## TODO

- [ ] Text Node
- [ ] IfStatement
- [ ] ForStatement
- [ ] inline value
- [ ] Runtime
- [ ] Agnostic inlineCode posteprocess
- [ ] Arda mixin

## Example

from

```
- var onClick = (e) => e.preventDefault();
a.link(
  href='/foo'
  onClick=onClick
){backgroundColor=red}
  span
```

to

```
function() {
  return vk.compile(function($) {

    var onClick = function onClick(e) {
      return e.preventDefault();
    };
    $('node', {
      a: b,
      c: d,
      x: y,
      d: 3,
      onClick: onClick,
      style: {
        a: 3
      },
      className: a
    }, function() {
      $('a', {
        className: ''
      }, function() {})
    })

  });
}
```
