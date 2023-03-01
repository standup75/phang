"use strict"

phang = require "phang"
config = require "./config.coffee"

phang.persist.reset
	currentLevel: 0
	lastAvailableLevel: 0
	snapshotLevel: 0
	previewCount: 0
	tapCount: 0
	snapshot: []
	currentPath: []
	highscores: []

phang.layers.init ["front", "links", "hint", "border", "main", "back"]

phang.images.setLoader "load.png"
phang.utils.setConfig "pixelDensity", 1