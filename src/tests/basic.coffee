




'use strict'


############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERGRID/TESTS'
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
TAP                       = require 'tap'
eq                        = CND.equals
jr                        = JSON.stringify
#...........................................................................................................
INTERGRID                 = require '../..'

#-----------------------------------------------------------------------------------------------------------
TAP.test "INTERGRID.A1LETTERS.get_letters 1", ( T ) ->
  probes_and_matchers = [
    [1,"X"]
    [2,"Y"]
    [3,"Z"]
    [4,"XX"]
    [5,"XY"]
    [6,"XZ"]
    [7,"YX"]
    [8,"YY"]
    [9,"YZ"]
    [10,"ZX"]
    [26,"YYY"]
    [27,"YYZ"]
    [28,"YZX"]
    [29,"YZY"]
    [51,"XYXZ"]
    [52,"XYYX"]
    [53,"XYYY"]
    [100,"ZXZX"]
    [1000,"ZYZYZX"]
  ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    result = INTERGRID.A1LETTERS.get_letters probe, ['X','Y','Z']
    # urge '36633', ( jr [ probe, result, ] )
    T.ok eq result, matcher
  #.........................................................................................................
  T.end()

#-----------------------------------------------------------------------------------------------------------
TAP.test "INTERGRID.A1LETTERS.get_letters 2", ( T ) ->
  probes_and_matchers = [
    [1,"a"]
    [2,"b"]
    [3,"c"]
    [4,"d"]
    [5,"e"]
    [6,"f"]
    [7,"g"]
    [8,"h"]
    [9,"i"]
    [10,"j"]
    [26,"z"]
    [27,"aa"]
    [28,"ab"]
    [29,"ac"]
    [51,"ay"]
    [52,"az"]
    [53,"ba"]
    [100,"cv"]
    [1000,"all"]
  ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    result = INTERGRID.A1LETTERS.get_letters probe
    urge '36633', ( jr [ probe, result, ] )
    T.ok eq result, matcher
  #.........................................................................................................
  T.end()

#-----------------------------------------------------------------------------------------------------------
TAP.test "INTERGRID.A1LETTERS.get_number 1", ( T ) ->
  probes_and_matchers = [
    ["X",1]
    ["Y",2]
    ["Z",3]
    ["XX",4]
    ["XY",5]
    ["XZ",6]
    ["YX",7]
    ["YY",8]
    ["YZ",9]
    ["ZX",10]
    ["YYY",26]
    ["YYZ",27]
    ["YZX",28]
    ["YZY",29]
    ["XYXZ",51]
    ["XYYX",52]
    ["XYYY",53]
    ["ZXZX",100]
    ["ZYZYZX",1000]
  ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    result = INTERGRID.A1LETTERS.get_number probe, ['X','Y','Z']
    urge '36633', ( jr [ probe, result, ] )
    T.ok eq result, matcher
  #.........................................................................................................
  T.end()

#-----------------------------------------------------------------------------------------------------------
TAP.test "INTERGRID.A1LETTERS.get_number 2", ( T ) ->
  probes_and_matchers = [
    ["a",1]
    ["b",2]
    ["c",3]
    ["d",4]
    ["e",5]
    ["f",6]
    ["g",7]
    ["h",8]
    ["i",9]
    ["j",10]
    ["z",26]
    ["aa",27]
    ["ab",28]
    ["ac",29]
    ["ay",51]
    ["az",52]
    ["ba",53]
    ["cv",100]
    ["all",1000]
  ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    result = INTERGRID.A1LETTERS.get_number probe
    urge '36633', ( jr [ probe, result, ] )
    T.ok eq result, matcher
  #.........................................................................................................
  T.end()


# #-----------------------------------------------------------------------------------------------------------
# TAP.test "recognize_cell_format", ( T ) ->
#   probes_and_matchers = [
#     ['a1','']
#   ]
#   T.ok eq 1, 1
#   #.........................................................................................................
#   T.end()



