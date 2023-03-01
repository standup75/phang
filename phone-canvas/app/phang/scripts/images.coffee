"use strict"

pubsub = require "./pubsub.coffee"
globals = require "./globals.coffee"

sources = []
loadImg = null
isReadyToLoad = false
load = ->
	totalCount = count = sources.length
	testLoadingComplete = ->
		if count is 0
			module.exports.ready = true
			pubsub.publish "imagesLoaded"
	decreaseCount = ->
		count--
		testLoadingComplete()
	getProgressPercent = ->
		100 - Math.round (count * 100) / totalCount
	testLoadingComplete()
	if !loadImg or isReadyToLoad
		while src = sources.pop()
			image = new Image
			image.onload = ->
				decreaseCount()
				pubsub.publish "imagesLoadedProgress", getProgressPercent()
			image.onerror = ->
				decreaseCount()
			image.src = src
	else
		isReadyToLoad = true

pubsub.subscribe "init", load, 1000 # low priority to let modules to add images during their init handler

module.exports =
	setLoader: (src, ctxName = "mainCtx") ->
		isReadyToShowLoader = false
		src = "images/#{src}"
		loadImg = new Image
		loadImg.onload = ->
			displayLoader()
		loadImg.onerror = ->
			console.error "could not load loader image: #{src}"
			load()
		loadImg.src = src
		displayLoader = ->
			if isReadyToShowLoader
				if global.width / global.height < loadImg.width / loadImg.height
					height = Math.round loadImg.height * globals.width / loadImg.width
					y = Math.round (globals.height - height) / 2
					globals[ctxName].drawImage loadImg, 0, 0, loadImg.width, loadImg.height, 0, y, globals.width, height
				else
					width = Math.round loadImg.width * globals.height / loadImg.height
					x = Math.round (globals.width - width) / 2
					globals[ctxName].drawImage loadImg, 0, 0, loadImg.width, loadImg.height, x, 0, width, globals.height
				pubsub.unsubscribe "init", displayLoader
				load()
			else
				isReadyToShowLoader = true
		pubsub.subscribe "init", displayLoader, 10

	load: (src, callback) ->
		src = "images/#{src}"
		if callback
			img = new Image
			img.onload = -> callback img
			img.onerror = -> console.error "could not load loader image: #{src}"
			img.src = src
			img
		else
			if @ready
				console.error "can't add image without callback after init"
			else
				@ready = false
				sources.push src  unless sources.indexOf(src) > -1
				img = new Image
				img.src = src
				img
	ready: false
