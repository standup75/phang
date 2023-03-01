# Performs rewrites based on filerev and the useminPrepare configuration
module.exports = (appConfig) ->
	html: ["#{appConfig.dist}/{,*/}*.html"]
	css: ["#{appConfig.dist}/styles/{,*/}*.css"]
	options:
		assetsDirs: [
			appConfig.dist
			"#{appConfig.dist}/images"
		]
