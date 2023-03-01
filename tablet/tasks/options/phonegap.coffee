module.exports = (appConfig) ->
	config:
		root: "#{appConfig.dist}"
		config: "#{appConfig.config}/config.xml"
		cordova: "phonegap/.cordova"
		path: "phonegap"
		plugins: ["./config/plist_update", "https://github.com/danwilson/google-analytics-plugin.git"]
		platforms: [
			"android"
			"ios"
		]
		maxBuffer: 200 # You may need to raise this for iOS.
		verbose: false
		releases: "releases"
		releaseName: -> appConfig.name + "-" + appConfig.version
		name: -> appConfig.name
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
				icon60: "assets/generated/icon-60.png"
				icon60x2: "assets/generated/icon-60x2.png"
				icon72: "assets/generated/icon-72.png"
				icon72x2: "assets/generated/icon-72x2.png"
				icon76: "assets/generated/icon-76.png"
				icon76x2: "assets/generated/icon-76x2.png"

		
		# Set a splash screen at various sizes (optional)
		# Only works for Android and IOS
		screens:
			android:
				ldpi: "assets/generated/splash-ldpi-landscape.png"
				mdpi: "assets/generated/splash-mdpi-landscape.png"
				hdpi: "assets/generated/splash-hdpi-landscape.png"
				xhdpi: "assets/generated/splash-xhdpi-landscape.png"

			ios:
				ipadLand: "assets/generated/splash-ipad-landscape.png"
				ipadLandx2: "assets/generated/splash-ipad-landscape-2x.png"

		
		# Android-only integer version to increase with each release.
		# See http://developer.android.com/tools/publishing/versioning.html
		versionCode: ->
			make2DigitsNumber = (i) ->
				if i and i.length
					(if (i.length is 1) then "0" + i else i)
				else
					"00"
			parseInt appConfig.version.split(".").map(make2DigitsNumber).join(""), 10

		
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