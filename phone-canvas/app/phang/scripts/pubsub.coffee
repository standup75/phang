"use strict"

cache = {}
publish = (topic, ctx = {}) ->
	events = cache[topic]
	if events and events.length>0
		callbackCount = events.length
		while callbackCount--
			if events[callbackCount]
				events[callbackCount].callback.apply ctx, Array.prototype.slice.call(arguments, 1)
	null

# 0 is the highest priority
subscribe = (topic, callback, priority = 0) ->
	throw "priority must be >= 0"  if priority < 0 # optimize sorting only if there is a priority
	unsubscribe topic, callback
	if topic is "repaint"
		module.exports.needRepaint++
		if module.exports.needRepaint is 1
			setTimeout ->
				publish "run"
			, 0
	cache[topic] = [] unless cache[topic]
	cache[topic].push
		callback: callback
		priority: priority
	cache[topic].sort((a,b) -> b.priority - a.priority)  if priority
	[ topic, callback, priority ]
unsubscribe = (topic, callback) ->
	if cache[topic]
		callbackCount = cache[topic].length
		while callbackCount--
			if cache[topic][callbackCount].callback is callback
				module.exports.needRepaint--  if topic is "repaint"
				cache[topic].splice callbackCount, 1
				return true
	false
isSubscribed = (topic, callback) ->
	res = false
	if cache[topic]
		callbackCount = cache[topic].length
		while callbackCount--
			if cache[topic][callbackCount].callback is callback
				res = true
	res
reset = ->
	cache = {}

module.exports =
	publish: publish
	subscribe: subscribe
	unsubscribe: unsubscribe
	isSubscribed: isSubscribed
	needRepaint: 0
