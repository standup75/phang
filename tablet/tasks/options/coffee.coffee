# Compiles CoffeeScript to JavaScript
module.exports = (appConfig) ->
	options:
		sourceMap: false
		sourceRoot: ""

	dist:
		files: [
			expand: true
			cwd: "#{appConfig.app}/scripts"
			src: "{,*/}*.coffee"
			dest: ".tmp/scripts"
			ext: ".js"
		]

	test:
		files: [
			expand: true
			cwd: "test/spec"
			src: "{,*/}*.coffee"
			dest: ".tmp/spec"
			ext: ".js"
		]
