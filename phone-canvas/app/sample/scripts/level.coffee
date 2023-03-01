"use strict"

phang = require "phang"
data = require "./data.coffee"

img = phang.images.load "fangs.png"
x = 0
y = 0
dirX = 10
dirY = 10
currentText = "Touch to see motion details"
phang.persist.init
	level: 0

init = ->
	ctx = phang.globals.backCtx
	ctx.fillStyle = data.levels[phang.persist.level()].background
	ctx.fillRect 0, 0, phang.globals.width, phang.globals.height

repaint = ->
	phang.ui.clear()
	ctx = phang.globals.mainCtx
	ctx.drawImage img, x, y
	if x + dirX < 0 or x + dirX + img.width > phang.globals.width
		dirX = -dirX
	if y + dirY < 0 or y + dirY + img.height > phang.globals.height
		dirY = -dirY
	x += dirX
	y += dirY
	ctx.font = "20px Helvetica"
	ctx.fillStyle = "#000000"
	ctx.fillText currentText, 10, 60

phang.pubsub.subscribe "repaint", repaint
phang.pubsub.subscribe "init", init, 10 # lower priority to make sure globals have been set

# you can copy the following into your project to test the touch reactivity

initPos = null
testTouch = (x, y) ->
	x = Math.round x
	y = Math.round y
	initPos = {x:x, y:y}
	currentText = "x: #{x}, y: #{y}"
	console.log currentText
testTouchmove = (x, y) ->
	x = Math.round x
	y = Math.round y
	currentText = "x: #{x}, y: #{y}, dx:#{x-initPos.x}, dy:#{y-initPos.y}"
	console.log currentText
testTouchend = (x, y) ->
	x = Math.round x
	y = Math.round y
	currentText = "start = {x: #{initPos.x}, y: #{initPos.y}}, dx:#{x-initPos.x}, dy:#{y-initPos.y}, end = {x: #{x}, y: #{y}}"
	console.log currentText

phang.pubsub.subscribe "touch", testTouch
phang.pubsub.subscribe "touchmove", testTouchmove
phang.pubsub.subscribe "touchend", testTouchend
