
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERGRID/A1CELLS'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
#...........................................................................................................
new_xregex                = require 'xregexp'
A1LETTERS                 = require './a1letters'

#-----------------------------------------------------------------------------------------------------------
@settings =
  patterns:
    # a1_lowercase:  /^(?<star>[*])|((?<colstar>[*])|(?<colsign>\+|-|)(?<colletters>[a-z]+))((?<rowstar>[*])|(?<rowsign>\+|-|)(?<rowdigits>[0-9]+))/
    a1_lowercase:  ///
    ^(?:

    (?<star> [*] ) |
      (?:
        (?<colstar> [*] ) |
          (?<colsign> \+ | - | )
          (?<colletters> [a-z]+ )
          )
      (?:
        (?<rowstar> [*] ) |
        (?<rowsign> \+ | - | )
        (?<rowdigits> [0-9]+ )
        )
      )$
        ///
    # a1_uppercase:  /^([*]|(\+|-|)(?:[a-z]+))([*]|(\+|-|)(?:[0-9]+))/

#-----------------------------------------------------------------------------------------------------------
@parse_cellkey = ( cellkey ) ->
  R = cellkey.match @settings.patterns.a1_lowercase
  #.........................................................................................................
  unless R?
    throw new Error "µ9297 expected a cellkey like 'a1', '*', '*4' or 'c-1, got #{rpr cellkey}"
  #.........................................................................................................
  R = R.groups
  ( delete R[ key ] if R[ key ] in [ '', '+', undefined, ] ) for key of R
  #.........................................................................................................
  if R.colstar? and R.rowstar?
    R.star = '*'
  #.........................................................................................................
  else if R.star?
    R.colstar = '*'
    R.rowstar = '*'
  #.........................................................................................................
  if R.rowdigits?
    R.rowdigits = R.rowdigits.replace /^0*/, ''
  #.........................................................................................................
  if R.colletters?
    R.colnr = A1LETTERS.get_number R.colletters, A1LETTERS.settings.alphabets.lowercase
    R.colnr *= -1 if R.colsign?
  #.........................................................................................................
  if R.rowdigits?
    R.rownr = parseInt R.rowdigits, 10
    R.rownr *= -1 if R.rowsign?
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
@get_cellkey = ( cellref ) ->
  { colnr, rownr, } = cellref
  unless colnr? and ( colnr > 0 ) and ( colnr = Math.floor colnr )
    throw new Error "µ42330 expected positive integer for colnr, got #{rpr colnr}"
  unless rownr? and ( rownr > 0 ) and ( rownr = Math.floor rownr )
    throw new Error "µ42330 expected positive integer for rownr, got #{rpr rownr}"
  letters = A1LETTERS.get_letters rownr, A1LETTERS.settings.alphabets.lowercase
  return "#{letters}#{rownr}"
