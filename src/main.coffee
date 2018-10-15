
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERGRID'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
#...........................................................................................................
jr                        = JSON.stringify

#-----------------------------------------------------------------------------------------------------------
@settings =
  alphabets:
    ll:   [ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
            'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ],
    ul:   [ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
            'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ],
  patterns:
    lls:  /^[a-z]+$/
    uls:  /^[A-Z]+$/

###
thx to https://stackoverflow.com/a/23862223/7568091 for this solution in Python:

```
def n2a(n,b=string.ascii_uppercase):
   d, m = divmod(n,len(b))
   return n2a(d-1,b)+b[m] if d else b[m]
```
###

#-----------------------------------------------------------------------------------------------------------
@_nr_from_ll = ( ll ) ->

#-----------------------------------------------------------------------------------------------------------
@_letter_from_nr_and_alphabet = ( nr, alphabet = null ) ->
  ### Given an integer above zero and an optional list of characters, write out the integer using the
  spreadsheet column letter format (where after reaching the realm of single-letter codes, the first letter
  is prepended to the code to make up the next series). ###
  throw new Error "42347" unless ( nr > 0 ) and ( nr is Math.floor nr )
  alphabet ?= @settings.alphabets.ll
  lcount    = alphabet.length
  R         = ''
  while nr > 0
    mod = ( nr - 1 ) %% lcount
    R   = alphabet[ mod ] + R
    nr  = ( nr - 1 ) // lcount
  return R


