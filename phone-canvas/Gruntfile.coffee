"use strict"

module.exports = (grunt) ->
	
	# Configurable paths for the application
	npmConfig = require "./package.json"
	if grunt.option("project")
		projectName = grunt.option "project"
		projectFullName = projectName
	else
		projectNameParts = grunt.cli.tasks[0].split(":")
		projectName = projectNameParts[0]
		projectFullName = projectName
		projectFullName += ".#{projectNameParts[1]}" if projectNameParts[1] and projectNameParts[1] isnt "full"
	config =
		version: grunt.option("version") || npmConfig.version
		build: grunt.option("build")
		project: projectName
		package: grunt.option("package") || "net.standupweb.#{projectFullName}"


	# Load grunt tasks automatically
	require("load-grunt-tasks") grunt
	require('time-grunt') grunt
	grunt.loadTasks "tasks"
	# Define the configuration for all the tasks
	grunt.initConfig
		config: config
		phonegap: require("./tasks/options/phonegap")
			id: config.package
			name: config.project
			version: config.version
		watch: require "./tasks/options/watch"
		browserify: require "./tasks/options/browserify"
		connect: require "./tasks/options/connect"
		clean: require "./tasks/options/clean"
		compass: require "./tasks/options/compass"
		imagemin: require "./tasks/options/imagemin"
		copy: require "./tasks/options/copy"
		responsive_images: require "./tasks/options/responsive_images"
		shell: require "./tasks/options/shell"
		aws_s3: require "./tasks/options/aws_s3"
		"string-replace": require "./tasks/options/string-replace"

	# call grunt serve --project=sample
	grunt.registerTask "serve", "Compile then start a connect web server", [
		"clean:serve"
		"compass"
		"browserify:dist"
		"copy:images"
		"copy:views"
		"connect:livereload"
		"watch"
	]

	grunt.registerTask "mobile", [
		"build"
		"responsive_images:logo"
		"responsive_images:splash"
		"phonegap:build"
		"copy:android"
		"copy:android_xxhdpi"
		"string-replace:androidDebuggable"
	]

	grunt.registerTask "ios", [
		"mobile"
		"shell:iosRelease"
	]

	grunt.registerTask "android", [
		"mobile"
		"shell:androidRelease"
	]

	# call grunt build --project=sample
	grunt.registerTask "build", "Compile the project", [
		"clean:dist"
		"browserify:dist"
		"copy:images"
		"compass"
		"imagemin"
		"copy:views"
		"copy:dist"
	]

	grunt.registerTask "default", [
		"build"
	]

	grunt.registerTask "pulz", (target, quick, device) ->
		target ||= "full"
		tasks = []
		# tasks = [
		# 	"string-replace:pulz_#{target}"
		# 	"mobile"]
		# tasks.push "string-replace:androidNoPermission"  if target is "full"
		# tasks.push "shell:androidRelease" if not device or device is "android"
		# tasks.push "shell:iosRelease" if not device or device is "ios"
		# tasks.push "shell:rename_pulz_bin_#{target}"
		unless quick is "quick"
			tasks = [
				"clean:pulz"
				"generateEquivalentTiles:pulz"
				"responsive_images:pulz_thumbs"
				"copy:dist"].concat tasks
		grunt.task.run tasks

	grunt.registerTask "pulz_landing", [
		"generateEquivalentTiles:pulz_landing"
		"build"
		"aws_s3:pulz_landing"
	]

	return