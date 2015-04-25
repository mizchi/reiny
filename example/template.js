"use strict";
module.exports = function(self) {
    var reiny = require('reiny/runtime');
    var __extend = reiny.xtend;

    if (self == null) self = {};
    return reiny.runtime(function($) {
        $('div', {
            'data-id': 'this-is-id',
            'style': {
                'backgroundColor': '#eee',
                'width': '640px',
                'height': 40 * 12,
                'fontSize': '1em'
            },
            'ref': 'mainCotnainer',
            'className': ['main', 'container'].join(" ")
        }, function() {
            $('h1', {}, 'This is a title');
            $('span', {}, 'expand with span');
            $('span', {}, self.greeting);
            if (false) {
                $('a', {}, 'hoge fuga aaa')
            };
            if (2 > 1) {
                $('a', {
                    'key': 'fooo'
                }, 'hoge fuga aaa')
            };
            $('ul', {}, function() {
                for (var __i in self.items) {

                    var i = self.items[__i];
                    $('li', {
                        'key': i
                    }, i);;
                };
            });
            var o = {
                'data-a': 'aaa',
                'data-b': 'bbb'
            };;
            $('div', __extend({}, o, {
                'onClick': function() {
                    console.log('foo')
                },
                'className': ['foo'].join(" ")
            }));
            var Foo = React.createClass({
                displayName: 'Foo',

                render: function render() {
                    return React.createElement('div', {
                        className: 'foo'
                    });
                }
            });;
            $(Foo, {});
            var el = React.createElement(Foo, {});;
            $.direct(el);
        })
    }, {
        type: 'react'
    });
}