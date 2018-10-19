
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
assign                    = Object.assign
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
  { colnr, rownr, colstar, rowstar, star, } = cellref
  colletters                                = null
  colsign                                   = ''
  #.........................................................................................................
  if star?
    unless star is '*'
      throw new Error "µ5434 expected '*' for star, got #{rpr star}"
    if colnr? or rownr?
      throw new Error "µ8206 illegal to set colnr or rownr with star, got #{rpr cellref}"
    return '*'
  #.........................................................................................................
  if colstar?
    unless colstar is '*'
      throw new Error "µ6338 expected '*' for colstar, got #{rpr colstar}"
    if colnr?
      throw new Error "µ4974 illegal to set colnr with colstar, got #{rpr cellref}"
    colletters = '*'
  #.........................................................................................................
  else if rowstar?
    unless rowstar is '*'
      throw new Error "µ2116 expected '*' for rowstar, got #{rpr rowstar}"
    if rownr?
      throw new Error "µ1071 illegal to set rownr with rowstar, got #{rpr cellref}"
    rownr = '*'
  #.........................................................................................................
  else
    #.......................................................................................................
    if colnr?
      unless ( colnr = Math.floor colnr )
        throw new Error "µ1849 expected integer for colnr, got #{rpr colnr}"
    else
      colletters = '*'
    #.......................................................................................................
    if rownr?
      unless ( rownr = Math.floor rownr )
        throw new Error "µ9949 expected integer for rownr, got #{rpr rownr}"
    else
      rownr = '*'
  #.........................................................................................................
  unless colletters?
    if colnr?
      colsign     = if colnr < 0 then '-' else ''
      colletters  = A1LETTERS.get_letters ( Math.abs colnr ), A1LETTERS.settings.alphabets.lowercase
    else
      colletters = '*'
  #.........................................................................................................
  rownr = '*' unless rownr?
  return '*' if colletters is '*' and rownr is '*'
  return "#{colsign}#{colletters}#{rownr}"

#-----------------------------------------------------------------------------------------------------------
@normalize_cellkey = ( cellkey ) -> @get_cellkey @parse_cellkey cellkey
@normalize_cellref = ( cellref ) -> @parse_cellkey @get_cellkey cellref

#-----------------------------------------------------------------------------------------------------------
@abs_cellref = ( cellref ) ->
  R = assign {}, cellref
  delete R.colsign
  delete R.rowsign
  R.colnr   = Math.abs R.colnr if R.colnr?
  R.rownr   = Math.abs R.rownr if R.rownr?
  R.cellkey = @get_cellkey R
  return R




