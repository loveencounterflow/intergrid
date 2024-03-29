(function() {
  'use strict';
  var A1LETTERS;

  //###########################################################################################################
  A1LETTERS = require('./a1letters');

  //-----------------------------------------------------------------------------------------------------------
  this.settings = {
    patterns: {
      a1_lowercase: /^(?:(?<star>[*])|(?:(?<colstar>[*])|(?<colsign>\+|-|)(?<colletters>[a-z]+))(?:(?<rowstar>[*])|(?<rowsign>\+|-|)(?<rowdigits>[0-9]+)))$/,
      a1_uppercase: /^(?:(?<star>[*])|(?:(?<colstar>[*])|(?<colsign>\+|-|)(?<colletters>[A-Z]+))(?:(?<rowstar>[*])|(?<rowsign>\+|-|)(?<rowdigits>[0-9]+)))$/
    }
  };

  //-----------------------------------------------------------------------------------------------------------
  this.parse_cellkey = function(cellkey) {
    var R, key, match, ref;
    match = cellkey.match(this.settings.patterns.a1_uppercase);
    //.........................................................................................................
    if (match == null) {
      throw new Error(`µ9297 expected a cellkey, got ${rpr(cellkey)}`);
    }
    //.........................................................................................................
    R = {
      '~isa': 'INTERGRID/cellref',
      ...match.groups
    };
    for (key in R) {
      ((ref = R[key]) === '' || ref === '+' || ref === (void 0) ? delete R[key] : void 0);
    }
    //.........................................................................................................
    if ((R.colstar != null) && (R.rowstar != null)) {
      R.star = '*';
    //.........................................................................................................
    } else if (R.star != null) {
      R.colstar = '*';
      R.rowstar = '*';
    }
    //.........................................................................................................
    if (R.rowdigits != null) {
      R.rowdigits = R.rowdigits.replace(/^0*/, '');
    }
    //.........................................................................................................
    if (R.colletters != null) {
      R.colnr = A1LETTERS.get_number(R.colletters, A1LETTERS.settings.alphabets.uppercase);
      if (R.colsign != null) {
        R.colnr *= -1;
      }
    }
    //.........................................................................................................
    if (R.rowdigits != null) {
      R.rownr = parseInt(R.rowdigits, 10);
      if (R.rowsign != null) {
        R.rownr *= -1;
      }
    }
    //.........................................................................................................
    R.cellkey = this.get_cellkey(R);
    //.........................................................................................................
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.get_cellkey = function(cellref) {
    var colletters, colnr, colsign, colstar, rownr, rowstar, star;
    ({colnr, rownr, colstar, rowstar, star} = cellref);
    colletters = null;
    colsign = '';
    //.........................................................................................................
    if (star != null) {
      if (star !== '*') {
        throw new Error(`µ5434 expected '*' for star, got ${rpr(star)}`);
      }
      if ((colnr != null) || (rownr != null)) {
        throw new Error(`µ8206 illegal to set colnr or rownr with star, got ${rpr(cellref)}`);
      }
      return '*';
    }
    //.........................................................................................................
    if (colstar != null) {
      if (colstar !== '*') {
        throw new Error(`µ6338 expected '*' for colstar, got ${rpr(colstar)}`);
      }
      if (colnr != null) {
        throw new Error(`µ4974 illegal to set colnr with colstar, got ${rpr(cellref)}`);
      }
      colletters = '*';
    //.........................................................................................................
    } else if (rowstar != null) {
      if (rowstar !== '*') {
        throw new Error(`µ2116 expected '*' for rowstar, got ${rpr(rowstar)}`);
      }
      if (rownr != null) {
        throw new Error(`µ1071 illegal to set rownr with rowstar, got ${rpr(cellref)}`);
      }
      rownr = '*';
    } else {
      //.........................................................................................................
      if (colnr != null) {
        if (!(colnr = Math.floor(colnr))) {
          throw new Error(`µ1849 expected integer for colnr, got ${rpr(colnr)}`);
        }
      } else {
        colletters = '*';
      }
      //.......................................................................................................
      if (rownr != null) {
        if (!(rownr = Math.floor(rownr))) {
          throw new Error(`µ9949 expected integer for rownr, got ${rpr(rownr)}`);
        }
      } else {
        rownr = '*';
      }
    }
    //.........................................................................................................
    if (colletters == null) {
      if (colnr != null) {
        colsign = colnr < 0 ? '-' : '';
        colletters = A1LETTERS.get_letters(Math.abs(colnr), A1LETTERS.settings.alphabets.uppercase);
      } else {
        colletters = '*';
      }
    }
    if (rownr == null) {
      //.........................................................................................................
      rownr = '*';
    }
    if (colletters === '*' && rownr === '*') {
      return '*';
    }
    return `${colsign}${colletters}${rownr}`;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.normalize_cellkey = function(cellkey) {
    return this.get_cellkey(this.parse_cellkey(cellkey));
  };

  this.normalize_cellref = function(cellref) {
    return this.parse_cellkey(this.get_cellkey(cellref));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.abs_cellref = function(cellref) {
    var R;
    R = {...cellref};
    delete R.colsign;
    delete R.rowsign;
    if (R.colnr != null) {
      R.colnr = Math.abs(R.colnr);
    }
    if (R.rownr != null) {
      R.rownr = Math.abs(R.rownr);
    }
    R.cellkey = this.get_cellkey(R);
    return R;
  };

}).call(this);

//# sourceMappingURL=a1cells.js.map