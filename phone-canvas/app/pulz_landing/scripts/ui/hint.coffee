"use strict"

phang = require "phang"
ai = require "../ai.coffee"
data = require "../data.coffee"
config = require "../config.coffee"

arrowsImg = phang.images.load "arrows.png"
imgSize = ctx = null
isTouching = tileProperties = loopIndex = hintProperties = moves = hint = null
step = 15

reset = -> isTouching = tileProperties = loopIndex = hintProperties = moves = hint = null

init = ->
	ctx = phang.globals.hintCtx
	ctx.strokeStyle = config.hintColor
	ctx.lineWidth = 20
	imgSize = arrowsImg.height

activate = ->
	reset()
	l = data.currentLevel()
	if l.showHint
		tileProperties =
			width: l.tileWidthDest
			height: l.tileHeightDest
			originX: l.boardX
			originY: l.boardY
			arrowX: Math.round l.boardX + (l.tileWidthDest - imgSize) / 2
			arrowY: Math.round l.boardY + (l.tileHeightDest - imgSize) / 2
		phang.pubsub.subscribe "pathUpdated", updateHint
		phang.pubsub.subscribe "moved", showHint
		phang.pubsub.subscribe "touchmove", touchMove
		phang.pubsub.subscribe "touch", setTouch
		phang.pubsub.subscribe "touchend", unsetTouch
		updateHint()
		showHint()

deactivate = ->
	l = data.currentLevel()
	if l.showHint
		phang.pubsub.unsubscribe "pathUpdated", updateHint
		phang.pubsub.unsubscribe "moved", showHint
		phang.pubsub.unsubscribe "touchmove", touchMove
		phang.pubsub.unsubscribe "touch", setTouch
		phang.pubsub.unsubscribe "touchend", unsetTouch
		hideHint()

setTouch = -> isTouching = true
unsetTouch = -> isTouching = false
touchMove = -> hideHint()  if isTouching

showHint = ->
	loopIndex = 0
	phang.pubsub.subscribe "repaint", repaint

updateHint = ->
	history = phang.persist.currentPath()
	if moves?.length and history.length and isSameMove history[history.length - 1], moves[0]
		moves.shift()
	else
		moves = ai.buildSolution()
	if moves.length
		l = data.currentLevel()
		hint = moves[0]
		#console.log hint
		hintProperties =
			imgX: do ->
				sign = hint[1] / Math.abs hint[1]
				imgX = 0
				imgX += imgSize  if hint[0] is "y"
				imgX += 2 * imgSize  if sign > 0
				imgX
			tiles: do ->
				res = []
				colrow = hint[2]
				if hint[0] is "x"
					w = l.width
					while w--
						res.push [w, colrow]
				else
					h = l.height
					while h--
						res.push [colrow, h]
				res
		showHint()

isSameMove = (m1, m2) ->
	val = (moveDir) -> if moveDir is "x" then "x" else "y"
	val(m1[0]) is val(m2[0]) and m1[1] is m2[1] and m1[2] is m2[2]

hideHint = ->
	phang.ui.clear ctx
	phang.pubsub.unsubscribe "repaint", repaint

repaint = ->
	l = data.currentLevel()
	phang.ui.clear ctx
	phase = Math.round loopIndex / step
	margin = config.tileBorderMargin - 4
	for tile in hintProperties.tiles
		x = tile[0] * tileProperties.width
		y = tile[1] * tileProperties.height
		if phase < 2 * Math.abs hint[1]
			ctx.strokeRect(
				x + margin + tileProperties.originX
				y + margin + tileProperties.originY
				tileProperties.width - 2 * margin
				tileProperties.height - 2 * margin)
			if phase / 2 isnt Math.floor(phase / 2)
				ctx.drawImage(
					arrowsImg
					hintProperties.imgX
					0
					imgSize
					imgSize
					x + tileProperties.arrowX
					y + tileProperties.arrowY
					imgSize
					imgSize)
	loopIndex++
	loopIndex = 0  if loopIndex is (2 + 2 * Math.abs hint[1]) * step

phang.pubsub.subscribe "imagesLoaded", init
phang.pubsub.subscribe "readyToPlay", activate, 300
phang.pubsub.subscribe "levelComplete", deactivate, 300
