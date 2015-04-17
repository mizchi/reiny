module.exports = (text) ->
  code = text
    .split('\n')
    .filter (line) ->
      line.split( /\t|\s/ ).join('').length > 0

    .join('\n')
  code + '\n'
