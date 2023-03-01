module.exports =
	androidDebuggable:
		files:
			"./": "phonegap/platforms/android/src/**/MainActivity.java"
		options:
			replacements:[
				pattern: /loadUrl\(launchUrl\);/
				replacement: """loadUrl(launchUrl);
        \t\t\t\tif(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
        \t\t\t\t\tandroid.webkit.WebView.setWebContentsDebuggingEnabled(true);
        \t\t\t\t}
        \t\t\t\tsetRequestedOrientation(android.content.pm.ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);"""
			]
	androidNoPermission:
		files:
			"./": "phonegap/platforms/android/AndroidManifest.xml"
		options:
			replacements:[
				pattern: /\n\s*\t*<uses-permission .*\/>/g
				replacement: ""
			]
	pulz_free:
		files:
			"./": "app/pulz/scripts/config.coffee"
		options:
			replacements:[
				pattern: /freeVersion: false/
				replacement: "freeVersion: true"
			]
	pulz_full:
		files:
			"./": "app/pulz/scripts/config.coffee"
		options:
			replacements:[
				pattern: /freeVersion: true/
				replacement: "freeVersion: false"
			]
