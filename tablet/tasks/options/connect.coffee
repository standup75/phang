module.exports = (appConfig) ->
	# The actual grunt server settings
	options:
		port: 9100
		
		# Change localhost to '0.0.0.0' to access the server from outside.
		hostname: "localhost"
		livereload: 35730

	livereload:
		options:
			open: true
			middleware: (connect) ->
				[
					(req, res, next) ->
						res.setHeader "Access-Control-Allow-Origin", "*"
						res.setHeader "Access-Control-Allow-Methods", "*"
						next()
					connect.static(".tmp")
					connect().use("/bower_components", connect.static("./bower_components"))
					connect.static(appConfig.app)
				]

	test:
		options:
			port: 9101
			middleware: (connect) ->
				[
					connect.static(".tmp")
					connect.static("test")
					connect().use("/bower_components", connect.static("./bower_components"))
					connect.static(appConfig.app)
				]

	dist:
		options:
			open: true
			base: "#{appConfig.dist}"
