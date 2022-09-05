
'use strict'


############################################################################################################
GUY                       = require 'guy'
{ debug
  info
  warn
  urge
  help }                  = GUY.trm.get_loggers 'INTERGRID/TESTS/borders'
{ rpr }                   = GUY.trm
#...........................................................................................................
test                      = require 'guy-test'
_INTERIM_BORDERS          = require '../experiments/border-segment-finder'
types                     = require '../types'


#-----------------------------------------------------------------------------------------------------------
@[ "INTERIM_BORDERS.walk_segments 1" ] = ( T, done ) ->
  probes_and_matchers = [
    [{"top":"thick","right":"thick","bottom":"thick","left":"thick"},"mode",["rectangle"]]
    [{"top":"thin,red","right":"thick","bottom":"thick","left":"thick"},"mode",["single","connect"]]
    [{"top":"thin","right":null,"bottom":null,"left":"thin"},"mode",["connect"]]
    [{"top":"thin","right":"thin","bottom":null,"left":"thin"},"mode",["connect"]]
    [{"top":"thin","right":"thin","bottom":null,"left":null},"mode",["connect"]]
    [{"top":null,"right":"thin","bottom":"thin","left":null},"mode",["connect"]]
    [{"top":null,"right":null,"bottom":null,"left":null},"mode",[]]
    [{"top":"thin","right":"thick","bottom":"thin","left":"thick"},"mode",["single","single","single","single"]]
    [{"top":null,"right":null,"bottom":"thin","left":"thin"},"mode",["connect"]]
    [{"top":"thick","right":"thick","bottom":"thick","left":"thick"},"edges",[]]
    [{"top":"thin,red","right":"thick","bottom":"thick","left":"thick"},"edges",[["top"],["right","bottom","left"]]]
    [{"top":"thin","right":null,"bottom":null,"left":"thin"},"edges",[["left","top"]]]
    [{"top":"thin","right":"thin","bottom":null,"left":"thin"},"edges",[["left","top","right"]]]
    [{"top":"thin","right":"thin","bottom":null,"left":null},"edges",[["top","right"]]]
    [{"top":null,"right":"thin","bottom":"thin","left":null},"edges",[["right","bottom"]]]
    [{"top":null,"right":null,"bottom":null,"left":null},"edges",[]]
    [{"top":"thin","right":"thick","bottom":"thin","left":"thick"},"edges",[["top"],["bottom"],["right"],["left"]]]
    [{"top":null,"right":null,"bottom":"thin","left":"thin"},"edges",[["bottom","left"]]]
    [{"top":"thick","right":"thick","bottom":"thick","left":"thick"},"style",["thick"]]
    [{"top":"thin,red","right":"thick","bottom":"thick","left":"thick"},"style",["thin,red","thick"]]
    [{"top":"thin","right":null,"bottom":null,"left":"thin"},"style",["thin"]]
    [{"top":"thin","right":"thin","bottom":null,"left":"thin"},"style",["thin"]]
    [{"top":"thin","right":"thin","bottom":null,"left":null},"style",["thin"]]
    [{"top":null,"right":"thin","bottom":"thin","left":null},"style",["thin"]]
    [{"top":null,"right":null,"bottom":null,"left":null},"style",[]]
    [{"top":"thin","right":"thick","bottom":"thin","left":"thick"},"style",["thin","thin","thick","thick"]]
    [{"top":null,"right":null,"bottom":"thin","left":"thin"},"style",["thin"]]
    ]
  #.........................................................................................................
  for [ probe, selector, matcher, ], fieldidx in probes_and_matchers
    result = [ ( _INTERIM_BORDERS.walk_segments fieldidx + 1, probe )... ]
    result = ( x[ selector ] for x in result )
    result = [] if types.equals result, [ undefined, ]
    urge '36633', ( rpr [ probe, selector, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERIM_BORDERS.walk_segments 2" ] = ( T, done ) ->
  probes_and_matchers = [
    [{"top":"thick","right":"thick","bottom":"thick","left":"blue,thin"},[{"fieldnr":1,"style":"thick","mode":"connect","edges":["top","right","bottom"]},{"fieldnr":1,"style":"blue,thin","mode":"single","edges":["left"]}]]
    ]
  #.........................................................................................................
  for [ probe, matcher, ], fieldidx in probes_and_matchers
    result = [ ( _INTERIM_BORDERS.walk_segments fieldidx + 1, probe )... ]
    # result = [] if types.equals result, [ undefined, ]
    urge '36633', ( rpr [ probe, result, ] )
    T.eq result, matcher
  #.........................................................................................................
  done()

#-----------------------------------------------------------------------------------------------------------
@[ "INTERIM_BORDERS.walk_segments 3" ] = ( T, done ) ->
  probes_and_matchers = [
    [{"top":"thick","right":"thick"},[{"fieldnr":1,"style":"thick","mode":"connect","edges":["top","right"]}]]
    [{"bottom":"thick","right":"thick"},[{"fieldnr":2,"style":"thick","mode":"connect","edges":["right","bottom"]}]]
    [{"bottom":"thick","left":"thick"},[{"fieldnr":3,"style":"thick","mode":"connect","edges":["bottom","left"]}]]
    [{"top":"thick","left":"thick"},[{"fieldnr":4,"style":"thick","mode":"connect","edges":["left","top"]}]]
    ]
  #.........................................................................................................
  for [ probe, matcher, ], fieldidx in probes_and_matchers
    # whisper '----------------------------------'
    result = [ ( _INTERIM_BORDERS.walk_segments fieldidx + 1, probe )... ]
    # result = [] if types.equals result, [ undefined, ]
    urge '36633', ( rpr [ probe, result, ] )
    # debug '29222', 'probe:  ', ( Object.keys probe ).sort()
    # debug '29222', 'result: ', ( result[ 0 ].edges ).sort()
    T.eq result, matcher
  #.........................................................................................................
  done()



############################################################################################################
unless module.parent?
  test @




