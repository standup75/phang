"use strict"

pubsub = require "./pubsub.coffee"
globals = require "./globals.coffee"
ui = require "./ui.coffee"
animloop = require "./animloop.coffee"
conf = require "conf"

tapTime = ratio = null
keyboardRequested = false
keyIsPressed = false
doubleTapMs = 200
# just to make it easier to test in a browser that does not have touch or touch simulation
touch = (("ontouchstart" of window) or window.DocumentTouch and document instanceof DocumentTouch)
requestKeyboard = -> keyboardRequested = true
releaseKeyboard = -> keyboardRequested = false
isDoubleTap = ->
	newTapTime = new Date().getTime()
	doubleTap = tapTime && (newTapTime - tapTime < doubleTapMs)
	tapTime = newTapTime
	doubleTap
onTouch = (eventName) ->
	(e) ->
		stopEvent(e)
		touch = e.changedTouches[0]
		[x, y] = getCoords touch.pageX, touch.pageY
		idt = isDoubleTap()  if eventName is "touch"
		pubsub.publish(eventName, x, y, idt) unless keyboardRequested
onClick = (eventName) ->
	(e) ->
		e.stopPropagation()
		[x, y] = getCoords e.clientX, e.clientY
		pubsub.publish(eventName, x, y, isDoubleTap()) unless keyboardRequested
getCoords = (x, y) -> [ratio * x, ratio * y]
stopEvent = (e) ->
	e.preventDefault()
	e.stopPropagation()
keyUp = ->
	keyIsPressed = false
	pubsub.publish "keyup"
keyPressed = (e) ->
	if keyIsPressed is e.which
		stopEvent e
		return 
	keyIsPressed = e.which
	if keyboardRequested
		pubsub.publish("esc") if e.keyCode == 27
		return
	arrowKeyPressed = (x, y) ->
		stopEvent e
		pubsub.publish "turn", x, y
	switch e.keyCode
		when 38 then arrowKeyPressed 0, -1
		when 40 then arrowKeyPressed 0, 1
		when 39 then arrowKeyPressed 1, 0
		when 37 then arrowKeyPressed -1, 0
		when 27, 80
			stopEvent e
			animloop.togglePause()
		when 32, 13
			stopEvent e
			pubsub.publish "select"
		when 9
			stopEvent e
			pubsub.publish "tab"
init = ->
	ratio = conf.pixelDensity
	mainEl = document.getElementById "container"
	document.getElementsByTagName("html")[0].className += " touch" if touch
	if touch
		mainEl.addEventListener "touchstart", onTouch("touch")
		mainEl.addEventListener "touchmove", onTouch("touchmove")
		mainEl.addEventListener "touchend", onTouch("touchend")
	else
		mainEl.addEventListener "mousedown", onClick("touch")
		mainEl.addEventListener "mousemove", onClick("touchmove")
		mainEl.addEventListener "mouseup", onClick("touchend")
	window.addEventListener "keydown", keyPressed, false
	window.addEventListener "keyup", keyUp, false

pubsub.subscribe "init", init
pubsub.subscribe "requestKeyboard", requestKeyboard
pubsub.subscribe "releaseKeyboard", releaseKeyboard
