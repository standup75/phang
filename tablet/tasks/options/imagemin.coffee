module.exports = (appConfig) ->
	dist:
		files: [
			expand: true
			cwd: "#{appConfig.app}/images"
			src: "{,*/}*.{png,jpg,jpeg,gif}"
			dest: "#{appConfig.dist}/images"
		]
