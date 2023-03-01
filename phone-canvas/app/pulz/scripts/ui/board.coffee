"use strict"

phang = require "phang"
level = require "../level.coffee"
data = require "../data.coffee"
config = require "../config.coffee"

defaultIncrement = 0.05 # speed at which moves are made
backSpeed = 0.2 # speed at which backward moves are made
startPauseLength = 25
startPauseCounter = 0
tileCanvases = currentLevel = currentInitMove = initMoves = startX = startY = shiftX = shiftY = movingCol = movingRow = isLocked = null
noiseImg = phang.images.load "noise.jpg"
checkmarkImg = phang.images.load "checkmark.png"

drawTile = (ctx, tile, tileX, tileY) ->
	ctx.drawImage tileCanvases[tile[0]][tile[1]], tileX, tileY

drawBorders = ->
	return  if currentLevel.hasBorders? and not currentLevel.hasBorders
	# prepare context
	canvas = document.createElement "canvas"
	canvas.width = phang.globals.width
	canvas.height = phang.globals.height
	ctx = canvas.getContext "2d"
	ctx.fillStyle = "#000000"
	ctx.fillRect currentLevel.boardX - 1, currentLevel.boardY, currentLevel.boardWidth + 2, currentLevel.boardHeight
	ctx.globalAlpha = 0.35
	ctx.fillStyle = currentLevel.backgroundColor
	ctx.fillRect currentLevel.boardX - 1, currentLevel.boardY, currentLevel.boardWidth + 2, currentLevel.boardHeight
	ctx.globalAlpha = 0.8
	ctx.strokeStyle = "#000000"
	ctx.lineWidth = 2
	# draw image
	ctx.drawImage(
		currentLevel.image
		0
		0
		currentLevel.image.width
		currentLevel.image.height
		currentLevel.boardX - 1
		currentLevel.boardY
		currentLevel.boardWidth + 2
		currentLevel.boardHeight)
	# draw borders by removing tiles
	for col, x in level.tiles()
		for tile, y in col
			tileCoords =
				x: currentLevel.boardX + config.margin + currentLevel.tileWidthDest * x
				y: currentLevel.boardY + config.margin + currentLevel.tileHeightDest * y
				width: currentLevel.tileWidthDest - 2 * config.margin
				height: currentLevel.tileHeightDest - 2 * config.margin
			ctx.clearRect(
				tileCoords.x
				tileCoords.y
				tileCoords.width
				tileCoords.height)
	ctx.restore()
	phang.globals.borderCtx.clearRect currentLevel.boardX, currentLevel.boardY, currentLevel.boardWidth, currentLevel.boardHeight
	phang.globals.borderCtx.drawImage canvas, 0, 0

repaint = (redrawAll) ->
	# prepare context
	ctx = phang.globals.mainCtx
	ctx.save()
	ctx.beginPath()
	ctx.rect currentLevel.boardX, currentLevel.boardY, currentLevel.boardWidth, currentLevel.boardHeight
	ctx.clip()
	# draw tiles
	for col, x in level.tiles()
		for tile, y in col
			tileX = currentLevel.boardX + currentLevel.tileWidthDest * x
			tileY = currentLevel.boardY + currentLevel.tileHeightDest * y
			if movingRow is y
				if shiftX < 0
					tileX += shiftX % currentLevel.boardWidth
				else
					tileX += -(-shiftX % currentLevel.boardWidth)
				if tileX + currentLevel.tileWidthOrigin - currentLevel.boardX > currentLevel.boardWidth
					drawTile ctx, tile, tileX - currentLevel.boardWidth, tileY
				else if tileX < currentLevel.boardX
					drawTile ctx, tile, tileX + currentLevel.boardWidth, tileY
				drawTile ctx, tile, tileX, tileY
			else if movingCol is x
				if shiftY < 0
					tileY += shiftY % currentLevel.boardHeight
				else
					tileY += -(-shiftY % currentLevel.boardHeight)
				if tileY + currentLevel.tileHeightOrigin - currentLevel.boardY > currentLevel.boardHeight
					drawTile ctx, tile, tileX, tileY - currentLevel.boardHeight
				else if tileY < currentLevel.boardY
					drawTile ctx, tile, tileX, tileY + currentLevel.boardHeight
				drawTile ctx, tile, tileX, tileY
			else if redrawAll
				drawTile ctx, tile, tileX, tileY
	ctx.restore()

move = (x, y) ->
	return  if isLocked or not startX?
	y -= currentLevel.boardY
	x -= currentLevel.boardX
	horizontality = Math.abs(x - startX) - Math.abs(y - startY)
	return  if horizontality is 0
	if horizontality > 0
		shiftY = 0
		repaint true  if movingCol?
		movingCol = null
		movingRow = Math.floor startY / currentLevel.tileHeightDest
		shiftX = x - startX
	else
		shiftX = 0
		repaint true  if movingRow?
		movingRow = null
		movingCol = Math.floor startX / currentLevel.tileWidthDest
		shiftY = y - startY
	repaint()

initdir = (x, y) ->
	return  if isLocked
	y -= currentLevel.boardY
	x -= currentLevel.boardX
	return unless y > 0 and y < currentLevel.boardHeight and x > 0 and x < currentLevel.boardWidth
	startX = x
	startY = y

reset = -> movingCol = movingRow = startX = startY = shiftX = shiftY = isLocked = null

animDone = (publishMoved) ->
	reset()
	repaint true
	phang.pubsub.publish "moved"  if publishMoved
	if level.isComplete()
		phang.pubsub.publish "levelComplete"
		lock true
		phang.globals.frontCtx.drawImage checkmarkImg, currentLevel.boardX + 20, currentLevel.boardY + 20
		pauseDuration = if data.isHighscore() then startPauseLength * 2 else startPauseLength
		phang.ui.repeat pauseDuration, null, ->
			data.gotoNextLevel()
			phang.pubsub.publish "initLevel"
	else
		phang.persist.snapshot level.tiles()

moveX = (goal, increment, publishMoved = true) ->
	pos = shiftX / currentLevel.tileWidthDest
	if Math.abs(pos - goal) <= increment
		level.move.x goal, movingRow
		data.addToPath(["x", goal, movingRow])  if publishMoved and goal
		animDone publishMoved
		return true
	else if pos > goal
		shiftX = Math.round (pos - increment) * currentLevel.tileWidthDest
	else
		shiftX = Math.round (pos + increment) * currentLevel.tileWidthDest
	false

moveY = (goal, increment, publishMoved = true) ->
	pos = shiftY / currentLevel.tileHeightDest
	if Math.abs(pos - goal) <= increment
		level.move.y goal, movingCol
		data.addToPath(["y", goal, movingCol])  if publishMoved and goal
		animDone publishMoved
		return true
	else if pos > goal
		shiftY = Math.round (pos - increment) * currentLevel.tileHeightDest
	else
		shiftY = Math.round (pos + increment) * currentLevel.tileHeightDest
	false


release = ->
	return  if isLocked
	if shiftX or shiftY
		lock true
		phang.pubsub.subscribe "repaint", releaseStep
	else
		reset()

releaseStep = ->
	if shiftX
		moveX Math.round(shiftX / currentLevel.tileWidthDest), defaultIncrement
	else if shiftY
		moveY Math.round(shiftY / currentLevel.tileHeightDest), defaultIncrement
	else
		lock(false)  unless level.isComplete()
		return phang.pubsub.unsubscribe "repaint", releaseStep
	repaint()

readyToPlay = ->
	reset()
	repaint true
	lock !!data.currentLevel().showTutorial
	phang.pubsub.publish "readyToPlay"

levelReady = ->
	phang.ui.clearAll()
	currentLevel = data.currentLevel()
	initTileCanvases()
	displayBackground()
	drawBorders()
	startPauseCounter = 0
	if data.hasSnapshot()
		lock true
		level.tiles phang.persist.snapshot()
		readyToPlay()
	else
		repaint true
		data.resetLevelData()
		if currentLevel.initMoves
			initMoves = currentLevel.initMoves.slice 0
			lock !!currentLevel.showTutorial
			phang.ui.repeat startPauseLength, repaint, ->
				phang.pubsub.subscribe "repaint", makeNextInitialMove
		else
			lock true
			phang.ui.repeat startPauseLength, repaint, ->
				phang.ui.repeat 10, displayCurtain, ->
					level.randomize()
					readyToPlay()

initTileCanvases = ->
	x = currentLevel.width
	tileCanvases = []
	while x--
		y = currentLevel.height
		tileCanvases[x] = []
		while y--
			canvas = document.createElement "canvas"
			canvas.width = currentLevel.tileWidthDest
			canvas.height = currentLevel.tileHeightDest
			ctx = canvas.getContext "2d"
			ctx.drawImage(
				currentLevel.image
				x * currentLevel.tileWidthOrigin
				y * currentLevel.tileHeightOrigin
				currentLevel.tileWidthOrigin - 2
				currentLevel.tileHeightOrigin - 2
				0
				0
				currentLevel.tileWidthDest
				currentLevel.tileHeightDest)
			tileCanvases[x][y] = canvas
	null

displayCurtain = ->
	ctx = phang.globals.mainCtx
	ctx.save()
	ctx.fillStyle = currentLevel.backgroundColor
	ctx.fillRect currentLevel.boardX, currentLevel.boardY, currentLevel.boardWidth, currentLevel.boardHeight
	ctx.restore()
	null

displayBackground = ->
	ctx = phang.globals.backCtx
	ctx.fillStyle = currentLevel.backgroundColor
	ctx.fillRect 0, 0, phang.globals.width, phang.globals.height
	null

makeMove = (move, speed = backSpeed) ->
	_makeMove = -> makeNextMove speed, _makeMove, reset
	initMoves = [move]
	phang.pubsub.subscribe "repaint", _makeMove
makeNextInitialMove = -> makeNextMove currentLevel.initSpeed, makeNextInitialMove, readyToPlay
makeNextMove = (speed = defaultIncrement, fct, callback) ->
	if currentInitMove
		if currentInitMove[0] is "x"
			movingRow = currentInitMove[2]
			moveDone = moveX currentInitMove[1], speed, false
		else if currentInitMove[0] is "y"
			movingCol = currentInitMove[2]
			moveDone = moveY currentInitMove[1], speed, false
		repaint()
	if moveDone or not currentInitMove
		currentInitMove = initMoves.shift()
		if currentInitMove
			shiftX = shiftY = 0
			lock true
		else
			callback?()
			phang.pubsub.unsubscribe "repaint", fct
refresh = ->
	displayBackground()
	repaint true
lock = (locked = true) -> isLocked = locked

phang.pubsub.subscribe "touch", initdir
phang.pubsub.subscribe "won", lock
phang.pubsub.subscribe "touchmove", move
phang.pubsub.subscribe "touchend", release
phang.pubsub.subscribe "levelReady", levelReady, 200
phang.pubsub.subscribe "makeMove", makeMove
phang.pubsub.subscribe "testMove", refresh, 100
phang.pubsub.subscribe "testMoves", refresh, 100
