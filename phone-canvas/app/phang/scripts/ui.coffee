"use strict"

globals = require "./globals.coffee"
pubsub = require "./pubsub.coffee"
layers = require "./layers.coffee"

module.exports =
	clear: (ctx = globals.mainCtx) ->
		ctx.clearRect 0, 0, globals.width, globals.height
	clearAll: ->
		@clear(globals["#{id}Ctx"]) for id in layers.ids
	repeat: (totalCycleCount, callback, next) ->
		cycleCount = 0
		displayLoop = ->
			callback?()
			if cycleCount is totalCycleCount
				pubsub.unsubscribe "repaint", displayLoop
				next?()
			else
				cycleCount++
		pubsub.subscribe "repaint", displayLoop
