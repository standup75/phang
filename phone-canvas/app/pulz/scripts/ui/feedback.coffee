"use strict"

phang = require "phang"
level = require "../level.coffee"
data = require "../data.coffee"
config = require "../config.coffee"
CountButton = require "./countButton.coffee"

isLocked = canvasFill = canvasStroke = feedbackAlpha = msgAlpha = button = null
touchX = touchY = -1
lastUnlimitedTaplevel = 5
crossMargin = 50
crossSize = 55
tapImg = phang.images.load "tap.png"

startFeedback = ->
	canvasFill = document.createElement "canvas"
	ctxFill = canvasFill.getContext "2d"
	canvasFill.width = phang.globals.width
	canvasFill.height = phang.globals.height
	canvasStroke = document.createElement "canvas"
	ctxStroke = canvasStroke.getContext "2d"
	canvasStroke.width = phang.globals.width
	canvasStroke.height = phang.globals.height
	feedbackAlpha = 0.85
	hasSameTiles = false
	currentLevel = data.currentLevel()
	ctxFill.fillStyle = config.feedbackColor
	ctxStroke.strokeStyle = config.feedbackColor
	rectMargin = config.tileBorderMargin
	ctxStroke.lineWidth = 4
	for col, x in level.tiles()
		for tile, y in col
			if level.isSame tile, x, y
				hasSameTiles = true
				ctxFill.fillRect(
					currentLevel.boardX + currentLevel.tileWidthDest * x
					currentLevel.boardY + currentLevel.tileHeightDest * y
					currentLevel.tileWidthDest
					currentLevel.tileHeightDest)
				ctxStroke.strokeStyle = "rgba(0, 0, 0, 0.5)"
				ctxStroke.strokeRect(
					currentLevel.boardX + currentLevel.tileWidthDest * x + rectMargin + 1
					currentLevel.boardY + currentLevel.tileHeightDest * y + rectMargin + 1
					currentLevel.tileWidthDest - 2 * rectMargin
					currentLevel.tileHeightDest - 2 * rectMargin)
				ctxStroke.strokeStyle = config.feedbackColor
				ctxStroke.strokeRect(
					currentLevel.boardX + currentLevel.tileWidthDest * x + rectMargin
					currentLevel.boardY + currentLevel.tileHeightDest * y + rectMargin
					currentLevel.tileWidthDest - 2 * rectMargin
					currentLevel.tileHeightDest - 2 * rectMargin)
	if hasSameTiles
		lock()
		phang.pubsub.subscribe "repaint", repaintAndFade

repaint = ->
	feedbackCtx = phang.globals.feedbackCtx
	phang.ui.clear feedbackCtx
	if canvasFill
		feedbackCtx.save()
		feedbackCtx.globalAlpha = Math.round(feedbackAlpha * 100) / 100
		feedbackCtx.drawImage canvasFill, 0, 0
		feedbackCtx.restore()
		feedbackCtx.drawImage canvasStroke, 0, 0
	drawTapCount()

repaintAndFade = ->
	feedbackAlpha -= 0.05
	repaint()
	if feedbackAlpha <= 0
		unlock()
		phang.pubsub.unsubscribe "repaint", repaintAndFade
		if level.tapLeft() > 0
			phang.persist.tapCount phang.persist.tapCount() + 1
			drawTapCount()

touch = (x, y) -> [touchX, touchY] = [x, y]  if isInsideBoard(x, y) and not isLocked

refresh = ->
	if not isLocked
		phang.ui.clear phang.globals.feedbackCtx
		drawTapCount()

isInsideBoard = (x, y) ->
	currentLevel = data.currentLevel()
	if level.tapLeft() > 0
		y > button.y and y < button.y + button.height and x > button.x and x < button.x + button.width
	else
		y -= currentLevel.boardY
		x -= currentLevel.boardX
		y > 0 and y < currentLevel.boardHeight and x > 0 and x < currentLevel.boardWidth

touchend = (x, y) ->
	return  if isLocked
	if Math.abs(x - touchX) is 0 and Math.abs(y - touchY) is 0
		if level.tapLeft() isnt 0 and level.score() > 0
			startFeedback()
		else
			lock()
			drawingFct = if level.tapLeft() is 0 then drawCross else drawZero
			msgAlpha = 1
			phang.ui.repeat 20, drawingFct, ->
				unlock()
				refresh()
	touchX = touchY = -1

drawCross = ->
	repaint()
	currentLevel = data.currentLevel()
	ctx = phang.globals.feedbackCtx
	ctx.save()
	ctx.strokeStyle = config.crossColor
	ctx.lineWidth = 14
	ctx.globalAlpha = msgAlpha
	ctx.beginPath()
	ctx.moveTo currentLevel.boardX + crossMargin, currentLevel.boardY + crossMargin
	ctx.lineTo currentLevel.boardX + crossSize + crossMargin, currentLevel.boardY + crossSize + crossMargin
	ctx.moveTo currentLevel.boardX + crossMargin, currentLevel.boardY + crossSize + crossMargin
	ctx.lineTo currentLevel.boardX + crossSize + crossMargin, currentLevel.boardY + crossMargin
	ctx.stroke()
	ctx.restore()
	msgAlpha -= 0.05

drawZero = ->
	repaint()
	currentLevel = data.currentLevel()
	ctx = phang.globals.feedbackCtx
	ctx.save()
	ctx.fillStyle = config.feedbackColor
	ctx.font = "bold 55px Helvetica"
	ctx.globalAlpha = msgAlpha
	ctx.beginPath()
	x = currentLevel.boardX + crossMargin
	y = currentLevel.boardY + crossMargin + crossSize
	ctx.fillText "0", x, y
	ctx.restore()
	msgAlpha -= 0.05

drawTapCount = ->
	if data.currentLevel().maxTapCount
		button.clear()
		button.displayButton()
		button.displayCount level.tapLeft()

moved = (isMoving) ->
	drawTapCount()
	startFeedback()  unless data.currentLevel().maxTapCount? or isMoving
lock = -> isLocked = true
unlock = -> isLocked = false
init = ->
	canvasFill = null
	lock()  unless isLocked?
readyToPlay = ->
	button = new CountButton tapImg, phang.globals.feedbackCtx, 15, "centered"
	unlock()
	refresh()

phang.pubsub.subscribe "moved", moved
phang.pubsub.subscribe "won", lock
phang.pubsub.subscribe "touch", touch
phang.pubsub.subscribe "touchend", touchend
phang.pubsub.subscribe "touchmove", refresh
phang.pubsub.subscribe "readyToPlay", readyToPlay
phang.pubsub.subscribe "levelReady", init, 300
phang.pubsub.subscribe "levelComplete", lock
