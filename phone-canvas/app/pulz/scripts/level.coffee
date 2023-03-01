"use strict"

phang = require "phang"
data = require "./data.coffee"
config = require "./config.coffee"
won = require "./ui/won.coffee"

tiles = []

init = ->
	if data.gameIsDone()
		phang.pubsub.publish "won"
	else
		initTiles()
		ext = data.currentLevel().ext || "png"
		phang.images.load "level#{data.currentLevelNumber() + 1}.#{ext}", prepareLevel

initTiles = ->
	level = data.currentLevel()
	x = level.width
	tiles = []
	while x-- > 0
		tiles[x] = []
		y = level.height
		while y-- > 0
			tiles[x][y] = [x, y]
	null

prepareLevel = (image) ->
	boardMaxWidth = phang.globals.width
	boardMaxHeight = phang.globals.height - config.footerHeight - config.headerHeight
	l = data.currentLevel()
	l.image = image
	l.tileWidthOrigin = Math.round l.image.width / l.width
	l.tileHeightOrigin = Math.round l.image.height / l.height
	if boardMaxWidth / l.width < boardMaxHeight / l.height
		l.tileWidthDest = Math.round boardMaxWidth / l.width
		l.tileHeightDest = l.tileWidthDest
		l.boardWidth = boardMaxWidth
		l.boardHeight = l.height * l.boardWidth / l.width
		l.boardY = Math.round (phang.globals.height - l.boardHeight) / 2
		l.boardX = 0
	else
		l.tileHeightDest = Math.round boardMaxHeight / l.height
		l.tileWidthDest = l.tileHeightDest
		l.boardHeight = boardMaxHeight
		l.boardWidth = l.width * l.boardHeight / l.height
		l.boardY = config.headerHeight
		l.boardX = Math.round (phang.globals.width - l.boardWidth) / 2
	if l.equivalentTiles
		l.equivalentHash = {}
		for equivalentTiles in l.equivalentTiles
			for tile, i in equivalentTiles
				l.equivalentHash["#{tile[0]},#{tile[1]}"] = equivalentTiles.slice(0)
				l.equivalentHash["#{tile[0]},#{tile[1]}"].splice i, 1
	phang.pubsub.publish "levelReady"
	null

# randomize, check that no tiles are in their right place after a shuffle
randomize = ->
	level = data.currentLevel()
	d =
		x: level.width
		y: level.height
	x = d.x
	amount = newAmount = 0
	while x--
		while amount is newAmount
			newAmount = Math.floor Math.random() * (d.y - 1) + 1
		amount = newAmount
		move.y amount, x
	y = d.y
	amount = newAmount = 0
	while y--
		while amount is newAmount
			newAmount = Math.floor Math.random() * (d.x - 1) + 1
		amount = newAmount
		move.x amount, y
	moveCount = 3 * d.x * d.y
	t = new Date().getTime()
	while new Date().getTime() - t < 1000 and (moveCount-- > 0 or score() > 0)
		orientation = if Math.random() < 0.5 then "x" else "y"
		otherOrientation = if orientation is "x" then "y" else "x"
		amount = Math.floor(Math.random() * (d[orientation] - 1)) + 1
		index = Math.floor(Math.random() * d[otherOrientation])
		move[orientation] amount, index
	null

move =
	x: (direction, y, _tiles = tiles) ->
		row = []
		x = width = data.currentLevel().width
		direction = direction % width
		row[x] = _tiles[x][y]  while x--
		x = width
		_tiles[x][y] = row[(x - direction + width) % width]  while x--
		_tiles
	y: (direction, x, _tiles = tiles) ->
		col = []
		y = height = data.currentLevel().height
		direction = direction % height
		col[y] = _tiles[x][y]  while y--
		y = height
		_tiles[x][y] = col[(y - direction + height) % height]  while y--
		_tiles

isSame = (tile, x, y) ->
	return true  if tile[0] is x and tile[1] is y
	equivalentTiles = data.currentLevel().equivalentHash?["#{x},#{y}"]
	if equivalentTiles
		for eqtile in equivalentTiles
			return true  if tile[0] is eqtile[0] and tile[1] is eqtile[1]
	false

score = (_tiles = tiles) ->
	_score = 0
	level = data.currentLevel()
	x = level.width
	while x-- > 0
		y = level.height
		while y-- > 0
			_score++  if isSame _tiles[x][y], x, y
	_score

isComplete = ->
	level = data.currentLevel()
	score() is level.height * level.width

tapLeft = ->
	maxTapCount = data.currentLevel().maxTapCount
	if maxTapCount?
		maxTapCount - phang.persist.tapCount()
	else
		-1

previewLeft = ->
	maxPreviewCount = data.currentLevel().maxPreviewCount
	if maxPreviewCount?
		maxPreviewCount - phang.persist.previewCount()
	else
		-1

checksum = (_tiles = tiles) ->
	chks = ""
	level = data.currentLevel()
	x = level.width
	while x-- > 0
		y = level.height
		while y-- > 0
			tile = _tiles[x][y]
			chks += ("0" + (tile[0] * 10 + tile[1])).substr(-2)
	chks

testMove = (m, tiles) ->
	move[m[0]] m[1], m[2], tiles

testMoves = (moves, tiles) ->
	if moves
		testMove(m, tiles)  for m in moves

phang.pubsub.subscribe "imagesLoaded", init, 150
phang.pubsub.subscribe "initLevel", init
phang.pubsub.subscribe "testMove", testMove
phang.pubsub.subscribe "testMoves", testMoves
phang.pubsub.subscribe "setTiles", (checksum) ->
	level = data.currentLevel()
	if checksum.length is level.width * level.height * 2
		_tiles = []
		i = 0
		x = level.width
		while x-- > 0
			_tiles[x] = []
			y = level.height
			while y-- > 0
				_tiles[x][y] = [parseInt(checksum.substr(i, 1), 10), parseInt(checksum.substr(i + 1, 1), 10)]
				i += 2
		phang.persist.snapshot _tiles
		phang.pubsub.publish "initLevel"
	else
		console.error "checksum has #{checksum.length} chars, but we need #{level.width * level.height * 2} chars"

module.exports =
	isComplete: isComplete
	score: score
	tiles: (t) ->
		tiles = t  if t
		tiles
	isSame: isSame
	randomize: randomize
	move: move
	tapLeft: tapLeft
	previewLeft: previewLeft
	checksum: checksum