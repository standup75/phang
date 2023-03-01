module.exports = (appConfig) ->
	logo:
		options:
			sizes: [
				{
					name: "36-ldpi"
					width: 36
				}
				{
					name: "48-mdpi"
					width: 48
				}
				{
					name: "72-hdpi"
					width: 72
				}
				{
					name: "96-xhdpi"
					width: 96
				}
				{
					name: "62-tile"
					width: 62
				}
				{
					name: "173-tile"
					width: 173
				}
				{
					name: "29"
					width: 29
				}
				{
					name: "29x2"
					width: 58
				}
				{
					name: "40"
					width: 40
				}
				{
					name: "40x2"
					width: 80
				}
				{
					name: "57"
					width: 57
				}
				{
					name: "57x2"
					width: 114
				}
				{
					name: "60"
					width: 60
				}
				{
					name: "60x2"
					width: 120
				}
				{
					name: "72"
					width: 72
				}
				{
					name: "72x2"
					width: 144
				}
				{
					name: "76"
					width: 76
				}
				{
					name: "76x2"
					width: 152
				}
			]

		files: [
			expand: true
			src: ["icon.png"]
			cwd: "assets"
			dest: "assets/generated"
		]

	splash:
		options:
			sizes: [
				{
					name: "ldpi-landscape"
					aspectRatio: false
					width: 320
					height: 200
				}
				{
					name: "mdpi-landscape"
					aspectRatio: false
					width: 480
					height: 320
				}
				{
					name: "hdpi-landscape"
					aspectRatio: false
					width: 800
					height: 480
				}
				{
					name: "xhdpi-landscape"
					aspectRatio: false
					width: 1280
					height: 720
				}
				{
					name: "ipad-landscape"
					aspectRatio: false
					width: 1024
					height: 758
				}
				{
					name: "ipad-landscape-2x"
					aspectRatio: false
					width: 2048
					height: 1536
				}
			]

		files: [
			expand: true
			src: ["splash.png"]
			cwd: "assets"
			dest: "assets/generated"
		]