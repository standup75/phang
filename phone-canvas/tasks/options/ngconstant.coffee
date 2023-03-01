module.exports =
	options:
		space: "  "
		constants:
			columnCount: 7
			pageSize: 12
			maxPrice: 2000
			s3BucketName: "assets.lovelooks.com"
			s3Protocol: "http"

	development:
		options:
			dest: ".tmp/scripts/config.js"
			name: "config"

		constants:
			apiUrl: "http://localhost:3000/api/v1"
			requestTimeout: 5000
			fbAppId: "132881906737466"

	production:
		options:
			dest: ".tmp/scripts/config.js"
			name: "config"

		constants:
			apiUrl: "https://lovelooks.herokuapp.com/api/v1"
			requestTimeout: 5000
			fbAppId: "132881906737466"
