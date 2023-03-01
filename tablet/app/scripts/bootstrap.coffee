"use strict"

if window.cordova
	deviceReadyEvent = "deviceready"
	specificPostInit = ->
		#window.analytics.startTrackerWithId('UA-57826208-1')
else
	deviceReadyEvent = "DOMContentLoaded"
	specificPostInit = ->

onDeviceReady = ->
	htmlEl = document.getElementsByTagName("html")[0]
	angular.bootstrap htmlEl, ["phangApp"]
	specificPostInit()
  
document.addEventListener deviceReadyEvent, onDeviceReady, false
