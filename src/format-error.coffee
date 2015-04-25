COLOURS =
  red: '\x1B[31m'
  green: '\x1B[32m'
  yellow: '\x1B[33m'
  blue: '\x1B[34m'
  magenta: '\x1B[35m'
  cyan: '\x1B[36m'

numberLines = (input, startLine = 1) ->
  lines = input.split '\n'
  padSize = "#{lines.length + startLine - 1}".length
  numbered = for line, i in lines
    currLine = "#{i + startLine}"
    pad = ((Array padSize + 1).join '0')[currLine.length..]
    "#{pad}#{currLine} : #{lines[i]}"
  numbered.join '\n'

SUPPORTS_COLOUR =
  process?.stderr?.isTTY and not process.env.NODE_DISABLE_COLORS
humanReadable = (str) ->
  ((str.replace /\uEFEF/g, '(INDENT)').replace /\uEFFE/g, '(DEDENT)').replace /\uEFFF/g, '(TERM)'
colourise = (colour, str) ->
  if SUPPORTS_COLOUR then "#{COLOURS[colour]}#{str}\x1B[39m" else str

cleanMarkers = (str) -> str.replace /[\uEFEF\uEFFE\uEFFF]/g, ''

pointToErrorLocation = (source, line, column, numLinesOfContext = 3) ->

  lines = source.split '\n'
  lines.pop() unless lines[lines.length - 1]
  # figure out which lines are needed for context
  currentLineOffset = line - 1
  startLine = currentLineOffset - numLinesOfContext
  if startLine < 0 then startLine = 0
  # get the context lines
  preLines = lines[startLine..currentLineOffset]
  preLines[preLines.length - 1] = colourise 'yellow', preLines[preLines.length - 1]
  postLines = lines[currentLineOffset + 1 .. currentLineOffset + numLinesOfContext]
  numberedLines = (numberLines (cleanMarkers [preLines..., postLines...].join '\n'), startLine + 1).split '\n'
  preLines = numberedLines[0...preLines.length]
  postLines = numberedLines[preLines.length...]
  # set the column number to the position of the error in the cleaned string
  column = (cleanMarkers "#{lines[currentLineOffset]}\n"[...column]).length
  padSize = ((currentLineOffset + 1 + postLines.length).toString 10).length
  [
    preLines...
    "#{colourise 'red', (Array padSize + 1).join '^'} : #{(Array column).join ' '}#{colourise 'red', '^'}"
    postLines...
  ].join '\n'

formatParserError = (input, e) ->
  realColumn = (cleanMarkers "#{(input.split '\n')[e.line - 1]}\n"[...e.column]).length
  unless e.found?
    return "Syntax error on line #{e.line}, column #{realColumn}: unexpected end of input"
  found = JSON.stringify humanReadable e.found
  found = ((found.replace /^"|"$/g, '').replace /'/g, '\\\'').replace /\\"/g, '"'
  unicode = ((e.found.charCodeAt 0).toString 16).toUpperCase()
  unicode = "\\u#{"0000"[unicode.length..]}#{unicode}"
  message = "Syntax error on line #{e.line}, column #{realColumn}: unexpected '#{found}' (#{unicode})"
  # message
  "#{message}\n#{pointToErrorLocation input, e.line, realColumn}"

module.exports = formatParserError
