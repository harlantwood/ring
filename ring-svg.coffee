#!/usr/bin/env coffee

fs = require 'fs'
{log} = require 'lightsaber'
{flatten} = require 'lodash'

fs.writeFileSync 'ring.svg', """
    <svg version="1.1"
      baseProfile="full"
      width="3200" height="800"
      xmlns="http://www.w3.org/2000/svg">

      <rect x="10" y="10" width="80" height="88.88" fill="black" />
      <rect x="10" y="10" width="80" height="88.88" fill="black" />
      <rect x="110" y="10" width="80" height="88.88" fill="black" />
      <rect x="210" y="10" width="80" height="88.88" fill="black" />
      <rect x="310" y="10" width="80" height="88.88" fill="black" />
    </svg>
  """
