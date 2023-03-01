"use strict"

angular.module("phangApp").factory "Analytics", ($window, $rootScope, $route) ->
	log = (methodName, args) ->
		argString = Array.prototype.slice.call(args).join("\", \"")
		console.log "--- analytics #{methodName}(\"#{argString}\")"

	Analytics = $window.analytics ||
		trackView: -> log "trackView", arguments
		trackEvent: -> log "trackEvent", arguments
		trackException: -> log "trackException", arguments
		trackTiming: -> log "trackTiming", arguments
		addTransaction: -> log "addTransaction", arguments
		addTransactionItem: -> log "addTransactionItem", arguments
		addCustomDimension: -> log "addCustomDimension", arguments

	$rootScope.$on "$routeChangeSuccess", -> Analytics.trackView $route.current.name

	Analytics