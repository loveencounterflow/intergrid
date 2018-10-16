

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

**`INTERGRID.A1CELLS.parse_cellkey = ( cellkey ) ->`** Given a cellref like
`'a1'`, `'*'`, `'ac23'`, `b*`, `**` or similar, return a POD with two or more of
the following attributes:

* **`star`**—Set to `'*'` when the cellref is `'*'`, or when both `colstar` and
  `rowstar` are set.
* **`colstar`**—Set to `'*'` when the column position has a star, as in `'*23'`
  (meaning row `23`), and also when `star` is set.
* **`colsign`**—Set to `'-'` when the column letter was preceded with a minus
  sign. An optional `'+'` in that position will be silently ignored.
* **`colletters`**—Set to the sequence of letters that identify the column of
  the cell(s). Missing if `colstar` is set.
* **`rowstar`**—Set to `'*'` when the row position has a star, as in `'b*'`
  (meaning column `b`), and also when `star` is set.
* **`rowsign`**—Set to `'-'` when the row number was preceded with a minus sign.
  An optional `'+'` in that position will be silently ignored.
* **`rowdigits`**—Set to the sequence of digits that identify the row of the
  cell(s). Missing if `colstar` is set.

The sum total of allowed cellrefs is succinctly captured by this railroad diagram:

![](https://github.com/loveencounterflow/intergrid/raw/master/artwork/INTERGRID.A1CELLS.settings.patterns.a1_lowercase.railroad.png)

In general, the respective attribute on the result is set to the text portion
that corresponds to the position in question, and will be absent where not
applicable. However, plus signs as in `'+a3'`, `'a+3'`, `'+a+3'` are silently
ignored since it is always redundant; therefore, if either `result.colsign` or
`result.rowsign` exist, that the colum or row has been given with a minus sign.
Further, `'*'` and `'**'` are identical and always have all of `star`, `colstar`
and `rowstar` set (always to `'*'`). These rules are intended to make evaluation
of parsing results as straightforward as possible.
