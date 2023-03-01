"use strict"

pubsub = require "./pubsub.coffee"
ui = require "./ui.coffee"
images = require "./images.coffee"
persist = require "./persist.coffee"
globals = require "./globals.coffee"
control = require "./control.coffee"
animloop = require "./animloop.coffee"
layers = require "./layers.coffee"
utils = require "./utils.coffee"
	
module.exports =
	togglePause: ->
		if paused
			animloop.resume()
		else
			animloop.pause()
	pause: animloop.pause
	resume: animloop.resume
	pubsub: pubsub
	images: images
	persist: persist
	globals: globals
	ui: ui
	layers: layers
	utils: utils
