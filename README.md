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
- [ ] inline value
- [x] Runtime
- [ ] Agnostic inlineCode posteprocess
- [ ] Arda mixin

## Example

from

```
- var onClick = (e) => e.preventDefault();
a.link(
  href='/foo'
  onClick=onClick
){
  backgroundColor=red
}
  a
```

to

```
function() {
  return vk.compile(function($) {

    var onClick = function onClick(e) {
      return e.preventDefault();
    };
    $('', {
      a: b,
      c: d,
      x: y,
      d: 3,
      onClick: onClick,
      style: {
        backgroundColor: red
      },
      className: 'link'
    }, function() {
      $('a', {
        className: ''
      }, function() {})
    })

  });
}
```
