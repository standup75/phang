"use strict"

phang = require "phang"
data = require "../data.coffee"
appstorebadgeImg = phang.images.load "appstorebadge.png"
googleplaybadgeImg = phang.images.load "googleplaybadge.png"

appStoreButton = googlePlayButton = null

init = ->
	cl = data.currentLevel()

	if phang.utils.device.isIOS()
		appStoreButton =
			x: cl.boardX + Math.round(cl.boardWidth - appstorebadgeImg.width) / 2
			y: cl.boardY + cl.boardHeight + 30
			w: appstorebadgeImg.width
			h: appstorebadgeImg.height
	else if phang.utils.device.isAndroid()
		googlePlayButton =
			x: cl.boardX + Math.round(cl.boardWidth - appstorebadgeImg.width) / 2
			y: cl.boardY + cl.boardHeight + 30
			w: googleplaybadgeImg.width
			h: googleplaybadgeImg.height
	else
		appStoreButton =
			x: cl.boardX
			y: cl.boardY + cl.boardHeight + 30
			w: appstorebadgeImg.width
			h: appstorebadgeImg.height
		googlePlayButton =
			x: cl.boardX + cl.boardWidth - googleplaybadgeImg.width
			y: cl.boardY + cl.boardHeight + 30
			w: googleplaybadgeImg.width
			h: googleplaybadgeImg.height
	phang.globals.linksCtx.drawImage appstorebadgeImg, appStoreButton.x, appStoreButton.y  if appStoreButton
	phang.globals.linksCtx.drawImage googleplaybadgeImg, googlePlayButton.x, googlePlayButton.y  if googlePlayButton

isInside = (btn, x, y) ->
	return false  unless btn
	x >= btn.x and x <= btn.x + btn.w and y >= btn.y and y <= btn.y + btn.h

touch = (x, y) ->
	if isInside googlePlayButton, x, y
		location.href = "https://play.google.com/store/apps/details?id=net.standupweb.pulz.free"
	else if isInside appStoreButton, x, y
		location.href = "https://geo.itunes.apple.com/us/app/pulz-free/id1034015927?mt=8"

phang.pubsub.subscribe "levelReady", init, 300
phang.pubsub.subscribe "touch", touch, 300

