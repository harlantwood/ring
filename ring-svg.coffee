#!/usr/bin/env coffee

fs = require 'fs'
{log} = require 'lightsaber'
{flatten} = require 'lodash'
{abs, floor, pow} = Math

class Ring

  hexWidth = 80
  hexHeight = 88.888888

  lineWidth = hexWidth
  lineHeightRoom = hexHeight / 6
  lineHeight = .6 * lineHeightRoom

  yinOpening = lineWidth / 8
  yinLineWidth = (lineWidth - yinOpening) / 2

  hexHeightRoom = hexHeight + lineHeight
  hexWidthRoom  = hexWidth + lineHeight * 2

  constructor: ->
    @lines = []
    @create()

  create: ->
    for hexagram in [0...64]
      for line in [0...6]
        yinyang = floor(hexagram / pow(2,line)) % 2
        x = (31.5 - abs(31.5 - hexagram)) * hexWidthRoom
        y = lineHeightRoom * line + 10
        y += hexHeightRoom if hexagram >= 32
        @lines.push @line { yinyang, x, y }

  line: ({yinyang, x, y}) ->
    return @yin  x, y if yinyang is 0
    return @yang x, y if yinyang is 1

  yin: (x, y) ->
    """
      #{@stroke x, y, yinLineWidth}
      #{@stroke x + yinLineWidth + yinOpening, y, yinLineWidth}
    """

  yang: (x, y) -> @stroke x, y, lineWidth

  stroke: (x, y, width) ->
    """<rect x="#{x}" y="#{y}" width="#{width}" height="#{lineHeight}" fill="black" />"""

  svg: ->
    """
      <svg version="1.1" baseProfile="full" width="6400" height="800" xmlns="http://www.w3.org/2000/svg">
      #{@lines.join "\n"}
      </svg>
    """

fs.writeFileSync 'ring.svg', (new Ring).svg()
