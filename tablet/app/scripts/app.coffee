"use strict"

###*
 # @ngdoc overview
 # @name phangApp
 # @description
 # Main module of the Phang app for tablets.
###


app = angular.module "phangApp", ["ngRoute", "ngAnimate", "ngTouch"]

app.config ($routeProvider) ->
	$routeProvider.when("/",
		templateUrl: "views/home.html"
		controller: "HomeCtrl"
		name: "Home"
	).when("/test",
		templateUrl: "views/test.html"
		name: "Test"
	).otherwise redirectTo: "/"
