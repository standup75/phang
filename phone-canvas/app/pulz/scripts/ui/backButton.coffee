"use strict"

phang = require "phang"
data = require "../data.coffee"
config = require "../config.coffee"

showBackButton = not config.freeVersion
backImg = phang.images.load "moveback.png"

displayButton = (alpha = 1) ->
	ctx = phang.globals.buttonCtx
	ctx.clearRect 10, 10, 80, 80
	if data.hasCurrentPath() and showBackButton
		ctx.save()
		ctx.globalAlpha = alpha
		ctx.drawImage backImg, 0, 0, backImg.width, backImg.height, 30, 30, 60, 60
		ctx.restore()

isInside = (x, y) -> x >= 10 and y >= 10 and x <= 90 and y <= 90

moveBack = (x, y) ->
	if showBackButton and isInside(x, y) and data.hasCurrentPath()
		displayButton 0.5
		setTimeout displayButton, 200
		move = data.popPath()
		phang.pubsub.publish "makeMove", [move[0], -move[1], move[2]]

hide = ->
	showBackButton = false
	displayButton()
show = ->
	showBackButton = true
	displayButton()

phang.pubsub.subscribe "moved", displayButton
phang.pubsub.subscribe "showBanner", hide
phang.pubsub.subscribe "hideBanner", show
phang.pubsub.subscribe "touch", moveBack
phang.pubsub.subscribe "readyToPlay", displayButton