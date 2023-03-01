"use strict"

pubsub = require "./pubsub.coffee"

data = {}

module.exports = {}

# Usage: call init with objects you want to persist
# example:
# phang = require "phang"
# phang.persist.init
#   level: 0
#
# goToNextLevel = ->
#   phang.persist.level phang.persist.level() + 1

set = (field) ->
	(x) ->
		if x?
			data[field] = x
			localStorage[field] = JSON.stringify x
		if data[field]?
			data[field]
		else if localStorage[field]
			data[field] = JSON.parse localStorage[field]

init = (useLocalStorage = true) ->
	(hash) ->
		for k, v of hash
			module.exports[k] = set k
			value = localStorage[k]  if useLocalStorage
			if !value
				value = v
			else
				try
					value = JSON.parse value
				catch
			module.exports[k] value

module.exports =
	init: init()
	reset: init(false)
