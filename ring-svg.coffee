#!/usr/bin/env coffee

fs = require 'fs'
{log} = require 'lightsaber'
{flatten} = require 'lodash'
{abs, floor, pow} = Math

class Ring

  hexWidth = 80
  hexHeight = 88.888888

  strokeWidth = hexWidth
  strokeHeightRoom = hexHeight / 6
  strokeHeight = .6 * strokeHeightRoom

  yinOpening = strokeWidth / 8
  yinStrokeWidth = (strokeWidth - yinOpening) / 2

  hexHeightRoom = hexHeight + strokeHeight
  hexWidthRoom  = hexWidth + strokeHeight*2

  constructor: ->
    @strokes = []
    @create()

  create: ->
    for hexagram in [0...64]
      for stroke in [0...6]
        yinyang = floor(hexagram / pow(2,stroke)) % 2
        x = (31.5 - abs(31.5 - hexagram)) * hexWidthRoom
        y = strokeHeightRoom * stroke + 10
        y += hexHeightRoom if hexagram >= 32
        @strokes.push @stroke { yinyang, x, y }

  stroke: ({yinyang, x, y}) ->
    return @yin  x, y if yinyang is 0
    return @yang x, y if yinyang is 1

  yin: (x, y) ->
    """
      <rect x="#{x}" y="#{y}" width="#{yinStrokeWidth}" height="#{strokeHeight}" fill="black" />
      <rect x="#{x + yinStrokeWidth + yinOpening}" y="#{y}" width="#{yinStrokeWidth}" height="#{strokeHeight}" fill="black" />
    """

  yang: (x, y) ->
    """<rect x="#{x}" y="#{y}" width="#{strokeWidth}" height="#{strokeHeight}" fill="black" />"""

  svg: ->
    """
      <svg version="1.1"
        baseProfile="full"
        width="6400" height="800"
        xmlns="http://www.w3.org/2000/svg">
        #{@strokes.join "\n"}
      </svg>
    """

fs.writeFileSync 'ring.svg', (new Ring).svg()
