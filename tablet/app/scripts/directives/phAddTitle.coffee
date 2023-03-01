"use strict"

angular.module("phangApp").directive "phAddTitle", ($route, Helpers) ->
	(scope, element, attributes) ->
		baseName = element.html()
		scope.$on "$routeChangeSuccess", (scope, next, current) ->
			return unless $route.current?.name
			targetAttribute = attributes.llAddTitle
			pageName = $route.current.name
			if targetAttribute
				element.attr targetAttribute, "#{Helpers.sanitize(pageName)}-page"
			else
				element.html baseName + pageName