"use strict"

pubsub = require "./pubsub.coffee"
ui = require "./ui.coffee"
utils = require "./utils.coffee"
conf = require "conf"

paused = false
initDone = false
lastTime = 0

# interop stuff
window.requestAnimFrame = do ->
	window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
		window.setTimeout callback, 1000 / conf.cycle

if window.cordova
	deviceReadyEvent = "deviceready"
	deviceSpecificInit = ->
		#window.analytics.startTrackerWithId('UA-57826208-1')
else
	deviceReadyEvent = "DOMContentLoaded"
	deviceSpecificInit = ->

onDeviceReady = ->
	deviceSpecificInit()
	init()
	
document.addEventListener deviceReadyEvent, onDeviceReady, false

do ->
	resizeTimer = null
	registerResize = ->
		window.addEventListener "resize", ->
			clearTimeout resizeTimer  is resizeTimer
			if initDone
				resizeTimer = setTimeout ->
					location.reload()
				, 200
	if window.cordova or not utils.device.isIOS
		registerResize()
	else
		# Ios might resize the window after loading, if you activated the appstore redirection banner
		setTimeout ->
			registerResize()
		, 4000



init = ->
	pubsub.publish "init"
	pubsub.subscribe "imagesLoaded", ->
		animLoop()
		initDone = true

animLoop = ->
	requestAnimFrame(animLoop) if !paused and pubsub.needRepaint
	newTime = new Date().getTime()
	timeElapsed = newTime - lastTime
	# more than 400 ms, maybe the window just lost focus, don't try to catch up!
	if timeElapsed > conf.cycle
		lastTime = newTime
		#console.log "repaint"
		pubsub.publish "repaint"

module.exports =
	pause: -> paused = true
	resume: ->
		paused = false
		animLoop() if initDone
	run: -> animLoop()  if pubsub.needRepaint and initDone and not paused

pubsub.subscribe "resume", module.exports.resume
pubsub.subscribe "run", module.exports.run
