(function() {
  'use strict';
  var GUY, rpr,
    modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

  //###########################################################################################################
  GUY = require('guy');

  ({rpr} = GUY.trm);

  //-----------------------------------------------------------------------------------------------------------
  this.settings = {
    alphabets: {
      lowercase: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'],
      uppercase: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    }
  };

  /*
  thx to https://stackoverflow.com/a/23862223/7568091

  ```
  def n2a(n,b=string.ascii_uppercase):
    d, m = divmod(n,len(b))
    return n2a(d-1,b)+b[m] if d else b[m]
  ```

  thx to https://stackoverflow.com/a/16406308/7568091

  ```
  def col_to_num(col_str):
    """ Convert base26 column string to number. """
    expn = 0
    col_num = 0
    for char in reversed(col_str):
      col_num += (ord(char) - ord('A') + 1) * (26 ** expn)
      expn += 1
    return col_num
  ```
  */
  //-----------------------------------------------------------------------------------------------------------
  this.get_letters = function(nr, alphabet = null) {
    var R, lcount, mod;
    /* Given an integer above zero and an optional list of characters, write out the integer using the
     A1 notation format (where after reaching the realm of single-letter codes, the first letter
     is prepended to the code to make up the next series). */
    if (!((nr > 0) && (nr === Math.floor(nr)))) {
      throw new Error(`µ42347 expected positive integer, got ${rpr(nr)}`);
    }
    if (alphabet == null) {
      alphabet = this.settings.alphabets.uppercase;
    }
    lcount = alphabet.length;
    R = '';
    while (nr > 0) {
      mod = modulo(nr - 1, lcount);
      R = alphabet[mod] + R;
      nr = Math.floor((nr - 1) / lcount);
    }
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.get_number = function(letters, alphabet = null) {
    var R, chr, expn, i, idx, lcount, len, ref;
    if (alphabet == null) {
      alphabet = this.settings.alphabets.uppercase;
    }
    lcount = alphabet.length;
    expn = 0;
    R = 0;
    ref = (Array.from(letters)).reverse();
    for (i = 0, len = ref.length; i < len; i++) {
      chr = ref[i];
      idx = alphabet.indexOf(chr);
      if (!(idx >= 0)) {
        throw new Error(`µ77822 expected character from alphabet ${rpr(alphabet)}, got ${rpr(chr)}`);
      }
      R += (idx + 1) * (lcount ** expn);
      expn += 1;
    }
    return R;
  };

}).call(this);

//# sourceMappingURL=a1letters.js.map