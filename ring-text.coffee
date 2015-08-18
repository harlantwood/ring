#!/usr/bin/env coffee

{log} = require 'lightsaber'
{flatten} = require 'lodash'

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

top = for tri in [8-1..4]
  for rep in [8-1..0]
    "#{if friendly then tri*8+rep else ''}#{trigrams[tri]}"
log (flatten top).join ' '

bottom = for tri in [64-1..32]
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
