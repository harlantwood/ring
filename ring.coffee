#!/usr/bin/env coffee

fs = require 'fs'
{log, p, pjson} = require 'lightsaber'
{flatten} = lodash = require 'lodash'
{abs, floor, pow} = Math

class Ring

  ringHeight = 6
  lineHeight = .3
  top = lineHeight
  hexHeightRoom = (ringHeight - top) / 2
  hexHeight = hexHeightRoom - lineHeight
  lineHeightRoom = hexHeight / 6

  ringCircumference = 81.1789
  hexWidthRoom = ringCircumference / 32
  hexHorizSpace = lineHeight*1.2
  left = hexHorizSpace/2
  hexWidth = hexWidthRoom - hexHorizSpace
  lineWidth = hexWidth
  yinOpening = lineWidth / 8
  yinLineWidth = (lineWidth - yinOpening) / 2

  browser = 10
  printer = 1
  target = browser
  # target = printer

  log pjson {
    ringHeight
    lineHeight
    top
    hexHeightRoom
    hexHeight
    lineHeightRoom

    ringCircumference
    hexWidthRoom
    hexWidth
    hexWidth
    lineWidth
    yinOpening
    yinLineWidth
  }

  constructor: ->
    @lines = flatten @create()

  create: ->
    for hexagram in [0...64]
      for line in [0...6]
        yinyang = floor(hexagram / pow(2,line)) % 2
        x = left + (31.5 - abs(31.5 - hexagram)) * hexWidthRoom
        y = top + lineHeightRoom * line
        y += hexHeightRoom if hexagram >= 32
        @line { yinyang, x, y }

  line: ({yinyang, x, y}) ->
    return @yin  x, y if yinyang is 0
    return @yang x, y if yinyang is 1

  yin: (x, y) ->
    """
      #{@stroke x, y, yinLineWidth, 'yin1'}
      #{@stroke x + yinLineWidth + yinOpening, y, yinLineWidth, 'yin2'}
    """

  yang: (x, y) -> @stroke x, y, lineWidth, 'yang'

  stroke: (x, y, width, note) ->
    x = round x * target
    y = round y * target
    width = round width * target
    height = round lineHeight * target
    """<rect x="#{x}" y="#{y}" width="#{width}" height="#{height}" fill="black"/>"""  #  note="#{note}"

  svg: ->
    """
      <svg version="1.1" baseProfile="full" width="#{ringCircumference*target}" height="#{ringHeight*target}" xmlns="http://www.w3.org/2000/svg">
      #{@lines.join "\n"}
      #{@border() if target is browser}
      </svg>
    """

  border: ->
    """<rect x="0" y="0" width="#{ringCircumference*target}" height="#{ringHeight*target}" stroke="lightblue" fill-opacity="0" />"""  #  note="#{note}"

  round = (n) -> lodash.round n, 4

fs.writeFileSync 'ring.svg', (new Ring).svg()
