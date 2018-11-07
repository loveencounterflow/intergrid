

### When drawing borders with edge decorations (such as rounded or cut corners)
    we need to know which borders form a continuous line.

    We approach the problem by noting that the appearance of borders—that is,
    whether the appear and how they appear—is governed by style settings in the
    form of a single string: if no string is given, no border will be drawn, and
    if a string is given for an edge, that edge will be drawn using the style as
    specified.

    For simplicity, we assume that two style settings describe the same line
    style if and only if the two strings are identical, that is, `'thin,red'`
    and `'red,thin'` are understood as two different line styles although they
    will probably look identical.

    We also assume that transitions from one border style to another are not
    supported, and that no rounded or cut corners is possible between lines of
    different styles. This means that when we look at the four edges of a given
    field—left, top, right, bottom—and try to find continuous lines, we can
    treat borders with different styles like borders from two unrelated fields.
    In the below, we can ignore styles and speak of edges that do or don't have
    borders (of the same style).

    Next, we observe that some arrangements of borders are trivial, namely:

    * **0** A field with no borders is the most obvious case.

    * **1** When a field has one border, the solution is also obvious.

    * **4** When a field has four borders, then we can simply draw a rectangle
      from the top-left and bottom-right corners.

    * **3** When a field has three borders, it will have exactly one gap and we
      can start drawing a line at an edge adjacent to the gap; always proceding
      in clockwise fashion, that will be the border situated to the 'right' of
      the gap (as seen from the center of the field).

    Only one case remains:

    * **2** When a field has two borders, there are two possible patterns:

      * Either we can find one edge with a border that is not adjacent to
        another border; in that case, we can draw two separate lines as in
        **1**, above.

      * Else, either the edge to the 'left' or the one to the 'right' (looking
        from inside the field) of a border will have a border, too; if we agree
        to always give edges in clockwise order, it suffices to give the
        'leftmost' border position.

###


'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'MKTS/TABLE'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND


#-----------------------------------------------------------------------------------------------------------
idx_by_edges =
  top:    0
  right:  1
  bottom: 2
  left:   3

#-----------------------------------------------------------------------------------------------------------
edge_by_idxs =
  0:      'top'
  1:      'right'
  2:      'bottom'
  3:      'left'

#-----------------------------------------------------------------------------------------------------------
@walk_segments = ( fieldnr, borders ) ->
  edgevector_by_styles = {}
  for edge, style of borders
    continue unless style?
    target = edgevector_by_styles[ style ] ?= [ 0, 0, 0, 0, ]
    target[ idx_by_edges[ edge ] ] = 1
  if ( Object.keys edgevector_by_styles ).length is 0
    yield return
  for style, edgevector of edgevector_by_styles
    #.......................................................................................................
    switch count = edgevector.reduce ( ( n, r ) -> n + r ), 0
      #.....................................................................................................
      when 0
        null
      #.....................................................................................................
      when 1
        mode  = 'single'
        edges = [ edge_by_idxs[ edgevector.indexOf 1 ], ]
        yield { fieldnr, style, mode, edges, }
      #.....................................................................................................
      when 3
        mode    = 'connect'
        gap_idx = edgevector.indexOf 0
        edges   = ( edge_by_idxs[ ( gap_idx + delta ) %% 4 ] for delta in [ 1 .. 3 ] )
        yield { fieldnr, style, mode, edges, }
      #.....................................................................................................
      when 4
        mode    = 'rectangle'
        yield { fieldnr, style, mode, }
      #.....................................................................................................
      when 2
        connected_at = null
        for idx in [ 1, 3, ]
          continue if edgevector[ idx ] is 0
          other_idx = ( idx - 1 ) %% 4
          if edgevector[ other_idx ] is 1
            connected_at = other_idx
            break
          other_idx = ( idx + 1 ) %% 4
          if edgevector[ other_idx ] is 1
            connected_at = idx
            break
        if connected_at?
          mode        = 'connect'
          border_idx  = edgevector.indexOf 1
          border_idx  = edgevector.indexOf 1, 1 if border_idx is 0
          edges       = [ edge_by_idxs[ border_idx ], edge_by_idxs[ ( border_idx + 1 ) %% 4 ], ]
          yield { fieldnr, style, mode, edges, }
        else
          mode        = 'single'
          first_idx   = 0
          for _ in [ 1, 2, ]
            border_idx  = edgevector.indexOf 1, first_idx
            first_idx   = border_idx + 1
            edges       = [ edge_by_idxs[ border_idx ], ]
            yield { fieldnr, style, mode, edges, }
  yield return






