# Empties folders to start fresh
module.exports =
	dist:
		files: [
			dot: true
			src: [
				".tmp"
				".views"
				"dist"
				"phonegap"
				"assets"
				"build/<%= config.project %>.*"
			]
		]
	pulz:
		files: [
			dot: true
			src: [
				"app/pulz/images/thumbs/*"
			]
		]


	serve: ".tmp"
