{log} = require 'lightsaber'
{flatten} = require 'lodash'

zero = 19904
trigrams = [
  '☷'
  '☳'
  '☵'
  '☱'
  '☶'
  '☲'
  '☴'
  '☰'
]
friendly = false

log ''

top = for tri in [4...8]
  for rep in [0...8]
    "#{if friendly then tri*8+rep else ''}#{trigrams[tri]}"
log (flatten top).join ' '

bottom = for tri in [32...64]
  "#{if friendly then tri else ''}#{trigrams[tri % 8]}"
log bottom.join ' '

log ''

top = for tri in [0...4]
  for rep in [0...8]
    "#{if friendly then tri*8+rep else ''}#{trigrams[tri]}"
log (flatten top).join ' '

bottom = for tri in [0...32]
  "#{if friendly then tri else ''}#{trigrams[tri % 8]}"
log bottom.join ' '

log ''







# he = require 'he'
# yang = 19904
#
# chars = for utf in [yang...yang+32]
#   he.decode "&##{utf};"
# log chars.join ' '
#
# chars = for utf in [yang+32...yang+64]
#   he.decode "&##{utf};"
# log chars.join ' '
