# Copies remaining files to places other tasks can use
module.exports =
	images:
		files: [{
			expand: true
			cwd: "app/<%= config.project %>"
			dest: ".tmp"
			src: "images/**/*.*"
		}, {
			expand: true
			cwd: "app/phang"
			dest: ".tmp"
			src: "images/*.*"
		}]
	views:
		files: [{
			expand: true
			cwd: "app"
			dest: ".views"
			src: "*.html"
		}, {
			expand: true
			cwd: "app/<%= config.project %>"
			dest: ".views"
			src: "**/*.html"
		}]
	dist:
		files: [{
			expand: true
			cwd: "app"
			dest: "dist"
			src: [
				"*.{ico,png,txt}"
				"scripts/**/*.js"
				"styles/fonts/*.ttf"
			]
		}, {
				expand: true
				cwd: ".tmp"
				src: "**/*.*"
				dest: "dist"
		}, {
			expand: true
			cwd: ".views"
			dest: "dist"
			src: "**/*.html"
		}]

	android:
		expand: true
		cwd: 'config'
		dest: 'phonegap/platforms/android'
		src: [ 'ant.properties' ]

	android_xxhdpi:
		files: [
			src: "assets/generated/splash-android-xxhdpi-landscape.9.png"
			dest: "cordova/platforms/android/res/drawable-land-xxhdpi/splash.9.png"
		,
			src: "assets/generated/splash_portrait-android-xxhdpi-portrait.9.png"
			dest: "cordova/platforms/android/res/drawable-port-xxhdpi/splash.9.png"
		]
