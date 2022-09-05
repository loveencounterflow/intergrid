(function() {
  'use strict';
  var CELLS, GUY, LETTERS, contains, rpr, types;

  //###########################################################################################################
  GUY = require('guy');

  // { debug
  //   info
  //   warn
  //   urge
  //   help }                  = GUY.trm.get_loggers 'INTERGRID/GRID'
  ({rpr} = GUY.trm);

  //...........................................................................................................
  LETTERS = require('./a1letters');

  CELLS = require('./a1cells');

  types = require('./types');

  //-----------------------------------------------------------------------------------------------------------
  contains = function(text, pattern) {
    /* TAINT move to helper library, CND, ... */
    switch (types.type_of(pattern)) {
      case 'regex':
        return (text.match(pattern)) != null;
      default:
        throw new Error(`pattern not supported: ${rpr(pattern)}`);
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.settings = {
    rangemark: '..'
  };

  //-----------------------------------------------------------------------------------------------------------
  this.new_grid_from_cellkey = function(cellkey) {
    var cellref, height, width;
    cellref = CELLS.abs_cellref(CELLS.parse_cellkey(cellkey));
    width = cellref.colnr;
    height = cellref.rownr;
    return {
      '~isa': 'INTERGRID/grid',
      width,
      height
    };
  };

  // #-----------------------------------------------------------------------------------------------------------
  // @is_left_of_cellkey = ( grid, cellkey_1, cellkey_2 ) ->
  //   cellref_1 = @abs_cellref grid, CELLS.parse_cellkey cellkey_1
  //   cellref_2 = @abs_cellref grid, CELLS.parse_cellkey cellkey_2
  //   width   = cellref.colnr
  //   height  = cellref.rownr
  //   return { '~isa': 'INTERGRID/GRID/grid', width, height, }

  //-----------------------------------------------------------------------------------------------------------
  this.abs_cellref = function(grid, cellref) {
    var R;
    R = CELLS.normalize_cellref(cellref);
    //.........................................................................................................
    if (R.colsign != null) {
      R.colnr = grid.width + 1 + R.colnr;
      R.colletters = LETTERS.get_letters(R.colnr);
      delete R.colsign;
    }
    //.........................................................................................................
    if (R.rowsign != null) {
      R.rownr = grid.height + 1 + R.rownr;
      R.rowdigits = `${R.rownr}`;
      delete R.rowsign;
    }
    //.........................................................................................................
    if ((R.colnr <= 0) || (R.colnr > grid.width)) {
      throw new Error(`µ9949 column nr ${rpr(cellref.colnr)} exceeds grid width ${rpr(grid.width)}`);
    }
    if ((R.rownr <= 0) || (R.rownr > grid.height)) {
      throw new Error(`µ9949 row nr ${rpr(cellref.rownr)} exceeds grid height ${rpr(grid.height)}`);
    }
    //.........................................................................................................
    R.cellkey = CELLS.get_cellkey(R);
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.parse_cellkey = function(grid, cellkey) {
    return this.abs_cellref(grid, CELLS.parse_cellkey(cellkey));
  };

  this.abs_cellkey = function(grid, cellkey) {
    return CELLS.get_cellkey(this.parse_cellkey(grid, cellkey));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_left_of_cellref = function(grid, cellref_1, cellref_2) {
    cellref_1 = this.abs_cellref(grid, cellref_1);
    cellref_2 = this.abs_cellref(grid, cellref_2);
    return cellref_1.colnr < cellref_2.colnr;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_right_of_cellref = function(grid, cellref_1, cellref_2) {
    cellref_1 = this.abs_cellref(grid, cellref_1);
    cellref_2 = this.abs_cellref(grid, cellref_2);
    return cellref_1.colnr > cellref_2.colnr;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_above_cellref = function(grid, cellref_1, cellref_2) {
    cellref_1 = this.abs_cellref(grid, cellref_1);
    cellref_2 = this.abs_cellref(grid, cellref_2);
    return cellref_1.rownr < cellref_2.rownr;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_below_cellref = function(grid, cellref_1, cellref_2) {
    cellref_1 = this.abs_cellref(grid, cellref_1);
    cellref_2 = this.abs_cellref(grid, cellref_2);
    return cellref_1.rownr > cellref_2.rownr;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_left_of_cellkey = function(grid, cellkey_1, cellkey_2) {
    /* TAINT will perform @abs_cellref twice */
    return this.is_left_of_cellkey(grid, this.parse_cellkey(grid, cellkey_1), this.parse_cellkey(grid, cellkey_2));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_right_of_cellkey = function(grid, cellkey_1, cellkey_2) {
    /* TAINT will perform @abs_cellref twice */
    return this.is_right_of_cellkey(grid, this.parse_cellkey(grid, cellkey_1), this.parse_cellkey(grid, cellkey_2));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_above_cellkey = function(grid, cellkey_1, cellkey_2) {
    /* TAINT will perform @abs_cellref twice */
    return this.is_above_cellkey(grid, this.parse_cellkey(grid, cellkey_1), this.parse_cellkey(grid, cellkey_2));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.is_below_cellkey = function(grid, cellkey_1, cellkey_2) {
    /* TAINT will perform @abs_cellref twice */
    return this.is_below_cellkey(grid, this.parse_cellkey(grid, cellkey_1), this.parse_cellkey(grid, cellkey_2));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.parse_rangekey = function(grid, rangekey) {
    var bottom_rownr, cellkey_1, cellkey_2, cellkeys, cellref_1, cellref_2, left_colnr, right_colnr, top_rownr;
    if ((rangekey.match(/^(?:[*]|[*]{1,2}\.\.[*]{1,2})$/)) != null) {
      left_colnr = 1;
      right_colnr = grid.width;
      top_rownr = 1;
      bottom_rownr = grid.height;
    } else {
      //.........................................................................................................
      cellkeys = rangekey.split(this.settings.rangemark);
      //.......................................................................................................
      if (cellkeys.length !== 2) {
        throw new Error(`µ9949 expected rangekey, got ${rpr(rangekey)}`);
      }
      //.......................................................................................................
      [cellkey_1, cellkey_2] = cellkeys;
      cellref_1 = this.abs_cellref(grid, CELLS.parse_cellkey(cellkey_1));
      cellref_2 = this.abs_cellref(grid, CELLS.parse_cellkey(cellkey_2));
      //.......................................................................................................
      if ((cellref_1.colstar != null) || (cellref_2.colstar != null)) {
        [left_colnr, right_colnr] = [1, grid.width];
      } else {
        [left_colnr, right_colnr] = [cellref_1.colnr, cellref_2.colnr];
      }
      //.......................................................................................................
      if ((cellref_1.rowstar != null) || (cellref_2.rowstar != null)) {
        [top_rownr, bottom_rownr] = [1, grid.height];
      } else {
        [top_rownr, bottom_rownr] = [cellref_1.rownr, cellref_2.rownr];
      }
      if (right_colnr < left_colnr) {
        //.......................................................................................................
        [left_colnr, right_colnr] = [right_colnr, left_colnr];
      }
      if (bottom_rownr < top_rownr) {
        [top_rownr, bottom_rownr] = [bottom_rownr, top_rownr];
      }
    }
    return {
      //.........................................................................................................
      '~isa:': 'INTERGRID/rangeref',
      left_colnr,
      right_colnr,
      top_rownr,
      bottom_rownr
    };
  };

  //===========================================================================================================
  // ITERATORS
  //-----------------------------------------------------------------------------------------------------------
  this.walk_cells_from_selector = function*(grid, selector) {
    var cell, i, key, len, ref, seen_cellkeys;
    if (types.isa.text(selector)) {
      yield* this.walk_cells_from_selector(grid, selector.split(/\s*,\s*/g));
      return;
    }
    seen_cellkeys = new Set();
    for (i = 0, len = selector.length; i < len; i++) {
      key = selector[i];
      ref = this.walk_cells_from_key(grid, key);
      for (cell of ref) {
        if (seen_cellkeys.has(cell.cellkey)) {
          continue;
        }
        seen_cellkeys.add(cell.cellkey);
        yield cell;
      }
    }
  };

  //-----------------------------------------------------------------------------------------------------------
  this.walk_cells_from_key = function*(grid, key) {
    if (!contains(key, /\.\./)) {
      key = key + '..' + key;
    }
    yield* this.walk_cells_from_rangekey(grid, key);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.walk_cells_from_rangekey = function*(grid, rangekey) {
    yield* this.walk_cells_from_rangeref(grid, this.parse_rangekey(grid, rangekey));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.walk_cells_from_rangeref = function*(grid, rangeref) {
    var colnr, i, j, ref, ref1, ref2, ref3, rownr;
/* TAINT should complain on rangeref out of grid bounds */
    for (rownr = i = ref = rangeref.top_rownr, ref1 = rangeref.bottom_rownr; i <= ref1; rownr = i += +1) {
      for (colnr = j = ref2 = rangeref.left_colnr, ref3 = rangeref.right_colnr; j <= ref3; colnr = j += +1) {
        // cellkey = CELLS.get_cellkey { colnr, rownr, }
        yield CELLS.normalize_cellref({colnr, rownr});
      }
    }
  };

  //-----------------------------------------------------------------------------------------------------------
  this.rangekey_from_rangeref = function(grid, rangeref) {
    /* TAINT should complain on rangeref out of grid bounds */
    var bottomright, topleft;
    topleft = CELLS.get_cellkey({
      colnr: rangeref.left_colnr,
      rownr: rangeref.top_rownr
    });
    bottomright = CELLS.get_cellkey({
      colnr: rangeref.right_colnr,
      rownr: rangeref.bottom_rownr
    });
    return `${topleft}..${bottomright}`;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.walk_colletters_and_colnrs = function*(grid) {
    var colnr, i, ref;
    for (colnr = i = 1, ref = grid.width; (1 <= ref ? i <= ref : i >= ref); colnr = 1 <= ref ? ++i : --i) {
      yield [LETTERS.get_letters(colnr), colnr];
    }
  };

  //-----------------------------------------------------------------------------------------------------------
  this.walk_rownrs = function*(grid) {
    var i, ref, rownr;
    for (rownr = i = 1, ref = grid.height; (1 <= ref ? i <= ref : i >= ref); rownr = 1 <= ref ? ++i : --i) {
      yield rownr;
    }
  };

  //-----------------------------------------------------------------------------------------------------------
  this.walk_edge_cellrefs = function*(grid, edge) {
    var colnr, colnr_1, colnr_2, i, j, ref, ref1, ref2, ref3, rownr, rownr_1, rownr_2;
    switch (edge) {
      case 'left':
        colnr_1 = 1;
        colnr_2 = 1;
        rownr_1 = 1;
        rownr_2 = grid.height;
        break;
      case 'right':
        colnr_1 = grid.width;
        colnr_2 = grid.width;
        rownr_1 = 1;
        rownr_2 = grid.height;
        break;
      case 'top':
        colnr_1 = 1;
        colnr_2 = grid.width;
        rownr_1 = 1;
        rownr_2 = 1;
        break;
      case 'bottom':
        colnr_1 = 1;
        colnr_2 = grid.width;
        rownr_1 = grid.height;
        rownr_2 = grid.height;
        break;
      case '*':
        yield* this.walk_edge_cellrefs(grid, 'left');
        yield* this.walk_edge_cellrefs(grid, 'right');
        yield* this.walk_edge_cellrefs(grid, 'top');
        yield* this.walk_edge_cellrefs(grid, 'bottom');
        return;
      default:
        throw new Error(`µ9949 illegal argument for edge ${rpr(edge)}`);
    }
    for (rownr = i = ref = rownr_1, ref1 = rownr_2; (ref <= ref1 ? i <= ref1 : i >= ref1); rownr = ref <= ref1 ? ++i : --i) {
      for (colnr = j = ref2 = colnr_1, ref3 = colnr_2; (ref2 <= ref3 ? j <= ref3 : j >= ref3); colnr = ref2 <= ref3 ? ++j : --j) {
        yield CELLS.normalize_cellref({colnr, rownr});
      }
    }
  };

}).call(this);

//# sourceMappingURL=grid.js.map