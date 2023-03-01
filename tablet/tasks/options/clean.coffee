# Empties folders to start fresh
module.exports = (appConfig) ->
	dist:
		files: [
			dot: true
			src: [
				".tmp"
				"build"
				appConfig.dist
				"phonegap"
				"assets/generated"
			]
		]

	server: ".tmp"
