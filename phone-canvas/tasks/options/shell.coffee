module.exports =
	options:
		stdout: true
		execOptions:
			maxBuffer: Infinity
	androidDebug:
		command: "cd scripts && ./android_debug.sh <%= config.project %>"
	androidRelease:
		command: "cd scripts && ./android_release.sh <%= config.project %>"
	iosRelease:
		command: "cd scripts && ./ios_archive.sh <%= config.project %>"
	web:
		command: "cd scripts && ./web_deployment.sh <%= config.project %>"
	test:
		command: "cd scripts && ./test.sh <%= config.project %>"
	rename_pulz_bin_full:
		command: "mv build/pulz.apk build/pulz_full.apk; mv build/pulz.ipa build/pulz_full.ipa"
	rename_pulz_bin_free:
		command: "mv build/pulz.apk build/pulz_free.apk; mv build/pulz.ipa build/pulz_free.ipa"
