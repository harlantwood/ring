#!/usr/bin/env coffee

fs = require 'fs'
{log} = require 'lightsaber'
{flatten} = require 'lodash'
{floor, pow} = Math

class Ring
  hexWidth = 80
  hexHeight = 88.888888

  strokeWidth = hexWidth
  yinOpening = strokeWidth / 8
  yinStrokeWidth = (strokeWidth - yinOpening) / 2
  strokeHeightRoom = hexHeight / 6
  strokeHeight = .6 * hexHeight / 6

  constructor: ->
    @strokes = []

    for stroke in [0...6]
      for count in [0...32]
        @strokes.push @stroke
          yinyang: floor(count / pow(2,stroke)) % 2
          x: count * 100 + 10
          y: (strokeHeightRoom * stroke) + 10

    for stroke in [0...6]
      for count in [0...32]
        @strokes.push @stroke
          yinyang: floor(count / pow(2,stroke)) % 2
          x: count * 100 + 10
          y: hexHeight + strokeHeightRoom + (strokeHeightRoom * stroke) + 10

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
        width="3200" height="800"
        xmlns="http://www.w3.org/2000/svg">
        #{@strokes.join "\n"}
      </svg>
    """

fs.writeFileSync 'ring.svg', (new Ring).svg()
