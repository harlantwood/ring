#!/usr/bin/env coffee

fs = require 'fs'
{log, p, pjson} = require 'lightsaber'
{flatten} = lodash = require 'lodash'
{abs, floor, pow} = Math

browser = 10
printer = 1

class Ring

  ringHeight = 4
  lineHeight = .2
  top = lineHeight
  hexHeightRoom = (ringHeight - top) / 2
  hexHeight = hexHeightRoom - lineHeight
  lineHeightRoom = hexHeight / 6

  ringCircumference = 81.1789
  hexWidthRoom = ringCircumference / 32
  hexHorizSpace = lineHeight*3
  left = hexHorizSpace/2
  hexWidth = hexWidthRoom - hexHorizSpace
  lineWidth = hexWidth
  yinOpening = lineWidth / 8
  yinLineWidth = (lineWidth - yinOpening) / 2

  log pjson { ringHeight, lineHeight, top, hexHeightRoom, hexHeight, lineHeightRoom, ringCircumference, hexWidthRoom, hexWidth, hexWidth, lineWidth, yinOpening, yinLineWidth }

  strokes: (target) -> flatten @hexagramStrokes target

  hexagramStrokes: (target) ->
    for hexagram in [0...64]
      for line in [0...6]
        yinyang = floor(hexagram / pow(2,line)) % 2
        x = left + (31.5 - abs(31.5 - hexagram)) * hexWidthRoom
        y = top + lineHeightRoom * line
        y += hexHeightRoom if hexagram >= 32
        @line { yinyang, x, y, target }

  line: ({yinyang, x, y, target}) ->
    return @yin  x, y, target if yinyang is 0
    return @yang x, y, target if yinyang is 1

  yin: (x, y, target) ->
    """
      #{@stroke x, y, yinLineWidth, target}
      #{@stroke x + yinLineWidth + yinOpening, y, yinLineWidth, target}
    """

  yang: (x, y, target) -> @stroke x, y, lineWidth, target

  stroke: (x, y, width, target) ->
    x = round x * target
    y = round y * target
    width = round width * target
    height = round lineHeight * target
    @rect { x, y, width, height }

  rect: (args) ->
    svgArgs = for k, v of args
      "#{k}=\"#{v}\""
    """<rect #{svgArgs.join ' '} />"""

  svg: (target) ->
    width = ringCircumference * target
    height = ringHeight * target

    """
      <svg version="1.1" baseProfile="full" width="#{width}" height="#{height}" xmlns="http://www.w3.org/2000/svg">
      #{@strokes(target).join "\n"}
      #{if target is browser then @border width, height else ''}
      </svg>
    """

  border: (width, height) ->
    @rect {
      x: 0
      y: 0
      width
      height
      stroke: "lightblue"
      'fill-opacity': 0
    }

  round = (n) -> lodash.round n, 4

fs.writeFileSync 'ring-printer.svg', (new Ring).svg printer
fs.writeFileSync 'ring-browser.svg', (new Ring).svg browser
