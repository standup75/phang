"use strict"

conf = require "conf"
pubsub = require "./pubsub.coffee"
	
initDone = false

setInitDone = -> initDone = true

module.exports =
	setConfig: (keyOrObject, v) ->
		if initDone
			throw "setConfig needs to be called before the 'init' topic gets published"
		else
			if keyOrObject instanceof Object and not v
				for key, value of keyOrObject
					conf[key] = value
			else if not v or not keyOrObject
				throw "setConfig called without key or value"
			else
				conf[keyOrObject] = v
			conf
	device:
		isSafari: ->
			/Safari/i.test(navigator.userAgent) and !@isChrome()
		isChrome: ->
			/Chrome/i.test navigator.userAgent
		isIPad: ->
			/iPad/i.test navigator.userAgent
		isIPhone: ->
			/iPhone|iPod/i.test navigator.userAgent
		isIOS: ->
			@isIPhone() or @isIPad()
		isAndroid: ->
			/Android/i.test navigator.userAgent


pubsub.subscribe "init", setInitDone, 1000000