

# InterGrid

#### `INTERGRID.A1LETTERS`

**`INTERGRID.A1LETTERS.get_letters = ( nr, alphabet = null ) ->`** Given an
integer above zero and an optional alphabet (a list of characters), return the
integer written in the A1 notation format (where after reaching the realm of
single-letter codes, the first letter is prepended to the code to make up the
next series). This function is wholly generic and works with arbitrary
alphabets. Default alphabet is lowercase ASCII, `a`, `b` ... `z`.

**`INTERGRID.A1LETTERS.get_number = ( letters, alphabet = null ) ->`** The
inverse of `INTERGRID.A1LETTERS.get_letters()`.

<!-- **`@get_cellref = ( cellkey ) ->`** Given a cellkey  -->

**`INTERGRID.A1CELLS.parse_cellref = ( cellref ) ->`** Given a cellref like
`'a1'`, `'*'`, `'ac23'`, `b*`, `*` or similar, return a POD with two or more of
the following attributes:

* **`star`**—Set to `'*'` when both `colstar` and `rowstar` are set.
* **`colstar`**—Set to `'*'` when the column position has a star, as in `'*23'`
  (meaning row `23`).
* **`colsign`**—Set to `'-'` when the column letter was preceded with a minus
  sign. An optional `'+'` in that position will be silently ignored.
* **`colletters`**—Set to the sequence of letters that identify the column of
  the cell(s). Missing if `colstar` is set.
* **`rowstar`**—Set to `'*'` when the row position has a star, as in `'b*'`
  (meaning column `b`).
* **`rowsign`**—Set to `'-'` when the row number was preceded with a minus sign.
  An optional `'+'` in that position will be silently ignored.
* **`rowdigits`**—Set to the sequence of digits that identify the row of the
  cell(s). Missing if `colstar` is set.

The sum total of allowed cellrefs is succinctly captured by this railroad diagram:

![](https://github.com/loveencounterflow/intergrid/raw/master/artwork/INTERGRID.A1CELLS.settings.patterns.a1_lowercase.railroad.png)

