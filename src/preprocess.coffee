module.exports = (text) ->
  code = text
    .replace(/\/\*(.|\s|\n)+?\*\//gm, '')
    .split('\n')
    .filter (line) ->
      trimed = line.split( /\t|\s/ ).join('')
      trimed.length > 0 and (trimed.indexOf('//') isnt 0)
    .join('\n')
  code + '\n'
