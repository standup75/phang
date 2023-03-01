"use strict"

pubsub = require "./pubsub.coffee"
conf = require "conf"
layers = require "./layers.coffee"

module.exports = {}

init = ->
	w = window.innerWidth * conf.pixelDensity
	h = window.innerHeight * conf.pixelDensity
	module.exports.width = w
	module.exports.height = h
	for id in layers.ids
		c = document.getElementById id
		c.width = w
		c.height = h
		c.style.width = "#{window.innerWidth}px"
		c.style.height = "#{window.innerHeight}px"
		module.exports["#{id}Canvas"] = c
		module.exports["#{id}Ctx"] = c.getContext "2d"

pubsub.subscribe "init", init