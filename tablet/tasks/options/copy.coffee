# Copies remaining files to places other tasks can use
module.exports = (appConfig) ->
	dist:
		files: [
			{
				expand: true
				dot: true
				cwd: "#{appConfig.app}"
				dest: "#{appConfig.dist}"
				src: [
					"*.{ico,png,txt}"
					"*.html"
					"views/{,*/}*.html"
					"images/{,*/}*.png"
					"styles/fonts/*.ttf"
				]
			}
		]

	android:
		expand: true
		cwd: 'config'
		dest: 'phonegap/platforms/android'
		src: [ 'ant.properties' ]
