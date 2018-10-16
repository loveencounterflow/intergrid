




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
test                      = require 'guy-test'
eq                        = CND.equals
jr                        = JSON.stringify
#...........................................................................................................
INTERGRID                 = require '../..'

#-----------------------------------------------------------------------------------------------------------
@_prune = ->
  for name, value of @
    continue if name.startsWith '_'
    delete @[ name ] unless name in include
  return null

#-----------------------------------------------------------------------------------------------------------
@_main = ->
  test @, 'timeout': 30000

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1LETTERS.get_letters 1" ] = ( T, done ) ->
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
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1LETTERS.get_letters 2" ] = ( T, done ) ->
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
    # urge '36633', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1LETTERS.get_number 1" ] = ( T, done ) ->
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
    # urge '36633', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1LETTERS.get_number 2" ] = ( T, done ) ->
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
    # urge '36633', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1CELLS.get_cellref" ] = ( T, done ) ->
  probes_and_matchers = [
    ["a1",{"rownr":1,"colnr":1,"cellkey":"a1","letters":"a","digits":"1"}]
    ["b1",{"rownr":1,"colnr":2,"cellkey":"b1","letters":"b","digits":"1"}]
    ["c1",{"rownr":1,"colnr":3,"cellkey":"c1","letters":"c","digits":"1"}]
    ["d1",{"rownr":1,"colnr":4,"cellkey":"d1","letters":"d","digits":"1"}]
    ["e1",{"rownr":1,"colnr":5,"cellkey":"e1","letters":"e","digits":"1"}]
    ["f1",{"rownr":1,"colnr":6,"cellkey":"f1","letters":"f","digits":"1"}]
    ["g1",{"rownr":1,"colnr":7,"cellkey":"g1","letters":"g","digits":"1"}]
    ["h1",{"rownr":1,"colnr":8,"cellkey":"h1","letters":"h","digits":"1"}]
    ["i1",{"rownr":1,"colnr":9,"cellkey":"i1","letters":"i","digits":"1"}]
    ["j1",{"rownr":1,"colnr":10,"cellkey":"j1","letters":"j","digits":"1"}]
    ["z1",{"rownr":1,"colnr":26,"cellkey":"z1","letters":"z","digits":"1"}]
    ["aa1",{"rownr":1,"colnr":27,"cellkey":"aa1","letters":"aa","digits":"1"}]
    ["ab1",{"rownr":1,"colnr":28,"cellkey":"ab1","letters":"ab","digits":"1"}]
    ["ac1",{"rownr":1,"colnr":29,"cellkey":"ac1","letters":"ac","digits":"1"}]
    ["ay1",{"rownr":1,"colnr":51,"cellkey":"ay1","letters":"ay","digits":"1"}]
    ["az1",{"rownr":1,"colnr":52,"cellkey":"az1","letters":"az","digits":"1"}]
    ["ba1",{"rownr":1,"colnr":53,"cellkey":"ba1","letters":"ba","digits":"1"}]
    ["cv1",{"rownr":1,"colnr":100,"cellkey":"cv1","letters":"cv","digits":"1"}]
    ["all1",{"rownr":1,"colnr":1000,"cellkey":"all1","letters":"all","digits":"1"}]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.A1CELLS.get_cellref probe
    catch error
      T.fail error.message
      continue
    # urge '77811', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1CELLS cellref pattern" ] = ( T, done ) ->
  probes_and_matchers = [
    ["*",{"star":"*"}]
    ["**",{"colstar":"*","rowstar":"*"}]
    ["a1",{"colletters":"a","rowdigits":"1"}]
    ["-a1",{"colsign":"-","colletters":"a","rowdigits":"1"}]
    ["a-1",{"colletters":"a","rowsign":"-","rowdigits":"1"}]
    ["-a-1",{"colsign":"-","colletters":"a","rowsign":"-","rowdigits":"1"}]
    ["+a1",{"colsign":"+","colletters":"a","rowdigits":"1"}]
    ["a+1",{"colletters":"a","rowsign":"+","rowdigits":"1"}]
    ["+a+1",{"colsign":"+","colletters":"a","rowsign":"+","rowdigits":"1"}]
    ["+a-1",{"colsign":"+","colletters":"a","rowsign":"-","rowdigits":"1"}]
    ["++a-1",null]
    ["***",null]
    ["+*1",null]
    ["-*1",null]
    ]
  #.........................................................................................................
  debug '777855', INTERGRID.A1CELLS.settings.patterns.a1_lowercase
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = probe.match INTERGRID.A1CELLS.settings.patterns.a1_lowercase
    catch error
      T.fail error.message
      continue
    if result?
      result = result.groups
      ( delete result[ key ] if result[ key ] in [ '', undefined, ] ) for key of result
    # urge '77811', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1CELLS.parse_cellkey" ] = ( T, done ) ->
  probes_and_matchers = [
    ["*",{"star":"*","colstar":"*","rowstar":"*"}]
    ["**",{"star":"*","colstar":"*","rowstar":"*"}]
    ["a1",{"colletters":"a","rowdigits":"1"}]
    ["-a1",{"colsign":"-","colletters":"a","rowdigits":"1"}]
    ["a-1",{"colletters":"a","rowsign":"-","rowdigits":"1"}]
    ["-a-1",{"colsign":"-","colletters":"a","rowsign":"-","rowdigits":"1"}]
    ["+a01",{"colletters":"a","rowdigits":"1"}]
    ["a*",{"colletters":"a","rowstar":"*"}]
    ["+a*",{"colletters":"a","rowstar":"*"}]
    ["-a*",{"colsign":"-","colletters":"a","rowstar":"*"}]
    ["*1",{"colstar":"*","rowdigits":"1"}]
    ["*+12",{"colstar":"*","rowdigits":"12"}]
    ["*+00012",{"colstar":"*","rowdigits":"12"}]
    ["*-2",{"colstar":"*","rowsign":"-","rowdigits":"2"}]
    ["a+1",{"colletters":"a","rowdigits":"1"}]
    ["+a+1",{"colletters":"a","rowdigits":"1"}]
    ["+a-1",{"colletters":"a","rowsign":"-","rowdigits":"1"}]
    ["+abc-123",{"colletters":"abc","rowsign":"-","rowdigits":"123"}]
    ["+abc-0000123",{"colletters":"abc","rowsign":"-","rowdigits":"123"}]
    ["++a-1",null]
    ["***",null]
    ["+*1",null]
    ["-*1",null]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.A1CELLS.parse_cellkey probe
    catch error
      if ( matcher is null ) and ( error.message.match /expected a cellkey like 'a1', '\*', '\*4' or 'c-1, got '/ )?
        urge '77812', ( jr [ probe, null, ] )
        T.ok true
      else
        T.fail error.message
      continue
    urge '77812', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.A1CELLS.get_cellkey" ] = ( T, done ) ->
  probes_and_matchers = [
    [{"rownr":1,"colnr":1},"a1"]
    [{"rownr":1,"colnr":2},"b1"]
    [{"rownr":1,"colnr":3},"c1"]
    [{"rownr":1,"colnr":4},"d1"]
    [{"rownr":1,"colnr":5},"e1"]
    [{"rownr":1,"colnr":6},"f1"]
    [{"rownr":1,"colnr":7},"g1"]
    [{"rownr":1,"colnr":8},"h1"]
    [{"rownr":1,"colnr":9},"i1"]
    [{"rownr":1,"colnr":10},"j1"]
    [{"rownr":1,"colnr":26},"z1"]
    [{"rownr":1,"colnr":27},"aa1"]
    [{"rownr":1,"colnr":28},"ab1"]
    [{"rownr":1,"colnr":29},"ac1"]
    [{"rownr":1,"colnr":51},"ay1"]
    [{"rownr":1,"colnr":52},"az1"]
    [{"rownr":1,"colnr":53},"ba1"]
    [{"rownr":1,"colnr":100},"cv1"]
    [{"rownr":1,"colnr":1000},"all1"]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.A1CELLS.get_cellkey probe
    catch error
      T.fail error.message
      continue
    urge '77811', ( jr [ probe, result, ] )
    # T.eq result, matcher
  #.........................................................................................................
  done()



############################################################################################################
unless module.parent?
  include = [
    "INTERGRID.A1LETTERS.get_letters 1"
    "INTERGRID.A1LETTERS.get_letters 2"
    "INTERGRID.A1LETTERS.get_number 1"
    "INTERGRID.A1LETTERS.get_number 2"
    "INTERGRID.A1CELLS cellref pattern"
    "INTERGRID.A1CELLS.parse_cellkey"
    # "INTERGRID.A1CELLS.get_cellref"
    # "INTERGRID.A1CELLS.get_cellkey"
    ]
  @_prune()
  @_main()








