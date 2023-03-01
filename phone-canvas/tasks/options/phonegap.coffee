module.exports = (data) ->
	projectConfig = require "../../app/#{data.name}/scripts/config.coffee"
	plugins = [
		"cordova-plugin-network-information"
		"cordova-plugin-google-analytics@0.7.1"
		"cordova-plugin-whitelist"
		"cordova-plugin-splashscreen"
	]
	plugins.push "com.google.cordova.admob"  if projectConfig.freeVersion
	config:
		root: "dist"
		config:
			template: "config/_config.xml"
			data: data
		cordova: "phonegap/.cordova"
		path: "phonegap"
		plugins: plugins
		platforms: [
			"android"
			"ios"
		]
		maxBuffer: 200 # You may need to raise this for iOS.
		verbose: false
		releases: "releases"
		releaseName: -> "#{data.name}-#{data.version}"
		name: -> data.name
		key:
			store: "release.keystore"
			alias: "release"
			aliasPassword: ->
				
				# Prompt, read an environment variable, or just embed as a string literal
				"pipoman"

			storePassword: ->
				
				# Prompt, read an environment variable, or just embed as a string literal
				"pipoman"

		
		# Set an app icon at various sizes (optional)
		icons:
			android:
				ldpi: "assets/generated/icon-36-ldpi.png"
				mdpi: "assets/generated/icon-48-mdpi.png"
				hdpi: "assets/generated/icon-72-hdpi.png"
				xhdpi: "assets/generated/icon-96-xhdpi.png"

			wp8:
				app: "assets/generated/icon-62-tile.png"
				tile: "assets/generated/icon-173-tile.png"

			ios:
				icon29: "assets/generated/icon-29.png"
				icon29x2: "assets/generated/icon-29x2.png"
				icon40: "assets/generated/icon-40.png"
				icon40x2: "assets/generated/icon-40x2.png"
				icon57: "assets/generated/icon-57.png"
				icon57x2: "assets/generated/icon-57x2.png"
				icon50: "assets/generated/icon-50.png"
				icon50x2: "assets/generated/icon-50x2.png"
				icon60: "assets/generated/icon-60.png"
				icon60x2: "assets/generated/icon-60x2.png"
				icon60x3: "assets/generated/icon-60x3.png"
				icon72: "assets/generated/icon-72.png"
				icon72x2: "assets/generated/icon-72x2.png"
				icon76: "assets/generated/icon-76.png"
				icon76x2: "assets/generated/icon-76x2.png"

		
		# Set a splash screen at various sizes (optional)
		# Only works for Android and IOS
		screens:
			android:
				ldpiLand: "assets/generated/splash-android-ldpi-portrait.9.png"
				mdpiLand: "assets/generated/splash-android-mdpi-portrait.9.png"
				hdpiLand: "assets/generated/splash-android-hdpi-portrait.9.png"
				xhdpiLand: "assets/generated/splash-android-xhdpi-portrait.9.png"
				xxhdpiLand: "assets/generated/splash-android-xxhdpi-portrait.9.png"
				ldpi: "assets/generated/splash-android-ldpi-portrait.9.png"
				mdpi: "assets/generated/splash-android-mdpi-portrait.9.png"
				hdpi: "assets/generated/splash-android-hdpi-portrait.9.png"
				xhdpi: "assets/generated/splash-android-xhdpi-portrait.9.png"
				xxhdpi: "assets/generated/splash-android-xxhdpi-portrait.9.png"

			ios:
				ipadLand: 'assets/generated/splash-ipad-landscape.png'
				ipadLandx2: 'assets/generated/splash-ipad-landscape-2x.png'
				ipadPortrait: 'assets/generated/splash-ipad-portrait.png'
				ipadPortraitx2: 'assets/generated/splash-ipad-portrait-2x.png'
				iphonePortrait: 'assets/generated/splash-iphone-portrait.png'
				iphonePortraitx2: 'assets/generated/splash-iphone-portrait-2x.png'
				iphone568hx2: 'assets/generated/splash-iphone-568h-2x.png'
				iphone667h: 'assets/generated/splash-iphone-667h-2x.png'
				iphone736h: 'assets/generated/splash-iphone-736h-3x.png'

		
		# Android-only integer version to increase with each release.
		# See http://developer.android.com/tools/publishing/versioning.html
		versionCode: =>
			make2DigitsNumber = (i) ->
				if i and i.length
					(if (i.length is 1) then "0" + i else i)
				else
					"00"
			parseInt data.version.split(".").map(make2DigitsNumber).join(""), 10

		
		# Android-only options that will override the defaults set by Phonegap in the
		# generated AndroidManifest.xml
		# See https://developer.android.com/guide/topics/manifest/uses-sdk-element.html
		minSdkVersion: ->
			10

		targetSdkVersion: ->
			14

		
		# iOS7-only options that will make the status bar white and transparent
		iosStatusBar: "WhiteAndTransparent"

	# If you want to use the Phonegap Build service to build one or more
	# of the platforms specified above, include these options.
	# See https://build.phonegap.com/
	#remote: {
	#	username: 'your_username',
	#	password: 'your_password',
	#	platforms: ['android', 'blackberry', 'ios', 'symbian', 'webos', 'wp7']
	#}