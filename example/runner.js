global.React = require('react');
var template = require('./template');

console.log(React.renderToStaticMarkup(template({items: [1, 100]})));
