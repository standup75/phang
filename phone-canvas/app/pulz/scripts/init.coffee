phang = require "phang"
config = require "./config.coffee"
ad = require "./ad.coffee"

onDeviceReady = ->
	ad.init()  if config.freeVersion

phang.persist.reset
	currentLevel: 0
	lastAvailableLevel: 6

phang.persist.init
	snapshotLevel: 0
	previewCount: 0
	tapCount: 0
	snapshot: []
	currentPath: []
	highscores: []

phang.layers.init ["front", "preview", "hint", "border", "feedback", "main", "button", "back"]

if window.cordova
	deviceReadyEvent = "deviceready"
else
	deviceReadyEvent = "DOMContentLoaded"

phang.images.setLoader "load.png"
document.addEventListener deviceReadyEvent, onDeviceReady, false
