module.exports =
	options:
		accessKeyId: "AKIAITYRAPAZLR3F4RQA"
		secretAccessKey: "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"
		uploadConcurrency: 5 # 5 simultaneous uploads
		downloadConcurrency: 5 # 5 simultaneous downloads
	pulz_landing:
		options:
			bucket: 'pulz.standupweb.net'
			region: 'us-west-2',
			params:
				CacheControl: "max-age=630720000, public"
				Expires: new Date Date.now() + 63072000000
		files: [
			{expand: true, cwd: 'dist/', src: ['**'], dest: ''}
		]
