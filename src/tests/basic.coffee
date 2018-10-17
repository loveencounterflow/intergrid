




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
@[ "INTERGRID.LETTERS.get_letters 1" ] = ( T, done ) ->
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
    result = INTERGRID.LETTERS.get_letters probe, ['X','Y','Z']
    # urge '36633', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.LETTERS.get_letters 2" ] = ( T, done ) ->
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
    result = INTERGRID.LETTERS.get_letters probe
    # urge '36633', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.LETTERS.get_number 1" ] = ( T, done ) ->
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
    result = INTERGRID.LETTERS.get_number probe, ['X','Y','Z']
    # urge '36633', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.LETTERS.get_number 2" ] = ( T, done ) ->
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
    result = INTERGRID.LETTERS.get_number probe
    # urge '36633', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS cellref pattern" ] = ( T, done ) ->
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
  debug '777855', INTERGRID.CELLS.settings.patterns.a1_lowercase
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = probe.match INTERGRID.CELLS.settings.patterns.a1_lowercase
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
@[ "INTERGRID.CELLS.parse_cellkey" ] = ( T, done ) ->
  probes_and_matchers = [
    ["*",{"star":"*","colstar":"*","rowstar":"*"}]
    ["**",{"colstar":"*","rowstar":"*","star":"*"}]
    ["a1",{"colletters":"a","rowdigits":"1","colnr":1,"rownr":1}]
    ["-a1",{"colsign":"-","colletters":"a","rowdigits":"1","colnr":-1,"rownr":1}]
    ["a-1",{"colletters":"a","rowsign":"-","rowdigits":"1","colnr":1,"rownr":-1}]
    ["-a-1",{"colsign":"-","colletters":"a","rowsign":"-","rowdigits":"1","colnr":-1,"rownr":-1}]
    ["+a01",{"colletters":"a","rowdigits":"1","colnr":1,"rownr":1}]
    ["a*",{"colletters":"a","rowstar":"*","colnr":1}]
    ["+a*",{"colletters":"a","rowstar":"*","colnr":1}]
    ["-a*",{"colsign":"-","colletters":"a","rowstar":"*","colnr":-1}]
    ["*1",{"colstar":"*","rowdigits":"1","rownr":1}]
    ["*+12",{"colstar":"*","rowdigits":"12","rownr":12}]
    ["*+00012",{"colstar":"*","rowdigits":"12","rownr":12}]
    ["*-2",{"colstar":"*","rowsign":"-","rowdigits":"2","rownr":-2}]
    ["a+1",{"colletters":"a","rowdigits":"1","colnr":1,"rownr":1}]
    ["+a+1",{"colletters":"a","rowdigits":"1","colnr":1,"rownr":1}]
    ["+a-1",{"colletters":"a","rowsign":"-","rowdigits":"1","colnr":1,"rownr":-1}]
    ["+abc-123",{"colletters":"abc","rowsign":"-","rowdigits":"123","colnr":731,"rownr":-123}]
    ["+abc-0000123",{"colletters":"abc","rowsign":"-","rowdigits":"123","colnr":731,"rownr":-123}]
    ["z1",{"colletters":"z","rowdigits":"1","colnr":26,"rownr":1}]
    ["aa1",{"colletters":"aa","rowdigits":"1","colnr":27,"rownr":1}]
    ["ab1",{"colletters":"ab","rowdigits":"1","colnr":28,"rownr":1}]
    ["ac1",{"colletters":"ac","rowdigits":"1","colnr":29,"rownr":1}]
    ["ay1",{"colletters":"ay","rowdigits":"1","colnr":51,"rownr":1}]
    ["az1",{"colletters":"az","rowdigits":"1","colnr":52,"rownr":1}]
    ["ba1",{"colletters":"ba","rowdigits":"1","colnr":53,"rownr":1}]
    ["cv1",{"colletters":"cv","rowdigits":"1","colnr":100,"rownr":1}]
    ["all1",{"colletters":"all","rowdigits":"1","colnr":1000,"rownr":1}]
    ["++a-1",null]
    ["***",null]
    ["+*1",null]
    ["-*1",null]
    ["whassupman1",{ colletters: 'whassupman',  rowdigits: '1',  colnr: 126563337975660,  rownr: 1 }]
   ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.CELLS.parse_cellkey probe
    catch error
      if ( matcher is null ) and ( error.message.match /expected a cellkey like 'a1', '\*', '\*4' or 'c-1, got '/ )?
        # urge '77812', ( jr [ probe, null, ] )
        T.ok true
      else
        T.fail error.message
      continue
    # urge '77812', ( jr [ probe, result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS.get_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [{"colnr":1,"rownr":1},"a1"]
    [{"colnr":2,"rownr":1},"b1"]
    [{"colnr":3,"rownr":1},"c1"]
    [{"colnr":4,"rownr":1},"d1"]
    [{"colnr":5,"rownr":1},"e1"]
    [{"colnr":6,"rownr":1},"f1"]
    [{"colnr":7,"rownr":1},"g1"]
    [{"colnr":8,"rownr":1},"h1"]
    [{"colnr":9,"rownr":1},"i1"]
    [{"colnr":10,"rownr":1},"j1"]
    [{"colnr":26,"rownr":1},"z1"]
    [{"colnr":27,"rownr":1},"aa1"]
    [{"colnr":28,"rownr":1},"ab1"]
    [{"colnr":29,"rownr":1},"ac1"]
    [{"colnr":51,"rownr":1},"ay1"]
    [{"colnr":52,"rownr":1},"az1"]
    [{"colnr":53,"rownr":1},"ba1"]
    [{"colnr":100,"rownr":1},"cv1"]
    [{"colnr":1000,"rownr":1},"all1"]
    [{"colnr":Number.MAX_SAFE_INTEGER,"rownr":53},"bktxhsoghkke53"]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.CELLS.get_cellkey probe
    catch error
      T.fail error.message
      continue
    # urge '77811', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS.get_cellkey 2" ] = ( T, done ) ->
  probes_and_matchers = [
    ["a1","a1"]
    ["b1","b1"]
    ["c1","c1"]
    ["d1","d1"]
    ["e1","e1"]
    ["f1","f1"]
    ["g1","g1"]
    ["h1","h1"]
    ["i1","i1"]
    ["j1","j1"]
    ["z1","z1"]
    ["aa1","aa1"]
    ["ab1","ab1"]
    ["ac1","ac1"]
    ["ay1","ay1"]
    ["az1","az1"]
    ["ba1","ba1"]
    ["cv1","cv1"]
    ["all1","all1"]
    ["+a1","a1"]
    ["+b1","b1"]
    ["+c1","c1"]
    ["+d1","d1"]
    ["+e1","e1"]
    ["+f1","f1"]
    ["+g1","g1"]
    ["+h1","h1"]
    ["+i1","i1"]
    ["+j1","j1"]
    ["+z1","z1"]
    ["+aa1","aa1"]
    ["+ab1","ab1"]
    ["+ac1","ac1"]
    ["+ay1","ay1"]
    ["+az1","az1"]
    ["+ba1","ba1"]
    ["+cv1","cv1"]
    ["+all1","all1"]
    ["+a+012","a12"]
    ["+b+012","b12"]
    ["+c+012","c12"]
    ["+d+012","d12"]
    ["+e+012","e12"]
    ["+f+012","f12"]
    ["+g+012","g12"]
    ["+h+012","h12"]
    ["+i+012","i12"]
    ["+j+012","j12"]
    ["+z+012","z12"]
    ["+aa+012","aa12"]
    ["+ab+012","ab12"]
    ["+ac+012","ac12"]
    ["+ay+012","ay12"]
    ["+az+012","az12"]
    ["+ba+012","ba12"]
    ["+cv+012","cv12"]
    ["+all+012","all12"]
    ["-all1","-all1"]
    ["-a+012","-a12"]
    ["-b+012","-b12"]
    ["-c+012","-c12"]
    ["-d+012","-d12"]
    ["-e+012","-e12"]
    ["-f+012","-f12"]
    ["-g+012","-g12"]
    ["-h+012","-h12"]
    ["-i+012","-i12"]
    ["-j+012","-j12"]
    ["-z+012","-z12"]
    ["-aa+012","-aa12"]
    ["-ab+012","-ab12"]
    ["-ac+012","-ac12"]
    ["-ay+012","-ay12"]
    ["-az+012","-az12"]
    ["-ba+012","-ba12"]
    ["-cv+012","-cv12"]
    ["-all+012","-all12"]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result_1 = INTERGRID.CELLS.get_cellkey INTERGRID.CELLS.parse_cellkey probe
    catch error
      T.fail error.message
      continue
    # urge '77811', ( jr [ probe, result_1, ] )
    T.eq result_1, matcher
    result_2 = INTERGRID.CELLS.normalize_cellkey probe
    T.eq result_2, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS.get_cellkey 3" ] = ( T, done ) ->
  probes_and_matchers = [
    [{},"*"]
    [{"colstar":"*"},"*"]
    [{"rowstar":"*"},"*"]
    [{"colstar":"*","rowstar":"*"},"*"]
    [{"star":"*"},"*"]
    [{"colnr":10,"rowstar":"*"},"j*"]
    [{"colnr":26,"rowstar":"*"},"z*"]
    [{"colnr":27,"rowstar":"*"},"aa*"]
    [{"colnr":53,"rowstar":"*"},"ba*"]
    [{"colnr":100,"rowstar":"*"},"cv*"]
    [{"colnr":1000,"rowstar":"*"},"all*"]
    [{"colnr":-10,"rowstar":"*"},"-j*"]
    [{"colnr":-26,"rowstar":"*"},"-z*"]
    [{"colnr":-27,"rowstar":"*"},"-aa*"]
    [{"colnr":-53,"rowstar":"*"},"-ba*"]
    [{"colnr":-100,"rowstar":"*"},"-cv*"]
    [{"colnr":-1000,"rowstar":"*"},"-all*"]
    [{"colnr":10},"j*"]
    [{"colnr":26},"z*"]
    [{"colnr":27},"aa*"]
    [{"colnr":53},"ba*"]
    [{"colnr":100},"cv*"]
    [{"colnr":1000},"all*"]
    [{"colnr":-10},"-j*"]
    [{"colnr":-26},"-z*"]
    [{"colnr":-27},"-aa*"]
    [{"colnr":-53},"-ba*"]
    [{"colnr":-100},"-cv*"]
    [{"colnr":-1000},"-all*"]
    [{"rownr":10},"*10"]
    [{"rownr":26},"*26"]
    [{"rownr":27},"*27"]
    [{"rownr":53},"*53"]
    [{"rownr":100},"*100"]
    [{"rownr":1000},"*1000"]
    [{"rownr":-10},"*-10"]
    [{"rownr":-26},"*-26"]
    [{"rownr":-27},"*-27"]
    [{"rownr":-53},"*-53"]
    [{"rownr":-100},"*-100"]
    [{"rownr":-1000},"*-1000"]
    [{"rownr":10,"colstar":"*"},"*10"]
    [{"rownr":26,"colstar":"*"},"*26"]
    [{"rownr":27,"colstar":"*"},"*27"]
    [{"rownr":53,"colstar":"*"},"*53"]
    [{"rownr":100,"colstar":"*"},"*100"]
    [{"rownr":1000,"colstar":"*"},"*1000"]
    [{"rownr":-10,"colstar":"*"},"*-10"]
    [{"rownr":-26,"colstar":"*"},"*-26"]
    [{"rownr":-27,"colstar":"*"},"*-27"]
    [{"rownr":-53,"colstar":"*"},"*-53"]
    [{"rownr":-100,"colstar":"*"},"*-100"]
    [{"rownr":-1000,"colstar":"*"},"*-1000"]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.CELLS.get_cellkey probe
    catch error
      T.fail "probe #{jr probe}: #{error.message}"
      continue
    # urge '77811', ( jr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.new_grid_from_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    ["d4",{"~isa":"INTERGRID/GRID/grid","width":4,"height":4}]
    ["a1",{"~isa":"INTERGRID/GRID/grid","width":1,"height":1}]
    ["c-5",{"~isa":"INTERGRID/GRID/grid","width":3,"height":5}]
    ["-c-5",{"~isa":"INTERGRID/GRID/grid","width":3,"height":5}]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.GRID.new_grid_from_cellkey probe
    catch error
      if ( matcher is null ) and ( error.message.match /expected a cellkey like 'a1', '\*', '\*4' or 'c-1, got '/ )?
        # urge '77812', ( jr [ probe, null, ] )
        T.ok true
      else
        T.fail error.message
      continue
    urge '77812', ( jr [ probe, result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    # T.eq result, matcher
  #.........................................................................................................
  done()

# #-----------------------------------------------------------------------------------------------------------
# @[ "INTERGRID.GRID.abs_cellref 1" ] = ( T, done ) ->
#   probes_and_matchers = [
#     ["d4",{"~isa":"INTERGRID/GRID/grid","width":4,"height":4}]
#     ["a1",{"~isa":"INTERGRID/GRID/grid","width":1,"height":1}]
#     ["c-5",{"~isa":"INTERGRID/GRID/grid","width":3,"height":5}]
#     ["-c-5",{"~isa":"INTERGRID/GRID/grid","width":3,"height":5}]
#     ]
#   #.........................................................................................................
#   for [ probe, matcher, ] in probes_and_matchers
#     try
#       result = INTERGRID.GRID.new_grid_from_cellkey probe
#     catch error
#       if ( matcher is null ) and ( error.message.match /expected a cellkey like 'a1', '\*', '\*4' or 'c-1, got '/ )?
#         # urge '77812', ( jr [ probe, null, ] )
#         T.ok true
#       else
#         T.fail error.message
#       continue
#     urge '77812', ( jr [ probe, result, ] )
#     # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
#     # T.eq result, matcher
#   #.........................................................................................................
#   done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.abs_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [["d4","a1"],"a1"]
    [["a1","a1"],"a1"]
    [["c-5","b11"],null]
    [["-c-5","b11"],null]
    [["c-12","b11"],"b11"]
    [["-c-12","b11"],"b11"]
    [["d4","-a1"],"d1"]
    [["d4","-a-1"],"d4"]
    [["d4","a-1"],"a4"]
    ]
  #.........................................................................................................
  for [ [ grid_probe, cellkey_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    try
      result = INTERGRID.GRID.abs_cellkey grid, cellkey_probe
    catch error
      if ( matcher is null ) and ( error.message.match /row nr [0-9]+ exceeds grid height [0-9]+/ )?
        # urge '77812', ( jr [ probe, null, ] )
        urge '77812', ( jr [ [ grid_probe, cellkey_probe, ], result, ] )
        T.ok true
      else
        T.fail error.message
      continue
    urge '77812', ( jr [ [ grid_probe, cellkey_probe, ], result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.parse_rangekey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [["a1","b2..a1"],null]
    [["c-5","b1..c12"],null]
    [["-c-5","b1..c12"],null]
    [["d4","a1..b2"],{"topleft":"a1","topright":"b1","bottomleft":"a2","bottomright":"b2"}]
    [["c-12","a1..b11"],{"topleft":"a1","topright":"b1","bottomleft":"a11","bottomright":"b11"}]
    [["-c-12","a1..b11"],{"topleft":"b1","topright":"a1","bottomleft":"b11","bottomright":"a11"}]
    [["d4","-a1..c3"],{"topleft":"a1","topright":"b1","bottomleft":"a11","bottomright":"b11"}]
    [["d4","-a-1..c3"],{"topleft":"c3","topright":"d3","bottomleft":"c4","bottomright":"d4"}]
    [["d4","-a-1..a1"],{"topleft":"a1","topright":"d1","bottomleft":"a4","bottomright":"d4"}]
    ]
  #.........................................................................................................
  for [ [ grid_probe, rangekey_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    try
      result = INTERGRID.GRID.parse_rangekey grid, rangekey_probe
    catch error
      urge '77812', ( jr [ [ grid_probe, rangekey_probe, ], result, ] )
      if ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
        # urge '77812', ( jr [ probe, null, ] )
        T.ok true
      else
        # throw error
        T.fail "#{rpr [ grid_probe, rangekey_probe ]} failed with #{error.message}"
      continue
    urge '77812', ( jr [ [ grid_probe, rangekey_probe, ], result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.parse_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [["d4","d5"],null]
    [["d4","e4"],null]
    [["d4","b1"],{"colletters":"b","rowdigits":"1","colnr":2,"rownr":1}]
    [["d4","-b1"],{"colletters":"c","rowdigits":"3","colnr":3,"rownr":3}]
    [["d4","a1"],{"colletters":"a","rowdigits":"1","colnr":1,"rownr":1}]
    [["d4","c3"],{"colletters":"c","rowdigits":"3","colnr":3,"rownr":3}]
    [["d4","-a1"],{"colletters":"d","rowdigits":"1","colnr":4,"rownr":1}]
    [["d4","-a-1"],{"colletters":"d","rowdigits":"4","colnr":4,"rownr":4}]
    ]
  #.........................................................................................................
  for [ [ grid_probe, rangekey_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    try
      result = INTERGRID.GRID.parse_cellkey grid, rangekey_probe
    catch error
      urge '77812', ( jr [ [ grid_probe, rangekey_probe, ], result, ] )
      if ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
        # urge '77812', ( jr [ probe, null, ] )
        T.ok true
      else
        # throw error
        T.fail "#{rpr [ grid_probe, rangekey_probe ]} failed with #{error.message}"
      continue
    urge '77812', ( jr [ [ grid_probe, rangekey_probe, ], result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()


############################################################################################################
unless module.parent?
  include = [
    # "INTERGRID.LETTERS.get_letters 1"
    # "INTERGRID.LETTERS.get_letters 2"
    # "INTERGRID.LETTERS.get_number 1"
    # "INTERGRID.LETTERS.get_number 2"
    # "INTERGRID.CELLS cellref pattern"
    # "INTERGRID.CELLS.parse_cellkey"
    # "INTERGRID.CELLS.get_cellkey 1"
    # "INTERGRID.CELLS.get_cellkey 2"
    # "INTERGRID.CELLS.get_cellkey 3"
    # "INTERGRID.GRID.new_grid_from_cellkey 1"
    # "INTERGRID.GRID.abs_cellref 1"
    # "INTERGRID.GRID.abs_cellkey 1"
    # "INTERGRID.GRID.parse_rangekey 1"
    "INTERGRID.GRID.parse_cellkey 1"
    ]
  @_prune()
  @_main()








