"use strict"

phang = require "phang"
data = require "../data.coffee"
level = require "../level.coffee"
config = require "../config.coffee"

size = 60
highscoreSize = 16
paddingTop = 25
paddingRight = 10
highscorePadding = 5
marginRatio = 0.3
width = null
ctx = null
showDashboard = not config.freeVersion
moveImg = phang.images.load "move.png"

displayDashboard = (highscoreRatio = 1) ->
	ctx = phang.globals.buttonCtx
	if width
		ctx.clearRect phang.globals.width - width - 100, 0, width + 100, 300
	if showDashboard
		width = paddingRight
		ctx.save()
		ctx.fillStyle = "#000"
		ctx.font = "#{size}px Helvetica"
		drawMoveCount()
		drawHighscore highscoreRatio
		ctx.restore()

drawMoveCount = ->
	count = phang.persist.currentPath().length
	width += Math.round size * (1 + marginRatio)
	height = Math.round size * moveImg.height / moveImg.width
	top = Math.round (size - height) / 2
	ctx.drawImage moveImg, 0, 0, moveImg.width, moveImg.height, phang.globals.width - width, paddingTop + top, size, height
	countSize = ctx.measureText count
	width += Math.round size * marginRatio + countSize.width
	ctx.fillText count, phang.globals.width - width, paddingTop + size * 0.9
	width += Math.round size * marginRatio

drawHighscore = (ratio) ->
	highscore = data.getHighscore()
	if highscore
		ctx.save()
		ctx.font = "#{highscoreSize * ratio}px Helvetica"
		highscoreWidth = ctx.measureText(highscore).width
		highscoreHeight = (2 * highscorePadding + highscoreSize) * ratio
		right = phang.globals.width - paddingRight + 5
		top = paddingTop - 5
		radius = highscoreHeight / 2
		ctx.fillStyle = "#555555"
		ctx.fillRect right - highscoreWidth - radius, top, highscoreWidth, highscoreHeight
		ctx.beginPath()
		ctx.arc right - radius, top + radius, radius, -Math.PI / 2, Math.PI / 2
		ctx.fill()
		ctx.beginPath()
		ctx.arc right - highscoreWidth - radius, top + radius, radius, Math.PI / 2, 3 * Math.PI / 2
		ctx.fill()
		ctx.fillStyle = "#ffffff"
		ctx.fillText highscore, right - highscoreWidth - radius, top + (highscorePadding - 2 + highscoreSize) * ratio

hide = ->
	showDashboard = false
	displayDashboard()
show = ->
	showDashboard = true
	displayDashboard()

checkHighscore = ->
	if data.isHighscore()
		data.setHighscore()
		newHighscoreAnimation.init()
		phang.ui.repeat 18, newHighscoreAnimation.animate

newHighscoreAnimation = do ->
	highscoreSizeMult = sign = null
	init: ->
		highscoreSizeMult = 1
		sign = 0.3
	animate: ->
		displayDashboard highscoreSizeMult
		highscoreSizeMult += sign
		if Math.round(highscoreSizeMult) is 4
			sign = -0.3

phang.pubsub.subscribe "pathUpdated", displayDashboard
phang.pubsub.subscribe "refresh", displayDashboard
phang.pubsub.subscribe "levelReady", displayDashboard, 300
phang.pubsub.subscribe "showBanner", hide
phang.pubsub.subscribe "hideBanner", show
phang.pubsub.subscribe "levelComplete", checkHighscore
