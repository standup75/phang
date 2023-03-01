# Renames files for browser caching purposes
module.exports = (appConfig) ->
	dist:
		src: [
			"#{appConfig.dist}/scripts/{,*/}*.js"
			"#{appConfig.dist}/styles/{,*/}*.css"
		]
