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

```jade
div(
  onClick=onClick

){
  backgroundColor = 'red'
}
  span = foo
  ul
    for i in items
      li(key=i) = i
  if true
    a(key="fooo") hoge fuga aaa
  | aaaa bbbb

  ` let o = {'data-a': 'aaa', 'data-b': 'bbb'};
  ` let p = {'data-c': 3, 'data-id': 4};
  foo(
    > o
    > p
    onClick = {- function(){console.log('foo')} -}
  )
```

to

```html
<div style="background-color:red;"><span>hogefuga</span>
    <ul>
        <li>1</li>
        <li>2</li>
        <li>3</li>
    </ul><a>hoge fuga aaa</a><span>aaaa bbbb</span>
    <foo data-a="aaa" data-b="bbb" data-c="3" data-id="4"></foo>
</div>
```
