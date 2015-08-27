#!/usr/bin/env coffee

##########################################################################################################
##########################################################################################################
##########################################################################################################
### This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License ###
### <http://creativecommons.org/licenses/by-nc/4.0/>                                                   ###
### For commercial license, please contact Harlan T Wood -- wizardry@harlantwood.net                   ###
##########################################################################################################
##########################################################################################################
##########################################################################################################

fs = require 'fs'
{log, p, pjson} = require 'lightsaber'
{flatten} = lodash = require 'lodash'
{abs, floor, pow} = Math

browser = 64
printer = 1
phi = 1.6180339887498948482

class Ring
  ringCircumference = 81.1789
  hexWidthRoom = ringCircumference / 64
  chiselTip = hexWidthRoom / 4
  hexWidth = chiselTip * 3
  lineWidth = hexWidth
  yinOpening = chiselTip
  yinLineWidth = chiselTip
  hexHorizSpace = hexWidthRoom - hexWidth
  left = hexHorizSpace / 2

  ringHeight = 4
  lineHeight = chiselTip
  lineHeightSpacing = lineHeight
  lineHeightRoom = lineHeight + lineHeightSpacing
  hexHeight = lineHeight * 6 + lineHeightSpacing * 5
  top = (ringHeight - hexHeight) / 2

  log pjson { chiselTip, ringHeight, lineHeight, top, lineHeightSpacing, hexHeight, lineHeightRoom, ringCircumference, hexWidthRoom, hexWidth, hexWidth, lineWidth, yinOpening, yinLineWidth, left }

  strokes: (target) -> flatten @hexagramStrokes target

  hexagramStrokes: (target) ->
    for hexagram in [0...64]
      for line in [0...6]
        yinyang = floor(hexagram / pow(2,line)) % 2
        x = left + hexagram * hexWidthRoom
        y = top + line * lineHeightRoom
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
      <!--
        This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License
        <http://creativecommons.org/licenses/by-nc/4.0/>
        For commercial license, please contact Harlan T Wood -- wizardry@harlantwood.net
      -->
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
