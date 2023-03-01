module.exports =
	options:
		transform: ["coffeeify"]
		extensions: [".coffee"]
		external: ["config"]
	dist:
		src: ["app/<%= config.project %>/scripts/**/*.coffee"]
		dest: ".tmp/scripts/phang.js"
		options:
			alias: [
				"./app/phang/scripts/app.coffee:phang"
				"./app/conf.coffee:conf"
			]
