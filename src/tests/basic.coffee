
'use strict'


############################################################################################################
GUY                       = require 'guy'
{ debug
  info
  warn
  urge
  help }                  = GUY.trm.get_loggers 'INTERGRID/TESTS/basic'
{ rpr }                   = GUY.trm
#...........................................................................................................
test                      = require 'guy-test'
INTERGRID                 = require '../..'
types                     = require '../types'


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
    # urge '36633', ( rpr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.LETTERS.get_letters 2" ] = ( T, done ) ->
  probes_and_matchers = [
    [1,"A"]
    [2,"B"]
    [3,"C"]
    [4,"D"]
    [5,"E"]
    [6,"F"]
    [7,"G"]
    [8,"H"]
    [9,"I"]
    [10,"J"]
    [26,"Z"]
    [27,"AA"]
    [28,"AB"]
    [29,"AC"]
    [51,"AY"]
    [52,"AZ"]
    [53,"BA"]
    [100,"CV"]
    [1000,"ALL"]
  ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    result = INTERGRID.LETTERS.get_letters probe
    # urge '36633', ( rpr [ probe, result, ] )
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
    # urge '36633', ( rpr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.LETTERS.get_number 2" ] = ( T, done ) ->
  probes_and_matchers = [
    ["A",1]
    ["B",2]
    ["C",3]
    ["D",4]
    ["E",5]
    ["F",6]
    ["G",7]
    ["H",8]
    ["I",9]
    ["J",10]
    ["Z",26]
    ["AA",27]
    ["AB",28]
    ["AC",29]
    ["AY",51]
    ["AZ",52]
    ["BA",53]
    ["CV",100]
    ["ALL",1000]
  ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    result = INTERGRID.LETTERS.get_number probe
    # urge '36633', ( rpr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS cellref pattern" ] = ( T, done ) ->
  probes_and_matchers = [
    ["*",{"star":"*"}]
    ["**",{"colstar":"*","rowstar":"*"}]
    ["A1",{"colletters":"A","rowdigits":"1"}]
    ["-A1",{"colsign":"-","colletters":"A","rowdigits":"1"}]
    ["A-1",{"colletters":"A","rowsign":"-","rowdigits":"1"}]
    ["-A-1",{"colsign":"-","colletters":"A","rowsign":"-","rowdigits":"1"}]
    ["+A1",{"colsign":"+","colletters":"A","rowdigits":"1"}]
    ["A+1",{"colletters":"A","rowsign":"+","rowdigits":"1"}]
    ["+A+1",{"colsign":"+","colletters":"A","rowsign":"+","rowdigits":"1"}]
    ["+A-1",{"colsign":"+","colletters":"A","rowsign":"-","rowdigits":"1"}]
    ["++A-1",null]
    ["***",null]
    ["+*1",null]
    ["-*1",null]
    ]
  #.........................................................................................................
  debug '777855', INTERGRID.CELLS.settings.patterns.a1_uppercase
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = probe.match INTERGRID.CELLS.settings.patterns.a1_uppercase
    catch error
      T.fail error.message
      continue
    if result?
      result = result.groups
      ( delete result[ key ] if result[ key ] in [ '', undefined, ] ) for key of result
    # urge '77811', ( rpr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS.parse_cellkey" ] = ( T, done ) ->
  probes_and_matchers = [
    ["*",{"~isa":"INTERGRID/cellref","star":"*","colstar":"*","rowstar":"*","cellkey":"*"}]
    ["**",{"~isa":"INTERGRID/cellref","colstar":"*","rowstar":"*","star":"*","cellkey":"*"}]
    ["A1",{"~isa":"INTERGRID/cellref","colletters":"A","rowdigits":"1","colnr":1,"rownr":1,"cellkey":"A1"}]
    ["-A1",{"~isa":"INTERGRID/cellref","colsign":"-","colletters":"A","rowdigits":"1","colnr":-1,"rownr":1,"cellkey":"-A1"}]
    ["A-1",{"~isa":"INTERGRID/cellref","colletters":"A","rowsign":"-","rowdigits":"1","colnr":1,"rownr":-1,"cellkey":"A-1"}]
    ["-A-1",{"~isa":"INTERGRID/cellref","colsign":"-","colletters":"A","rowsign":"-","rowdigits":"1","colnr":-1,"rownr":-1,"cellkey":"-A-1"}]
    ["+A01",{"~isa":"INTERGRID/cellref","colletters":"A","rowdigits":"1","colnr":1,"rownr":1,"cellkey":"A1"}]
    ["A*",{"~isa":"INTERGRID/cellref","colletters":"A","rowstar":"*","colnr":1,"cellkey":"A*"}]
    ["+A*",{"~isa":"INTERGRID/cellref","colletters":"A","rowstar":"*","colnr":1,"cellkey":"A*"}]
    ["-A*",{"~isa":"INTERGRID/cellref","colsign":"-","colletters":"A","rowstar":"*","colnr":-1,"cellkey":"-A*"}]
    ["*1",{"~isa":"INTERGRID/cellref","colstar":"*","rowdigits":"1","rownr":1,"cellkey":"*1"}]
    ["*+12",{"~isa":"INTERGRID/cellref","colstar":"*","rowdigits":"12","rownr":12,"cellkey":"*12"}]
    ["*+00012",{"~isa":"INTERGRID/cellref","colstar":"*","rowdigits":"12","rownr":12,"cellkey":"*12"}]
    ["*-2",{"~isa":"INTERGRID/cellref","colstar":"*","rowsign":"-","rowdigits":"2","rownr":-2,"cellkey":"*-2"}]
    ["A+1",{"~isa":"INTERGRID/cellref","colletters":"A","rowdigits":"1","colnr":1,"rownr":1,"cellkey":"A1"}]
    ["+A+1",{"~isa":"INTERGRID/cellref","colletters":"A","rowdigits":"1","colnr":1,"rownr":1,"cellkey":"A1"}]
    ["+A-1",{"~isa":"INTERGRID/cellref","colletters":"A","rowsign":"-","rowdigits":"1","colnr":1,"rownr":-1,"cellkey":"A-1"}]
    ["+ABC-123",{"~isa":"INTERGRID/cellref","colletters":"ABC","rowsign":"-","rowdigits":"123","colnr":731,"rownr":-123,"cellkey":"ABC-123"}]
    ["+ABC-0000123",{"~isa":"INTERGRID/cellref","colletters":"ABC","rowsign":"-","rowdigits":"123","colnr":731,"rownr":-123,"cellkey":"ABC-123"}]
    ["Z1",{"~isa":"INTERGRID/cellref","colletters":"Z","rowdigits":"1","colnr":26,"rownr":1,"cellkey":"Z1"}]
    ["AA1",{"~isa":"INTERGRID/cellref","colletters":"AA","rowdigits":"1","colnr":27,"rownr":1,"cellkey":"AA1"}]
    ["AB1",{"~isa":"INTERGRID/cellref","colletters":"AB","rowdigits":"1","colnr":28,"rownr":1,"cellkey":"AB1"}]
    ["AC1",{"~isa":"INTERGRID/cellref","colletters":"AC","rowdigits":"1","colnr":29,"rownr":1,"cellkey":"AC1"}]
    ["AY1",{"~isa":"INTERGRID/cellref","colletters":"AY","rowdigits":"1","colnr":51,"rownr":1,"cellkey":"AY1"}]
    ["AZ1",{"~isa":"INTERGRID/cellref","colletters":"AZ","rowdigits":"1","colnr":52,"rownr":1,"cellkey":"AZ1"}]
    ["BA1",{"~isa":"INTERGRID/cellref","colletters":"BA","rowdigits":"1","colnr":53,"rownr":1,"cellkey":"BA1"}]
    ["CV1",{"~isa":"INTERGRID/cellref","colletters":"CV","rowdigits":"1","colnr":100,"rownr":1,"cellkey":"CV1"}]
    ["ALL1",{"~isa":"INTERGRID/cellref","colletters":"ALL","rowdigits":"1","colnr":1000,"rownr":1,"cellkey":"ALL1"}]
    ["WHASSUPMAN1",{"~isa":"INTERGRID/cellref","colletters":"WHASSUPMAN","rowdigits":"1","colnr":126563337975660,"rownr":1,"cellkey":"WHASSUPMAN1"}]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.CELLS.parse_cellkey probe
    catch error
      if ( matcher is null ) and ( error.message.match /expected a cellkey like 'A1', '\*', '\*4' or 'C-1, got '/ )?
        # urge '77812', ( rpr [ probe, null, ] )
        T.ok true
      else
        T.fail error.message
      continue
    # urge '77812', ( rpr [ probe, result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS.get_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [{"colnr":1,"rownr":1},"A1"]
    [{"colnr":2,"rownr":1},"B1"]
    [{"colnr":3,"rownr":1},"C1"]
    [{"colnr":4,"rownr":1},"D1"]
    [{"colnr":5,"rownr":1},"E1"]
    [{"colnr":6,"rownr":1},"F1"]
    [{"colnr":7,"rownr":1},"G1"]
    [{"colnr":8,"rownr":1},"H1"]
    [{"colnr":9,"rownr":1},"I1"]
    [{"colnr":10,"rownr":1},"J1"]
    [{"colnr":26,"rownr":1},"Z1"]
    [{"colnr":27,"rownr":1},"AA1"]
    [{"colnr":28,"rownr":1},"AB1"]
    [{"colnr":29,"rownr":1},"AC1"]
    [{"colnr":51,"rownr":1},"AY1"]
    [{"colnr":52,"rownr":1},"AZ1"]
    [{"colnr":53,"rownr":1},"BA1"]
    [{"colnr":100,"rownr":1},"CV1"]
    [{"colnr":1000,"rownr":1},"ALL1"]
    [{"colnr":Number.MAX_SAFE_INTEGER,"rownr":53},"BKTXHSOGHKKE53"]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.CELLS.get_cellkey probe
    catch error
      T.fail error.message
      continue
    # urge '77811', ( rpr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.CELLS.get_cellkey 2" ] = ( T, done ) ->
  probes_and_matchers = [
    ["A1","A1"]
    ["B1","B1"]
    ["C1","C1"]
    ["D1","D1"]
    ["E1","E1"]
    ["F1","F1"]
    ["G1","G1"]
    ["H1","H1"]
    ["I1","I1"]
    ["J1","J1"]
    ["Z1","Z1"]
    ["AA1","AA1"]
    ["AB1","AB1"]
    ["AC1","AC1"]
    ["AY1","AY1"]
    ["AZ1","AZ1"]
    ["BA1","BA1"]
    ["CV1","CV1"]
    ["ALL1","ALL1"]
    ["+A1","A1"]
    ["+B1","B1"]
    ["+C1","C1"]
    ["+D1","D1"]
    ["+E1","E1"]
    ["+F1","F1"]
    ["+G1","G1"]
    ["+H1","H1"]
    ["+I1","I1"]
    ["+J1","J1"]
    ["+Z1","Z1"]
    ["+AA1","AA1"]
    ["+AB1","AB1"]
    ["+AC1","AC1"]
    ["+AY1","AY1"]
    ["+AZ1","AZ1"]
    ["+BA1","BA1"]
    ["+CV1","CV1"]
    ["+ALL1","ALL1"]
    ["+A+012","A12"]
    ["+B+012","B12"]
    ["+C+012","C12"]
    ["+D+012","D12"]
    ["+E+012","E12"]
    ["+F+012","F12"]
    ["+G+012","G12"]
    ["+H+012","H12"]
    ["+I+012","I12"]
    ["+J+012","J12"]
    ["+Z+012","Z12"]
    ["+AA+012","AA12"]
    ["+AB+012","AB12"]
    ["+AC+012","AC12"]
    ["+AY+012","AY12"]
    ["+AZ+012","AZ12"]
    ["+BA+012","BA12"]
    ["+CV+012","CV12"]
    ["+ALL+012","ALL12"]
    ["-ALL1","-ALL1"]
    ["-A+012","-A12"]
    ["-B+012","-B12"]
    ["-C+012","-C12"]
    ["-D+012","-D12"]
    ["-E+012","-E12"]
    ["-F+012","-F12"]
    ["-G+012","-G12"]
    ["-H+012","-H12"]
    ["-I+012","-I12"]
    ["-J+012","-J12"]
    ["-Z+012","-Z12"]
    ["-AA+012","-AA12"]
    ["-AB+012","-AB12"]
    ["-AC+012","-AC12"]
    ["-AY+012","-AY12"]
    ["-AZ+012","-AZ12"]
    ["-BA+012","-BA12"]
    ["-CV+012","-CV12"]
    ["-ALL+012","-ALL12"]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result_1 = INTERGRID.CELLS.get_cellkey INTERGRID.CELLS.parse_cellkey probe
    catch error
      T.fail error.message
      continue
    # urge '77811', ( rpr [ probe, result_1, ] )
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
    [{"colnr":10,"rowstar":"*"},"J*"]
    [{"colnr":26,"rowstar":"*"},"Z*"]
    [{"colnr":27,"rowstar":"*"},"AA*"]
    [{"colnr":53,"rowstar":"*"},"BA*"]
    [{"colnr":100,"rowstar":"*"},"CV*"]
    [{"colnr":1000,"rowstar":"*"},"ALL*"]
    [{"colnr":-10,"rowstar":"*"},"-J*"]
    [{"colnr":-26,"rowstar":"*"},"-Z*"]
    [{"colnr":-27,"rowstar":"*"},"-AA*"]
    [{"colnr":-53,"rowstar":"*"},"-BA*"]
    [{"colnr":-100,"rowstar":"*"},"-CV*"]
    [{"colnr":-1000,"rowstar":"*"},"-ALL*"]
    [{"colnr":10},"J*"]
    [{"colnr":26},"Z*"]
    [{"colnr":27},"AA*"]
    [{"colnr":53},"BA*"]
    [{"colnr":100},"CV*"]
    [{"colnr":1000},"ALL*"]
    [{"colnr":-10},"-J*"]
    [{"colnr":-26},"-Z*"]
    [{"colnr":-27},"-AA*"]
    [{"colnr":-53},"-BA*"]
    [{"colnr":-100},"-CV*"]
    [{"colnr":-1000},"-ALL*"]
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
      T.fail "probe #{rpr probe}: #{error.message}"
      continue
    # urge '77811', ( rpr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.new_grid_from_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    ["D4",{"~isa":"INTERGRID/GRID/grid","width":4,"height":4}]
    ["A1",{"~isa":"INTERGRID/GRID/grid","width":1,"height":1}]
    ["C-5",{"~isa":"INTERGRID/GRID/grid","width":3,"height":5}]
    ["-C-5",{"~isa":"INTERGRID/GRID/grid","width":3,"height":5}]
    ]
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    try
      result = INTERGRID.GRID.new_grid_from_cellkey probe
    catch error
      if ( matcher is null ) and ( error.message.match /expected a cellkey like 'A1', '\*', '\*4' or 'C-1, got '/ )?
        # urge '77812', ( rpr [ probe, null, ] )
        T.ok true
      else
        T.fail error.message
      continue
    urge '77812', ( rpr [ probe, result, ] )
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
#         # urge '77812', ( rpr [ probe, null, ] )
#         T.ok true
#       else
#         T.fail error.message
#       continue
#     urge '77812', ( rpr [ probe, result, ] )
#     # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
#     # T.eq result, matcher
#   #.........................................................................................................
#   done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.abs_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [["D4","A1"],"A1"]
    [["A1","A1"],"A1"]
    [["C-5","B11"],null]
    [["-C-5","B11"],null]
    [["C-12","B11"],"B11"]
    [["-C-12","B11"],"B11"]
    [["D4","-A1"],"D1"]
    [["D4","-A-1"],"D4"]
    [["D4","A-1"],"A4"]
    ]
  #.........................................................................................................
  for [ [ grid_probe, cellkey_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    try
      result = INTERGRID.GRID.abs_cellkey grid, cellkey_probe
    catch error
      if ( matcher is null ) and ( error.message.match /row nr [0-9]+ exceeds grid height [0-9]+/ )?
        # urge '77812', ( rpr [ probe, null, ] )
        urge '77812', ( rpr [ [ grid_probe, cellkey_probe, ], result, ] )
        T.ok true
      else
        T.fail error.message
      continue
    urge '77812', ( rpr [ [ grid_probe, cellkey_probe, ], result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.parse_rangekey 2" ] = ( T, done ) ->
  probes_and_matchers = [
    [["A1","B2..A1"],null]
    [["C-5","B1..C12"],null]
    [["-C-5","B1..C12"],null]
    [["D4","A1..B2"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":2,"top_rownr":1,"bottom_rownr":2}]
    [["C-12","A1..B11"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":2,"top_rownr":1,"bottom_rownr":11}]
    [["-C-12","A1..B11"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":2,"top_rownr":1,"bottom_rownr":11}]
    [["D4","-A1..C3"],{"~isa:":"INTERGRID/rangeref","left_colnr":3,"right_colnr":4,"top_rownr":1,"bottom_rownr":3}]
    [["D4","-A-1..C3"],{"~isa:":"INTERGRID/rangeref","left_colnr":3,"right_colnr":4,"top_rownr":3,"bottom_rownr":4}]
    [["D4","-A-1..A1"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":1,"bottom_rownr":4}]
    [["D4","*"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":1,"bottom_rownr":4}]
    [["D4","*..*"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":1,"bottom_rownr":4}]
    [["D4","*..**"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":1,"bottom_rownr":4}]
    [["D4","**..**"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":1,"bottom_rownr":4}]
    [["D4","**..*"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":1,"bottom_rownr":4}]
    [["D4","A*..B*"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":2,"top_rownr":1,"bottom_rownr":4}]
    [["D4","B2..C3"],{"~isa:":"INTERGRID/rangeref","left_colnr":2,"right_colnr":3,"top_rownr":2,"bottom_rownr":3}]
    [["D4","B2..C*"],{"~isa:":"INTERGRID/rangeref","left_colnr":2,"right_colnr":3,"top_rownr":1,"bottom_rownr":4}]
    [["D4","*2..C*"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":1,"bottom_rownr":4}]
    [["D5","*2..C3"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":2,"bottom_rownr":3}]
    [["D5","*2..*3"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":4,"top_rownr":2,"bottom_rownr":3}]
    [["E4","*2..C3"],{"~isa:":"INTERGRID/rangeref","left_colnr":1,"right_colnr":5,"top_rownr":2,"bottom_rownr":3}]
    ]
  #.........................................................................................................
  for [ [ grid_probe, rangekey_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    try
      result = INTERGRID.GRID.parse_rangekey grid, rangekey_probe
    catch error
      urge '50901-1', ( rpr [ [ grid_probe, rangekey_probe, ], result, ] )
      if ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
        # urge '50901-2', ( rpr [ probe, null, ] )
        T.ok true
      else
        # throw error
        T.fail "#{rpr [ grid_probe, rangekey_probe ]} failed with #{error.message}"
      continue
    urge '50901-3', ( rpr [ [ grid_probe, rangekey_probe, ], result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.parse_cellkey 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [["D4","D5"],null]
    [["D4","E4"],null]
    [["D4","B1"],{"~isa":"INTERGRID/cellref","colletters":"B","rowdigits":"1","colnr":2,"rownr":1,"cellkey":"B1"}]
    [["D4","-B1"],{"~isa":"INTERGRID/cellref","colletters":"C","rowdigits":"1","colnr":3,"rownr":1,"cellkey":"C1"}]
    [["D4","A1"],{"~isa":"INTERGRID/cellref","colletters":"A","rowdigits":"1","colnr":1,"rownr":1,"cellkey":"A1"}]
    [["D4","C3"],{"~isa":"INTERGRID/cellref","colletters":"C","rowdigits":"3","colnr":3,"rownr":3,"cellkey":"C3"}]
    [["D4","-A1"],{"~isa":"INTERGRID/cellref","colletters":"D","rowdigits":"1","colnr":4,"rownr":1,"cellkey":"D1"}]
    [["D4","-A-1"],{"~isa":"INTERGRID/cellref","colletters":"D","rowdigits":"4","colnr":4,"rownr":4,"cellkey":"D4"}]
    ]
  #.........................................................................................................
  for [ [ grid_probe, rangekey_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    try
      result = INTERGRID.GRID.parse_cellkey grid, rangekey_probe
    catch error
      urge '76544-1', ( rpr [ [ grid_probe, rangekey_probe, ], result, ] )
      if ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
        # urge '76544-2', ( rpr [ probe, null, ] )
        T.ok true
      else
        # throw error
        T.fail "#{rpr [ grid_probe, rangekey_probe ]} failed with #{error.message}"
      continue
    urge '76544-3', ( rpr [ [ grid_probe, rangekey_probe, ], result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.walk_cells_from_key" ] = ( T, done ) ->
  probes_and_matchers = [
    [["D5","D7"],null]
    [["D5","E4"],null]
    [["D5","B1"],["B1"]]
    [["D5","-B1"],["C1"]]
    [["D5","A1"],["A1"]]
    [["D5","C3"],["C3"]]
    [["D5","-A1"],["D1"]]
    [["D5","-A-1"],["D5"]]
    [["C3","C*"],["C1","C2","C3"]]
    [["C3","*"],["A1","B1","C1","A2","B2","C2","A3","B3","C3"]]
    [["C3","*3"],["A3","B3","C3"]]
    [["C3","*-1"],["A3","B3","C3"]]
    ]
  #.........................................................................................................
  for [ [ grid_probe, key_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    try
      result = [ ( INTERGRID.GRID.walk_cells_from_key grid, key_probe )... ]
    catch error
      urge '76544-1', ( rpr [ [ grid_probe, key_probe, ], result, ] )
      if ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
        # urge '76544-2', ( rpr [ probe, null, ] )
        T.ok true
      else
        # throw error
        T.fail "#{rpr [ grid_probe, key_probe ]} failed with #{error.message}"
      continue
    hits    = ( x.cellkey for x in result when x[ '~isa' ] is 'INTERGRID/cellref' )
    fails   = ( x.cellkey for x in result when x[ '~isa' ] isnt 'INTERGRID/cellref' )
    urge '76544-3', ( rpr [ [ grid_probe, key_probe, ], hits, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq fails.length, 0
    T.eq hits, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.walk_cells_from_selector" ] = ( T, done ) ->
  probes_and_matchers = [
    [["D5","D7"],null]
    [["D5","E4"],null]
    [["D5","B1"],["B1"]]
    [["D5","-B1"],["C1"]]
    [["D5","A1"],["A1"]]
    [["D5","C3"],["C3"]]
    [["D5","-A1"],["D1"]]
    [["D5","-A-1"],["D5"]]
    [["C3","C*"],["C1","C2","C3"]]
    [["C3","*"],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["C3","*3"],["A3","B3","C3"]]
    [["C3","*-1"],["A3","B3","C3"]]
    [["D5","D7,A1"],null]
    [["D5","E4..E5"],null]
    [["D5","B1,B2,C3"],["B1","B2","C3"]]
    [["D5","-B1..A1,D5"],["A1","B1","C1","D5"]]
    [["D5","A1..A1"],["A1"]]
    [["D5","A1,A1"],["A1"]]
    [["D5","C3..A1"],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["D5","-A1..-A2"],["D1","D2"]]
    [["D5","-A-1..-A-5"],["D1","D2","D3","D4","D5"]]
    [["C3","B*..C*"],["B1","B2","B3","C1","C2","C3"]]
    [["C3","*"],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["C3","**"],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["C3","*3,C*"],["A3","B3","C1","C2","C3"]]
    [["C3","*-1,*1"],["A1","A3","B1","B3","C1","C3"]]
    [["D5",["D7"]],null]
    [["D5",["E4"]],null]
    [["D5",["D7","A1"]],null]
    [["D5",["E4..E5"]],null]
    [["D5",["B1"]],["B1"]]
    [["D5",["-B1"]],["C1"]]
    [["D5",["A1"]],["A1"]]
    [["D5",["C3"]],["C3"]]
    [["D5",["-A1"]],["D1"]]
    [["D5",["-A-1"]],["D5"]]
    [["C3",["C*"]],["C1","C2","C3"]]
    [["C3",["*"]],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["C3",["*3"]],["A3","B3","C3"]]
    [["C3",["*-1"]],["A3","B3","C3"]]
    [["D5",["B1","B2","C3"]],["B1","B2","C3"]]
    [["D5",["-B1..A1","D5"]],["A1","B1","C1","D5"]]
    [["D5",["A1..A1"]],["A1"]]
    [["D5",["A1","A1"]],["A1"]]
    [["D5",["C3..A1"]],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["D5",["-A1..-A2"]],["D1","D2"]]
    [["D5",["-A-1..-A-5"]],["D1","D2","D3","D4","D5"]]
    [["C3",["B*..C*"]],["B1","B2","B3","C1","C2","C3"]]
    [["C3",["*"]],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["C3",["**"]],["A1","A2","A3","B1","B2","B3","C1","C2","C3"]]
    [["C3",["*3","C*"]],["A3","B3","C1","C2","C3"]]
    [["C3",["*-1","*1"]],["A1","A3","B1","B3","C1","C3"]]
    ]
  #.........................................................................................................
  for [ [ grid_probe, key_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    result  = null
    matcher = matcher.sort() if types.isa.list matcher
    try
      result = [ ( INTERGRID.GRID.walk_cells_from_selector grid, key_probe )... ]
    catch error
      # debug '44455', rpr [ [ grid_probe, key_probe ], matcher, ]
      # debug '44455', error.message
      # debug '44455', ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
      # continue
      urge '76544-1', ( rpr [ [ grid_probe, key_probe, ], result, ] )
      if ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
        # urge '76544-2', ( rpr [ probe, null, ] )
        T.ok true
      else
        # throw error
        T.fail "#{rpr [ grid_probe, key_probe ]} failed with #{error.message}"
      continue
    hits    = ( x.cellkey for x in result when x[ '~isa' ] is 'INTERGRID/cellref' ).sort()
    misses  = ( x.cellkey for x in result when x[ '~isa' ] isnt 'INTERGRID/cellref' )
    urge '76544-3', ( rpr [ [ grid_probe, key_probe, ], hits, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
    T.eq misses.length, 0
    T.eq hits, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERGRID.GRID.rangekey_from_rangeref" ] = ( T, done ) ->
  probes_and_matchers = [
    [["D5","A1..A1"],"A1..A1"]
    [["D5","A1..-A-1"],"A1..D5"]
    [["D5","C3..A1"],"A1..C3"]
    [["D5","-A1..-A2"],"D1..D2"]
    [["D5","-A-1..-A-5"],"D1..D5"]
    ]
  #.........................................................................................................
  for [ [ grid_probe, key_probe ], matcher, ] in probes_and_matchers
    grid    = INTERGRID.GRID.new_grid_from_cellkey grid_probe
    try
      rangeref  = INTERGRID.GRID.parse_rangekey grid, key_probe
      result    = INTERGRID.GRID.rangekey_from_rangeref grid, rangeref
    catch error
      # debug '44455', rpr [ [ grid_probe, key_probe ], matcher, ]
      # debug '44455', error.message
      # debug '44455', ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
      # continue
      urge '76544-1', ( rpr [ [ grid_probe, key_probe, ], result, ] )
      if false # ( matcher is null ) and ( error.message.match /(column|row) nr [0-9]+ exceeds grid (width|height) [0-9]+/ )?
        # urge '76544-2', ( rpr [ probe, null, ] )
        T.ok true
      else
        # throw error
        T.fail "#{rpr [ grid_probe, key_probe ]} failed with #{error.message}"
      continue
    urge '76544-3', ( rpr [ [ grid_probe, key_probe, ], result, ] )
    # echo "| `#{rpr probe}` | `#{ ( rpr result ).replace /\n/g, ' ' }` |"
  #.........................................................................................................
  done()


############################################################################################################
unless module.parent?
  include = [
    "INTERGRID.LETTERS.get_letters 1"
    "INTERGRID.LETTERS.get_letters 2"
    "INTERGRID.LETTERS.get_number 1"
    "INTERGRID.LETTERS.get_number 2"
    "INTERGRID.CELLS.parse_cellkey"
    "INTERGRID.CELLS.get_cellkey 1"
    "INTERGRID.CELLS.get_cellkey 2"
    "INTERGRID.CELLS.get_cellkey 3"
    "INTERGRID.GRID.new_grid_from_cellkey 1"
    "INTERGRID.GRID.abs_cellref 1"
    "INTERGRID.GRID.abs_cellkey 1"
    "INTERGRID.GRID.parse_cellkey 1"
    "INTERGRID.GRID.parse_rangekey 2"
    "INTERGRID.GRID.walk_cells_from_key"
    "INTERGRID.CELLS cellref pattern"
    "INTERGRID.GRID.walk_cells_from_selector"
    "INTERGRID.GRID.rangekey_from_rangeref"
    ]
  @_prune()
  @_main()








