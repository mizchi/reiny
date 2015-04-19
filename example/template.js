"use strict";
var reiny = require('reiny/runtime');
var __runtime = reiny.runtime;
var __extend = reiny.xtend;
module.exports = function(__props) {
  if (__props == null) __props = {};
  return __runtime(function($) {

    var Foo = React.createClass({
      displayName: 'Foo',

      render: function render() {
        return React.createElement('div', {
          className: 'foo'
        });
      }
    });
    $('div', {
      style: {
        backgroundColor: 'red'
      }
    }, function() { /*  CamelCase becomes reference */ ;
    })
    $('Foo', {}, function() { /*  unicode */ ;
    })
    $('span', {
      key: '--🐑--'
    }, function() { /*  ref with & */ ;
    })
    $('span', {
      ref: 'foo'
    }, function() { /*  for syntax */ ;
    })
    $('ul', {}, function() {
        for (var __i in __props.items) {

          var i = __props.items[__i];
          $('li', {
            key: i
          }, i);;
        };
      })
      /*  if syntax */
    if (false) {
      $('a', {}, 'hoge fuga aaa')
    }
    /*  inline expression */
    if (2 > 1) {
      $('a', {
        key: 'fooo'
      }, 'hoge fuga aaa')
    }
    /*  text */
    $('span', {}, 'aaaa bbbb')
      /*  object mixin as property */

    var o = {
      'data-a': 'aaa',
      'data-b': 'bbb'
    };
    $('foo', __extend({}, o, {
      onClick: function() {
        console.log('foo')
      }
    }))
  });
};