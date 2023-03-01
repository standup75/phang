"use strict"

phang = require "phang"
data = require "../data.coffee"

button = null
fontSize = 80

displayLevelNumber = (fillColor = "#000") ->
	if data.gameIsDone()
		button = null
	else
		ctx = phang.globals.buttonCtx
		ctx.fillStyle = fillColor
		ctx.font = "#{fontSize}px Helvetica"
		levelNumber = data.currentLevelNumber() + 1
		numberWidth = ctx.measureText(levelNumber).width
		button =
			x: phang.globals.width - 35 - numberWidth
			y: phang.globals.height - 55
		ctx.fillText levelNumber, button.x, button.y
		ctx.fillRect phang.globals.width - 35 - numberWidth, phang.globals.height - 45, numberWidth, 4

isInside = (x, y) -> button and x >= button.x and y + fontSize >= button.y

gotoLevelSelection = (x, y) ->
	if isInside x, y
		displayLevelNumber "#666"
		location.href = "views/levelSelection.html"

phang.pubsub.subscribe "readyToPlay", displayLevelNumber
phang.pubsub.subscribe "touch", gotoLevelSelection
