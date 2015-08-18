#!/usr/bin/env coffee

fs = require 'fs'
{log} = require 'lightsaber'
{flatten} = require 'lodash'
{floor} = Math

class Ring
  hexWidth = 80
  hexHeight = 88.88

  strokeWidth = hexWidth
  strokeHeightRoom = hexHeight / 6
  strokeHeight = .6 * hexHeight / 6

  constructor: ->
    @strokes = []

    for count in [0...32]
      @strokes.push @stroke
        yinyang: count % 2
        x: count * 100 + 10
        y: 10

    for count in [0...32]
      @strokes.push @stroke
        yinyang: floor(count / 2) % 2
        x: count * 100 + 10
        y: strokeHeightRoom + 10

    for count in [0...32]
      @strokes.push @stroke
        yinyang: floor(count / 4) % 2
        x: count * 100 + 10
        y: (strokeHeightRoom * 2) + 10

    for count in [0...32]
      @strokes.push @stroke
        yinyang: floor(count / 8) % 2
        x: count * 100 + 10
        y: (strokeHeightRoom * 3) + 10

    for count in [0...32]
      @strokes.push @stroke
        yinyang: floor(count / 16) % 2
        x: count * 100 + 10
        y: (strokeHeightRoom * 4) + 10

    for count in [0...32]
      @strokes.push @stroke
        yinyang: floor(count / 32) % 2
        x: count * 100 + 10
        y: (strokeHeightRoom * 5) + 10

  stroke: ({yinyang, x, y}) ->
    return @yin  x, y if yinyang is 0
    return @yang x, y if yinyang is 1

  yin: (x, y) ->
    """<rect x="#{x}" y="#{y}" width="#{strokeWidth}" height="#{strokeHeight}" fill="white" />"""

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
