module.exports =
	ios:
		files:
			"./": "phonegap/platforms/ios/phang/phang-info.plist"
		options:
			replacements:[
				pattern: /<string>UIInterfaceOrientationPortrait<\/string>[^\w]*<string>UIInterfaceOrientationLandscapeLeft<\/string>[^\w]*<string>UIInterfaceOrientationPortraitUpsideDown<\/string>[^\w]*<string>UIInterfaceOrientationLandscapeRight<\/string>/
				replacement: "<string>UIInterfaceOrientationLandscapeLeft</string><string>UIInterfaceOrientationLandscapeRight</string>"
			]
