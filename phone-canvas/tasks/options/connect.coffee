module.exports =
	# The actual grunt server settings
	options:
		port: 9100
		base: [".views", ".tmp"]
		# Change localhost to '0.0.0.0' to access the server from outside.
		hostname: "0.0.0.0"
		livereload: 35730

	livereload:
		options:
			open: true
	dist:
		options:
			open: true
			base: "dist"
