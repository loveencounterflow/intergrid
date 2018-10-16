

# InterGrid

#### `INTERGRID.A1LETTERS`

**`INTERGRID.A1LETTERS.get_letters = ( nr, alphabet = null ) ->`** Given an
integer above zero and an optional alphabet (a list of characters), return the
integer written in the A1 notation format (where after reaching the realm of
single-letter codes, the first letter is prepended to the code to make up the
next series). This function is wholly generic and works with arbitrary
alphabets. Default alphabet is lowercase ASCII, `a`, `b` ... `z`.

-------------------------

**`INTERGRID.A1LETTERS.get_number = ( letters, alphabet = null ) ->`** The
inverse of `INTERGRID.A1LETTERS.get_letters()`.

-------------------------

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
* **`cellnr`**—Set to the numerical value of the referenced cell, starting with
  1 when `cellletters` is set.
* **`rownr`**—Set to the numerical value of the referenced row, starting with 1
  when `rowdigits` is set.

The sum total of allowed cellrefs is succinctly captured by this railroad diagram:

![](https://github.com/loveencounterflow/intergrid/raw/master/artwork/INTERGRID.A1CELLS.settings.patterns.a1_lowercase.railroad.png)

In general, the respective attribute on the result is set to the text portion
that corresponds to the position in question, and will be absent where not
applicable. However,

* plus signs as in `'+a3'`, `'a+3'`, `'+a+3'` are silently ignored since they
  are always redundant; therefore, if either `result.colsign` or
  `result.rowsign` exist, that the colum or row has been given with a minus
  sign.

* `'*'` and `'**'` are identical and always have all of `star`, `colstar` and
  `rowstar` set (always to `'*'`).

* Leading `0`s in `rowdigits` are always trimmed, so both `'a12'` and `'a012'`
  will set `rowdigits` to `'12'`.

These rules are intended to make evaluation of parsing results as
straightforward as possible.

-------------------------

**`INTERGRID.A1CELLS.get_cellkey = ( cellref ) ->`** Given a cellref as a Plain
Old Dictionary that has (at least) the keys `cellnr` and `rownr` set to integer
numbers (*not* digits), return the corresponding cellkey. The input must roughly
conform to the rules laid out for `INTERGRID.A1CELLS.parse_cellkey`. If `colnr`
and/or `rownr` are unset or set to `null` or `undefined` or `colstar` and / or
`rowstar` are set to `'*'`, a star will be used in that position; when both
`colnr` *and* `rownr` are missing a single star will be returned. In any case,
`colsign`, `rowsign` and other attributes that are present in the return value
of `INTERGRID.A1CELLS.parse_cellkey` will be silently ignored ATM (and not be
checked for consistency).

In short, this method will convert the following data structures to the values
shown on the right:

| input                         | output |
| :-----                        | :----- |
| {}                            | "*"    |
| { colstar:"*"}               | "*"    |
| { rowstar:"*"}               | "*"    |
| { colstar:"*", rowstar:"*"} | "*"    |
| { star: "*"}                  | "*"    |
| { colnr:10, rowstar:"*"}    | "j*"   |
| { colnr:53, rowstar:"*"}    | "ba*"  |
| { colnr:-10, rowstar:"*"}   | "-j*"  |
| { colnr:-53, rowstar:"*"}   | "-ba*" |
| { colnr:10}                  | "j*"   |
| { colnr:53}                  | "ba*"  |
| { colnr:-10}                 | "-j*"  |
| { colnr:-53}                 | "-ba*" |
| { rownr: 10}                  | "*10"  |
| { rownr: 53}                  | "*53"  |
| { rownr: -10}                 | "*-10" |
| { rownr: -53}                 | "*-53" |
| { rownr: 10,colstar:"*"}    | "*10"  |
| { rownr: 53,colstar:"*"}    | "*53"  |
| { rownr: -10,colstar:"*"}   | "*-10" |
| { rownr: -53,colstar:"*"}   | "*-53" |



-------------------------

**`INTERGRID.A1CELLS.normalize_cellkey = ( cellkey ) ->`** Given a cellkey,
return the same written with leading zeroes and plus signs removed. This is
identical to
`INTERGRID.A1CELLS.get_cellkey(INTERGRID.A1CELLS.parse_cellkey(cellkey))`.


