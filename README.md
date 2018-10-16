

# InterGrid

#### `INTERGRID.A1LETTERS`

**`INTERGRID.A1LETTERS.get_letters = ( nr, alphabet = null ) ->`** Given an
integer above zero and an optional alphabet (a list of characters), return
the integer written in the A1 notation format (where after reaching the realm of
single-letter codes, the first letter is prepended to the code to make up the
next series). This function is wholly generic and works with arbitrary alphabets. Default alphabet is
lowercase ASCII, `a`, `b` ... `z`.

**`INTERGRID.A1LETTERS.get_number = ( letters, alphabet = null ) ->`** The inverse of
`INTERGRID.A1LETTERS.get_letters()`.

