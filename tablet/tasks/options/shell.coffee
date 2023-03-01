module.exports =
	options:
		stdout: true
		execOptions:
			maxBuffer: Infinity
	androidDebug:
		command: "cd scripts && ./android_debug.sh"
	androidRelease:
		command: "cd scripts && ./android_release.sh"
	iosRelease:
		command: "cd scripts && ./ios_archive.sh"
	web:
		command: "cd scripts && ./web_deployment.sh"