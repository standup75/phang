# Automatically inject Bower components into the app
module.exports = (appConfig) ->
	options:
		cwd: "#{appConfig.app}"

	app:
		src: ["#{appConfig.app}/index.html"]
		ignorePath: /\.\.\//

	sass:
		src: ["#{appConfig.app}/styles/{,*/}*.{scss,sass}"]
		ignorePath: /(\.\.\/){1,2}bower_components\//
