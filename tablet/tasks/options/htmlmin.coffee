module.exports = (appConfig) ->
	dist:
		options:
			collapseWhitespace: true
			conservativeCollapse: true
			collapseBooleanAttributes: true
			removeCommentsFromCDATA: true
			removeOptionalTags: true

		files: [
			expand: true
			cwd: "#{appConfig.dist}"
			src: [
				"*.html"
				"views/{,*/}*.html"
			]
			dest: "#{appConfig.dist}"
		]
