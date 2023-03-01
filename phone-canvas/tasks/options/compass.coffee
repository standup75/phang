# Compiles Sass to CSS and generates necessary files if requested
module.exports =
	dist:
		options:
			sassDir: "app/styles"
			cssDir: ".tmp/styles"
			imagesDir: "app/images"
			javascriptsDir: "app/scripts"
			fontsDir: "app/styles/fonts"
			httpImagesPath: "images/"
			relativeAssets: false
			generatedImagesDir: "app/images/"
			generatedImagesPath: "app/images/"
			httpGeneratedImagesPath: "../images"
