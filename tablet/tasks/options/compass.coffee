# Compiles Sass to CSS and generates necessary files if requested
module.exports = (appConfig) ->
	dist:
		options:
			sassDir: "#{appConfig.app}/styles"
			cssDir: ".tmp/styles"
			imagesDir: "#{appConfig.app}/images"
			javascriptsDir: "#{appConfig.app}/scripts"
			fontsDir: "#{appConfig.app}/styles/fonts"
			importPath: "./bower_components"
			httpImagesPath: "images/"
			relativeAssets: false
			generatedImagesDir: "#{appConfig.app}/images/"
			generatedImagesPath: "#{appConfig.app}/images/"
			httpGeneratedImagesPath: "../images"
