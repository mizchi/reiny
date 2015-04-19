global.React = require('react');
var template = require('./template');
var C = React.createClass({
  propTypes: template.propTypes,
  render: function(){
    return template(this.props);
  }
});

console.log(React.renderToStaticMarkup(
  React.createElement(C, {greeting: 'hello', items: [1, 2]})
))
