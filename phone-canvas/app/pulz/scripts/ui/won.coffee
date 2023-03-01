"use strict"

phang = require "phang"
Bubble = require "./bubbles.coffee"
data = require "../data.coffee"
config = require "../config.coffee"

trophyImg = phang.images.load "trophy.png"

bubble = null
margin = 100
fontSize = 10
intervalMs = 200
timer = null

getCoords = (w, h) ->
	destW = phang.globals.width - 2 * margin
	destH = phang.globals.height - 2 * margin
	if w / h > destW / destH
		x = 0
		width = destW
		height = h * destW / w
		y = (destH - height) / 2
	else
		y = 0
		height = destH
		width = w * destH / h
		x = (destW - width) / 2

	x: margin + x
	y: margin + y
	width: width
	height: height

reset = ->
	phang.ui.clearAll()
	phang.persist.currentLevel 0
	phang.pubsub.unsubscribe "repaint", showQuestion
	clearTimeout timer  if timer

restart = ->
	reset()
	location.reload()

won = ->
	data.resetLevelData()
	phang.ui.clearAll()
	if config.freeVersion
		finishedFree()
	else
		finishedAll()

finishedFree = ->
	loadPreviewRec()
	phang.pubsub.subscribe "repaint", showQuestion
	phang.pubsub.subscribe "touch", redirect

loadPreviewRec = (ext = "jpg", levelNumber) ->
	levelNumber ||= Math.floor(Math.random() * 48) + 51
	img = new Image
	img.onload = ->
		displayImage img
		timer = setTimeout ->
			loadPreviewRec()
		, intervalMs
	img.onerror = ->
		if ext is "jpg"
			loadPreviewRec "png", levelNumber
		else
			console.log "could not load thumb for level #{levelNumber}"
	img.src = "images/thumbs/level#{(levelNumber)}-thumb.#{ext}"

displayImage = (img) ->
	ctx = phang.globals.backCtx
	phang.ui.clear ctx
	ctx.drawImage(
		img
		0
		0
		img.width
		img.height
		(phang.globals.width - img.width) / 2
		(phang.globals.height - 600) / 2
		img.width
		img.height)

showQuestion = ->
	ctx = phang.globals.frontCtx
	phang.ui.clear ctx
	ctx.fillStyle = "#ffffff"
	ctx.font = "#{fontSize++}px Helvetica"
	text = "51 - 100 ?"
	width = ctx.measureText(text).width
	ctx.fillText text, (phang.globals.width - width) / 2, 300 + (phang.globals.height - fontSize) / 2
	if width > phang.globals.width - 150
		phang.pubsub.unsubscribe "repaint", showQuestion

redirect = ->
	reset()
	if window.cordova and navigator.connection?.type is Connection.NONE
		location.reload()
	else if phang.utils.device.isIOS()
		location.href = config.fullVersionUrls.apple
	else if phang.utils.device.isAndroid()
		location.href = config.fullVersionUrls.google
	else
		location.href = "http://getPulz.com"

finishedAll = ->
	bubble = new Bubble phang.globals.mainCtx
	coords = getCoords trophyImg.width, trophyImg.height
	phang.globals.frontCtx.drawImage trophyImg, 0, 0, trophyImg.width, trophyImg.height, coords.x, coords.y, coords.width, coords.height
	phang.pubsub.subscribe "touch", restart

phang.pubsub.subscribe "won", won
