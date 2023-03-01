module.exports =
	pulz_thumbs:
		options: 
			sizes: [
				name: "thumb"
				aspectRatio: false
				quality: 60
				width: 324
				height: 324
			]
		files: [
			expand: true
			src: ["level*.png", "level*.jpg"]
			cwd: "app/pulz/images"
			dest: "app/pulz/images/thumbs"
		]
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
					name: "50"
					width: 50
				}
				{
					name: "50x2"
					width: 100
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
					name: "60x3"
					width: 180
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
			cwd: "app/<%= config.project %>/assets"
			dest: "assets/generated"
		]

	splash:
		options:
			sizes: [
				{
					name: "android-ldpi-portrait"
					aspectRatio: false
					width: 200
					height: 320
				}
				{
					name: "android-mdpi-portrait"
					aspectRatio: false
					width: 320
					height: 480
				}
				{
					name: "android-hdpi-portrait"
					aspectRatio: false
					width: 480
					height: 800
				}
				{
					name: "android-xhdpi-portrait"
					aspectRatio: false
					width: 720
					height: 1280
				}
				{
					name: "android-xxhdpi-portrait"
					aspectRatio: false
					width: 1440
					height: 2560
				}
				{
					name: 'ipad-portrait',
					aspectRatio: false,
					width: 758,
					height: 1024
				}
				{
					name: 'ipad-portrait-2x',
					aspectRatio: false,
					width: 1536,
					height: 2048
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
				{
					name: 'iphone-portrait',
					aspectRatio: false,
					width: 320,
					height: 480
				}
				{
					name: 'iphone-portrait-2x',
					aspectRatio: false,
					width: 640,
					height: 960
				}
				{
					name: 'iphone-568h-2x',
					aspectRatio: false,
					width: 640,
					height: 1136
				}
				{
					name: 'iphone-667h-2x',
					aspectRatio: false,
					width: 750,
					height: 1334
				}
				{
					name: 'iphone-736h-3x',
					aspectRatio: false,
					width: 1242,
					height: 2208
				}
			]

		files: [
			expand: true
			src: ["splash.png"]
			cwd: "app/<%= config.project %>/assets"
			dest: "assets/generated"
		]