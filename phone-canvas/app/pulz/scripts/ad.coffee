"use strict"

phang = require "phang"
data = require "./data.coffee"
config = require "./config.coffee"

hideBannerAfterSec = 25
timer = AdMob = null

hideBanner = ->
	AdMob.hideBanner()
	phang.pubsub.publish "hideBanner"
	clearTimeout timer

showBanner = ->
	AdMob.showBanner()
	phang.pubsub.publish "showBanner"
	timer = setTimeout ->
		hideBanner()
	, hideBannerAfterSec * 1000

module.exports =
	init: ->
		AdMob = window.AdMob
		if AdMob
			# select the right Ad Id according to platform
			if /(android)/i.test(navigator.userAgent)
				# for android
				admobid =
					banner: 'ca-app-pub-9870567586947498/5467590369'
			else if /(ipod|iphone|ipad)/i.test(navigator.userAgent)
				# for ios
				admobid =
					banner: 'ca-app-pub-9870567586947498/3990857165'
		else
			console.error "AdMob not found"
		if admobid and AdMob?
			AdMob.createBanner
				adId: admobid.banner
				position: AdMob.AD_POSITION.TOP_CENTER
				autoShow: false
				overlap: true
			phang.pubsub.subscribe "levelReady", showBanner
			phang.pubsub.subscribe "levelComplete", hideBanner
		else
			console.error "Not iphone nor android, can't display ads, no money ); );"