"use strict"

phang = require "phang"
level = require "../level.coffee"
data = require "../data.coffee"
CountButton = require "./countButton.coffee"

hasReachedFullSize = button = previewCanvas = isDrawingCross = null
stepCount = 7
currentStep = 0
direction = 1

previewTouched = (x, y) ->
	return  unless button and isInsideButton x, y
	if level.previewLeft() isnt 0
		currentStep = 1
		direction = 1
		hasReachedFullSize = false
		phang.pubsub.subscribe "repaint", repaint
	else
		return  if isDrawingCross
		isDrawingCross = true
		drawCross()
		phang.ui.repeat 5, null, ->
			displayButton()
			phang.ui.repeat 5, null, ->
				drawCross()
				phang.ui.repeat 5, null, ->
					isDrawingCross = false
					displayButton()

repaint = ->
	phang.ui.clear phang.globals.previewCtx
	button.displayButton()
	button.displayCount level.previewLeft()
	unless currentStep is 0
		displayPreview()
	if currentStep is stepCount or currentStep is 0
		phang.pubsub.unsubscribe "repaint", repaint
	else
		currentStep += direction
	hasReachedFullSize = true if currentStep is stepCount
	displayButton()  if currentStep is 0

drawCross = ->
	ctx = phang.globals.previewCtx
	ctx.save()
	ctx.strokeStyle = "#ff0000"
	ctx.lineWidth = 10
	ctx.beginPath()
	ctx.moveTo button.x + 10, button.y + 10
	ctx.lineTo button.x + button.width - 10, button.y + button.height - 10
	ctx.moveTo button.x + 10, button.y + button.height - 10
	ctx.lineTo button.x + button.width - 10, button.y + 10
	ctx.stroke()
	ctx.restore()

displayPreview = ->
	ctx = phang.globals.previewCtx
	ctx.save()
	cl = data.currentLevel()
	previewRatio = button.width / cl.boardWidth
	ratio = previewRatio + (1 - previewRatio) * (currentStep / stepCount)
	yStart = button.y + button.height
	ctx.translate button.x + (cl.boardX - button.x) * ratio, yStart + (cl.boardY - yStart) * ratio
	ctx.scale ratio, ratio
	ctx.drawImage previewCanvas, 0, 0
	ctx.restore()

hidePreview = (x, y) ->
	if hasReachedFullSize
		phang.persist.previewCount phang.persist.previewCount() + 1
	unless currentStep is 0
		currentStep = Math.min stepCount - 1, currentStep
		direction = -1
		phang.pubsub.subscribe "repaint", repaint

isInsideButton = (x, y) -> x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height

displayButton = ->
	cl = data.currentLevel()
	img = cl.image
	ctx = phang.globals.previewCtx
	phang.ui.clear ctx
	button.displayButton()
	button.displayCount level.previewLeft()

init = ->
	cl = data.currentLevel()
	if cl?.image
		button = new CountButton cl.image, phang.globals.previewCtx
		createPreviewCanvas()
		displayButton()
	else
		button = null

createPreviewCanvas = ->
	cl = data.currentLevel()
	previewCanvas = document.createElement "canvas"
	previewCanvas.width = cl.boardWidth
	previewCanvas.height = cl.boardHeight
	ctx = previewCanvas.getContext "2d"
	ctx.drawImage(
		cl.image
		0
		0
		cl.image.width
		cl.image.height
		0
		0
		cl.boardWidth
		cl.boardHeight)

phang.pubsub.subscribe "touch", previewTouched
phang.pubsub.subscribe "touchend", hidePreview
phang.pubsub.subscribe "readyToPlay", init
