

# InterGrid

## Installation

```sh
npm install intergrid
```

## Usage

```js
const IG = require( 'intergrid' );
```


#### Module `IG.LETTERS`

**`IG.LETTERS.get_letters = ( nr, alphabet = null ) ->`** Given an integer above
zero and an optional alphabet (a list of characters), return the integer written
in the A1 notation format (where after reaching the realm of single-letter
codes, the first letter is prepended to the code to make up the next series).
This function is wholly generic and works with arbitrary alphabets. Default
alphabet is lowercase ASCII, `a`, `b` ... `z`.

Note that although the rest of InterGrid supports negative references to columns
and rows, methods `IG.LETTERS` reject negative values.

-------------------------

**`IG.LETTERS.get_number = ( letters, alphabet = null ) ->`** The
inverse of `IG.LETTERS.get_letters()`.

#### Module `IG.CELLS`

**`IG.CELLS.parse_cellkey = ( cellkey ) ->`** Given a cellref like
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

![](https://github.com/loveencounterflow/intergrid/raw/master/artwork/IG.CELLS.settings.patterns.a1_lowercase.railroad.png)

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

To make the above more digestible, here's what you'll get out when you put in the values
shown on the left:


| input            | output                                                                                            |
| :-----           | :-----                                                                                            |
| `'*'`            | `{ star: '*', colstar: '*', rowstar: '*' }`                                                       |
| `'**'`           | `{ colstar: '*', rowstar: '*', star: '*' }`                                                       |
| `'a1'`           | `{ colletters: 'a', rowdigits: '1', colnr: 1, rownr: 1 }`                                         |
| `'-a1'`          | `{ colsign: '-',   colletters: 'a',   rowdigits: '1',   colnr: -1,   rownr: 1 }`                  |
| `'a-1'`          | `{ colletters: 'a',   rowsign: '-',   rowdigits: '1',   colnr: 1,   rownr: -1 }`                  |
| `'-a-1'`         | `{ colsign: '-',   colletters: 'a',   rowsign: '-',   rowdigits: '1',   colnr: -1,   rownr: -1 }` |
| `'+a01'`         | `{ colletters: 'a', rowdigits: '1', colnr: 1, rownr: 1 }`                                         |
| `'a*'`           | `{ colletters: 'a', rowstar: '*', colnr: 1 }`                                                     |
| `'+a*'`          | `{ colletters: 'a', rowstar: '*', colnr: 1 }`                                                     |
| `'-a*'`          | `{ colsign: '-', colletters: 'a', rowstar: '*', colnr: -1 }`                                      |
| `'*1'`           | `{ colstar: '*', rowdigits: '1', rownr: 1 }`                                                      |
| `'*+12'`         | `{ colstar: '*', rowdigits: '12', rownr: 12 }`                                                    |
| `'*+00012'`      | `{ colstar: '*', rowdigits: '12', rownr: 12 }`                                                    |
| `'*-2'`          | `{ colstar: '*', rowsign: '-', rowdigits: '2', rownr: -2 }`                                       |
| `'a+1'`          | `{ colletters: 'a', rowdigits: '1', colnr: 1, rownr: 1 }`                                         |
| `'+a+1'`         | `{ colletters: 'a', rowdigits: '1', colnr: 1, rownr: 1 }`                                         |
| `'+a-1'`         | `{ colletters: 'a',   rowsign: '-',   rowdigits: '1',   colnr: 1,   rownr: -1 }`                  |
| `'+abc-123'`     | `{ colletters: 'abc',   rowsign: '-',   rowdigits: '123',   colnr: 731,   rownr: -123 }`          |
| `'+abc-0000123'` | `{ colletters: 'abc',   rowsign: '-',   rowdigits: '123',   colnr: 731,   rownr: -123 }`          |
| `'z1'`           | `{ colletters: 'z', rowdigits: '1', colnr: 26, rownr: 1 }`                                        |
| `'aa1'`          | `{ colletters: 'aa', rowdigits: '1', colnr: 27, rownr: 1 }`                                       |
| `'ab1'`          | `{ colletters: 'ab', rowdigits: '1', colnr: 28, rownr: 1 }`                                       |
| `'ac1'`          | `{ colletters: 'ac', rowdigits: '1', colnr: 29, rownr: 1 }`                                       |
| `'ay1'`          | `{ colletters: 'ay', rowdigits: '1', colnr: 51, rownr: 1 }`                                       |
| `'az1'`          | `{ colletters: 'az', rowdigits: '1', colnr: 52, rownr: 1 }`                                       |
| `'ba1'`          | `{ colletters: 'ba', rowdigits: '1', colnr: 53, rownr: 1 }`                                       |
| `'cv1'`          | `{ colletters: 'cv', rowdigits: '1', colnr: 100, rownr: 1 }`                                      |
| `'all1'`         | `{ colletters: 'all', rowdigits: '1', colnr: 1000, rownr: 1 }`                                    |
| `'whassupman1'`  | `{ colletters: 'whassupman',   rowdigits: '1',   colnr: 126563337975660,   rownr: 1 }`            |

-------------------------

**`IG.CELLS.get_cellkey = ( cellref ) ->`** Given a cellref as a Plain
Old Dictionary that has (at least) the keys `cellnr` and `rownr` set to integer
numbers (*not* digits), return the corresponding cellkey. The input must roughly
conform to the rules laid out for `IG.CELLS.parse_cellkey`. If `colnr`
and/or `rownr` are unset or set to `null` or `undefined` or `colstar` and / or
`rowstar` are set to `'*'`, a star will be used in that position; when both
`colnr` *and* `rownr` are missing a single star will be returned. In any case,
`colsign`, `rowsign` and other attributes that are present in the return value
of `IG.CELLS.parse_cellkey` will be silently ignored ATM (and not be
checked for consistency).

In short, this method will convert the following data structures to the values
shown on the right:

| input                                             | output             |
| :-----                                            | :-----             |
| `{ colnr: 10, rownr: 1, }`                        | `'j1'`             |
| `{ colnr: 26, rownr: 1, }`                        | `'z1'`             |
| `{ colnr: 27, rownr: 1, }`                        | `'aa1'`            |
| `{}`                                              | `'*'`              |
| `{ colstar:  '*', }`                              | `'*'`              |
| `{ rowstar:  '*', }`                              | `'*'`              |
| `{ colstar:  '*', rowstar: '*', }`                | `'*'`              |
| `{ star:     '*', }`                              | `'*'`              |
| `{ colnr: 10,  rowstar: '*', }`                   | `'j*'`             |
| `{ colnr: 53,  rowstar: '*', }`                   | `'ba*'`            |
| `{ colnr: -10, rowstar: '*', }`                   | `'-j*'`            |
| `{ colnr: -53, rowstar: '*', }`                   | `'-ba*'`           |
| `{ colnr: 10, }`                                  | `'j*'`             |
| `{ colnr: 53, }`                                  | `'ba*'`            |
| `{ colnr: -10, }`                                 | `'-j*'`            |
| `{ colnr: -53, }`                                 | `'-ba*'`           |
| `{ rownr: 10, }`                                  | `'*10'`            |
| `{ rownr: 53, }`                                  | `'*53'`            |
| `{ rownr: -10, }`                                 | `'*-10'`           |
| `{ rownr: -53, }`                                 | `'*-53'`           |
| `{ colstar: '*', rownr: 10, }`                    | `'*10'`            |
| `{ colstar: '*', rownr: 53, }`                    | `'*53'`            |
| `{ colstar: '*', rownr: -10, }`                   | `'*-10'`           |
| `{ colstar: '*', rownr: -53, }`                   | `'*-53'`           |
| `{ colnr: Number.MAX_SAFE_INTEGER, rownr: -53, }` | `'bktxhsoghkke53'` |



-------------------------

**`IG.CELLS.normalize_cellkey = ( cellkey ) ->`** Given a cellkey,
return the same written with leading zeroes and plus signs removed. This is
identical to
`IG.CELLS.get_cellkey(IG.CELLS.parse_cellkey(cellkey))`.

# Disclaimer

> This software is a non-profit effort and free to use for anyone. It is not in
> any way associated with any of the many firms of the same name that a [web
> search](https://duckduckgo.com/?q=InterGrid&t=lm&ia=web) reveals.


