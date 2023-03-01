"use strict"

pubsub = require "./pubsub.coffee"

isInit = false

module.exports =
	init: (canvasIds) ->
		if isInit
			throw "Can't init layers this late. Layers.init needs to be called earlier"
		else
			@ids = canvasIds
			html = ""
			html = "<canvas id='#{canvasId}'></canvas>" + html for canvasId in canvasIds
			document.getElementById("container").innerHTML = html

pubsub.subscribe "init", -> isInit = true
