# Watches files for changes and runs tasks based on the changed files
module.exports =
	images:
		files: ["app/<%= config.project %>}/images/*.*"]
		tasks: ["copy:images"]

	coffee:
		files: ["app/phang/scripts/{,*/}*.coffee", "app/conf.coffee", "app/<%= config.project %>/scripts/{,*/}*.coffee"]
		tasks: ["browserify:dist", "copy:images"]

	compass:
		files: ["app/styles/{,*/}*.{scss,sass}"]
		tasks: ["compass"]

	gruntfile:
		files: ["Gruntfile.coffee", "tasks/{,*}*.coffee"]

	livereload:
		options:
			livereload: 35730

		files: [
			"app/{,*/}*.html"
			".tmp/styles/{,*/}*.css"
			".tmp/scripts/{,*/}*.js"
			"app/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
		]
