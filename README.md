# Reiny

WIP


## Example

from

```
- var onClick = (e) => e.preventDefault();
node.a(a=b c=d
  x=y d=3
  onClick=onClick
){a=3}
  a
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
