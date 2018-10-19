
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERGRID/GRID'
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
jr                        = JSON.stringify
assign                    = Object.assign
new_xregex                = require 'xregexp'
LETTERS                   = require './a1letters'
CELLS                     = require './a1cells'

#-----------------------------------------------------------------------------------------------------------
@settings =
  rangemark: '..'

#-----------------------------------------------------------------------------------------------------------
@new_grid_from_cellkey = ( cellkey ) ->
  cellref = CELLS.abs_cellref CELLS.parse_cellkey cellkey
  width   = cellref.colnr
  height  = cellref.rownr
  return { '~isa': 'INTERGRID/GRID/grid', width, height, }

# #-----------------------------------------------------------------------------------------------------------
# @is_left_of_cellkey = ( grid, cellkey_1, cellkey_2 ) ->
#   cellref_1 = @abs_cellref grid, CELLS.parse_cellkey cellkey_1
#   cellref_2 = @abs_cellref grid, CELLS.parse_cellkey cellkey_2
#   width   = cellref.colnr
#   height  = cellref.rownr
#   return { '~isa': 'INTERGRID/GRID/grid', width, height, }

#-----------------------------------------------------------------------------------------------------------
@abs_cellref = ( grid, cellref ) ->
  R = CELLS.normalize_cellref cellref
  #.........................................................................................................
  if R.colsign?
    R.colnr       = grid.width + 1 + R.colnr
    R.colletters  = LETTERS.get_letters R.colnr
    delete R.colsign
  #.........................................................................................................
  if R.rowsign?
    R.rownr     = grid.height + 1 + R.rownr
    R.rowdigits = "#{R.rownr}"
    delete R.rowsign
  #.........................................................................................................
  if ( R.colnr <= 0 ) or ( R.colnr > grid.width )
    throw new Error "µ9949 column nr #{rpr cellref.colnr} exceeds grid width #{rpr grid.width}"
  if ( R.rownr <= 0 ) or ( R.rownr > grid.height )
    throw new Error "µ9949 row nr #{rpr cellref.rownr} exceeds grid height #{rpr grid.height}"
  #.........................................................................................................
  R.cellkey = CELLS.get_cellkey R
  return R

#-----------------------------------------------------------------------------------------------------------
@parse_cellkey  = ( grid, cellkey ) -> @abs_cellref grid, CELLS.parse_cellkey cellkey
@abs_cellkey    = ( grid, cellkey ) -> CELLS.get_cellkey @parse_cellkey grid, cellkey

#-----------------------------------------------------------------------------------------------------------
@is_left_of_cellref = ( grid, cellref_1, cellref_2 ) ->
  cellref_1 = @abs_cellref grid, cellref_1
  cellref_2 = @abs_cellref grid, cellref_2
  return cellref_1.colnr < cellref_2.colnr

#-----------------------------------------------------------------------------------------------------------
@is_right_of_cellref = ( grid, cellref_1, cellref_2 ) ->
  cellref_1 = @abs_cellref grid, cellref_1
  cellref_2 = @abs_cellref grid, cellref_2
  return cellref_1.colnr > cellref_2.colnr

#-----------------------------------------------------------------------------------------------------------
@is_above_cellref = ( grid, cellref_1, cellref_2 ) ->
  cellref_1 = @abs_cellref grid, cellref_1
  cellref_2 = @abs_cellref grid, cellref_2
  return cellref_1.rownr < cellref_2.rownr

#-----------------------------------------------------------------------------------------------------------
@is_below_cellref = ( grid, cellref_1, cellref_2 ) ->
  cellref_1 = @abs_cellref grid, cellref_1
  cellref_2 = @abs_cellref grid, cellref_2
  return cellref_1.rownr > cellref_2.rownr

#-----------------------------------------------------------------------------------------------------------
@is_left_of_cellkey = ( grid, cellkey_1, cellkey_2 ) ->
  ### TAINT will perform @abs_cellref twice ###
  return @is_left_of_cellkey  grid, ( @parse_cellkey grid, cellkey_1 ), ( @parse_cellkey grid, cellkey_2 )

#-----------------------------------------------------------------------------------------------------------
@is_right_of_cellkey = ( grid, cellkey_1, cellkey_2 ) ->
  ### TAINT will perform @abs_cellref twice ###
  return @is_right_of_cellkey grid, ( @parse_cellkey grid, cellkey_1 ), ( @parse_cellkey grid, cellkey_2 )

#-----------------------------------------------------------------------------------------------------------
@is_above_cellkey = ( grid, cellkey_1, cellkey_2 ) ->
  ### TAINT will perform @abs_cellref twice ###
  return @is_above_cellkey    grid, ( @parse_cellkey grid, cellkey_1 ), ( @parse_cellkey grid, cellkey_2 )

#-----------------------------------------------------------------------------------------------------------
@is_below_cellkey = ( grid, cellkey_1, cellkey_2 ) ->
  ### TAINT will perform @abs_cellref twice ###
  return @is_below_cellkey    grid, ( @parse_cellkey grid, cellkey_1 ), ( @parse_cellkey grid, cellkey_2 )

#-----------------------------------------------------------------------------------------------------------
@parse_rangekey = ( grid, rangekey ) ->
  if ( rangekey.match /^(?:[*]|[*]{1,2}\.\.[*]{1,2})$/ )?
    left_colnr    = 1
    right_colnr   = grid.width
    top_rownr     = 1
    bottom_rownr  = grid.height
  #.........................................................................................................
  else
    cellkeys = rangekey.split @settings.rangemark
    #.......................................................................................................
    unless cellkeys.length is 2
      throw new Error "µ9949 expected rangekey, got #{rpr rangekey}"
    #.......................................................................................................
    [ cellkey_1, cellkey_2, ] = cellkeys
    cellref_1                 = @abs_cellref grid, CELLS.parse_cellkey cellkey_1
    cellref_2                 = @abs_cellref grid, CELLS.parse_cellkey cellkey_2
    #.......................................................................................................
    if cellref_1.colstar? or cellref_2.colstar? then  [ left_colnr, right_colnr, ] = [               1, grid.width,      ]
    else                                              [ left_colnr, right_colnr, ] = [ cellref_1.colnr, cellref_2.colnr, ]
    #.......................................................................................................
    if cellref_1.rowstar? or cellref_2.rowstar? then  [ top_rownr, bottom_rownr, ] = [               1, grid.height,     ]
    else                                              [ top_rownr, bottom_rownr, ] = [ cellref_1.rownr, cellref_2.rownr, ]
    #.......................................................................................................
    [ left_colnr, right_colnr, ] = [ right_colnr, left_colnr, ] if right_colnr < left_colnr
    [ top_rownr, bottom_rownr, ] = [ bottom_rownr, top_rownr, ] if bottom_rownr < top_rownr
  #.........................................................................................................
  return { '~isa:': 'INTERGRID/rangeref', left_colnr, right_colnr, top_rownr, bottom_rownr, }


