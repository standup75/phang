# Watches files for changes and runs tasks based on the changed files
module.exports = (appConfig) ->
	bower:
		files: ["bower.json"]
		tasks: ["wiredep"]

	coffee:
		files: ["#{appConfig.app}/scripts/{,*/}*.{coffee,litcoffee,coffee.md}"]
		tasks: ["newer:coffee:dist"]

	coffeeTest:
		files: ["test/spec/{,*/}*.{coffee,litcoffee,coffee.md}"]
		tasks: [
			"newer:coffee:test"
			"karma"
		]

	compass:
		files: ["#{appConfig.app}/styles/{,*/}*.{scss,sass}"]
		tasks: [
			"compass"
			"autoprefixer"
		]

	gruntfile:
		files: ["Gruntfile.coffee"]

	livereload:
		options:
			livereload: 35730

		files: [
			"#{appConfig.app}/{,*/}*.html"
			".tmp/styles/{,*/}*.css"
			".tmp/scripts/{,*/}*.js"
			"#{appConfig.app}/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
		]
