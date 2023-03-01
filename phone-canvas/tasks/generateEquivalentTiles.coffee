fs = require "fs"
getPixels = require "get-pixels"

crcTable = do ->
	c = undefined
	t = []
	n = 0

	while n < 256
		c = n
		k = 0

		while k < 8
			c = ((if (c & 1) then (0xedb88320 ^ (c >>> 1)) else (c >>> 1)))
			k++
		t[n] = c
		n++
	t

crc32 = (arr) ->
	crc = 0 ^ (-1)
	i = 0

	while i < arr.length
		crc = (crc >>> 8) ^ crcTable[(crc ^ arr[i]) & 0xff]
		i++
	(crc ^ (-1)) >>> 0

getArray = (ndArray) ->
	res = []
	x = ndArray.shape[0]
	while x--
		y = ndArray.shape[1]
		while y--
			z = ndArray.shape[2]
			while z--
				res.push ndArray.get x, y, z
	res

isInt = (val) -> val is Math.floor val

buildCoffee = (levels) ->
	coffeeStr = "module.exports = ["
	for level, i in levels
		for k, v of level
			if k isnt "isReliable" and (k isnt "equivalentTiles" or v.length)
				coffeeStr += "\n\t#{k}: "
				if typeof v is "string"
					coffeeStr += "\"#{v}\""
				else if typeof v is "number"
					coffeeStr += "#{v}"
				else
					coffeeStr += "#{JSON.stringify v}"
					coffeeStr += " # unreliable" if k is "equivalentTiles" and not level.isReliable
		coffeeStr += "\n, # Level #{i + 2}"  if levels[i + 1]

	coffeeStr + "\n]"

getComments = (levelsPath) -> fs.readFileSync(levelsPath).toString().match(/###[\s\S]*###/)?[0] + "\n\n"

module.exports = (grunt) ->
	grunt.registerTask "generateEquivalentTiles", (target) ->
		appPath = "app/#{target}"
		imagePath = "#{appPath}/images"
		levelsPath = "#{appPath}/scripts/levels.coffee"
		config = require "../#{appPath}/scripts/config"
		levels = require "../#{levelsPath}"
		done = this.async()
		files = fs.readdirSync imagePath
		fileCount = files.length
		files.forEach (file) ->
			if file.match /^level/
				do (file) ->
					levelNumber = parseInt file.match(/^level(.*)\./)[1]
					getPixels "#{imagePath}/#{file}", (err, pixels) ->
						if err
							grunt.log.error "#{file}: could not get the pixels", err
						else
							levelData = levels[levelNumber - 1]
							levelMargin = if levelData.hasBorders is false then 0 else config.margin + 4
							w = levelData.width
							xStep = pixels.shape[0] / levelData.width
							yStep = pixels.shape[1] / levelData.height
							hiWidth = xStep - 2 * levelMargin
							hiHeight = yStep - 2 * levelMargin
							sortedByChecksum = {}
							while w--
								x = Math.floor w * xStep + levelMargin
								h = levelData.height
								while h--
									y = Math.floor h * yStep + levelMargin
									tile = pixels.lo(x, y, 0).hi(hiWidth, hiHeight, 4)
									checksum = crc32 getArray tile
									sortedByChecksum[checksum] = []  unless sortedByChecksum[checksum]
									sortedByChecksum[checksum].push [w, h]
							res = []
							for k, v of sortedByChecksum
								res.push v  if v.length > 1
							levelData.isReliable = isInt(xStep) and isInt(yStep)
							levelData.equivalentTiles = res
							if res.length
								if levelData.isReliable
									grunt.log.writeln "Level #{levelNumber}: #{res.length} equivalent tile(s) found."
								else
									grunt.log.error "Level #{levelNumber}: #{res.length} equivalent tile(s) found. unreliable"
							else
								grunt.log.writeln "Level #{levelNumber}: no equivalent tiles found."
						unless --fileCount
							fs.writeFileSync levelsPath, getComments(levelsPath) + buildCoffee(levels)
							grunt.log.ok "levels.coffee updated"
							done()
			else
				fileCount--
