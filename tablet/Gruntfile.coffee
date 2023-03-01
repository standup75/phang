# Generated on 2014-08-06 using generator-angular 0.9.5
"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
	
	# Configurable paths for the application
	bowerConfig = require('./bower.json')
	appConfig =
		app: "app"
		dist: "dist"
		config: "config"
		version: bowerConfig.version
		name: bowerConfig.name

	# Load grunt tasks automatically
	require("load-grunt-tasks") grunt
	
	# Define the configuration for all the tasks
	grunt.initConfig
		watch: require("./tasks/options/watch") appConfig
		connect: require("./tasks/options/connect") appConfig
		clean: require("./tasks/options/clean") appConfig
		wiredep: require("./tasks/options/wiredep") appConfig
		coffee: require("./tasks/options/coffee") appConfig
		compass: require("./tasks/options/compass") appConfig
		filerev: require("./tasks/options/filerev") appConfig
		useminPrepare: require("./tasks/options/useminPrepare") appConfig
		usemin: require("./tasks/options/usemin") appConfig
		imagemin: require("./tasks/options/imagemin") appConfig
		copy: require("./tasks/options/copy") appConfig
		phonegap: require("./tasks/options/phonegap") appConfig
		responsive_images: require("./tasks/options/responsive_images") appConfig

		autoprefixer: require "./tasks/options/autoprefixer"
		karma: require "./tasks/options/karma"
		shell: require "./tasks/options/shell"
		uglify: require "./tasks/options/uglify"
		"string-replace": require "./tasks/options/string-replace"

	grunt.registerTask "serve", "Compile then start a connect web server", (target) ->
		if target is "dist"
			return grunt.task.run([
				"build"
				"connect:dist:keepalive"
			])
		grunt.task.run [
			"clean:server"
			"wiredep"
			"coffee:dist"
			"compass"
			"autoprefixer"
			"connect:livereload"
			"watch"
		]

	grunt.registerTask "server", "DEPRECATED TASK. Use the \"serve\" task instead", (target) ->
		grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
		grunt.task.run ["serve:" + target]

	grunt.registerTask "mobile", [
		"build"
		"responsive_images"
		"phonegap:build"
		"string-replace:ios"
		"copy:android"
		"shell:androidRelease"
		"shell:androidDebug"
		"shell:iosRelease"
	]

	grunt.registerTask "ios", [
		"build"
		"responsive_images"
		"phonegap:build"
		"string-replace:ios"
		"shell:iosRelease"
	]

	grunt.registerTask "build", [
		"clean:dist"
		"wiredep"
		"useminPrepare"
		"coffee"
		"compass"
		"imagemin"
		"autoprefixer"
		"concat"
		"copy:dist"
		"cssmin"
		"uglify"
		"filerev"
		"usemin"
	]
	grunt.registerTask "default", [
		"build"
	]
	return