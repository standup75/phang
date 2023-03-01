"use strict"

phang = require "phang"
level = require "./level.coffee"
data = require "./data.coffee"
Tree = require "./tree.coffee"

maxDepth = checksums = moves = badTiles = checksumCount = mainScore = topScore = null
maxLoopCount = 500000

reset = ->
	maxDepth = checksums = moves = badTiles = null
	checksumCount = 0
	mainScore = 0
	topScore = 0

buildSolution = ->
	reset()
	checksums = {}
	cl = data.currentLevel()
	startTime = new Date().getTime()
	tiles = getCopyOfTiles()
	mainScore = topScore = level.score()
	history = []
	while mainScore < cl.width * cl.height
		startRoundTime = new Date().getTime()
		initMoves()
		maxDepth = getMaxDepth()
		res = maximize tiles, [], maxDepth
		roundTime = new Date().getTime() - startRoundTime
		# mainScore could sometimes be < topScore
		# we want to reset the checksums only if topScore has been beat
		if res.score > topScore
			topScore = res.score
			checksums = {}
			checksumCount = 0
		mainScore = res.score
		makeMoves tiles, res.history
		history = history.concat res.history
		#console.log "round score", res.score, level.checksum(tiles)
		#console.log "round time", roundTime, "checksumCount", checksumCount
	#console.log "total time", new Date().getTime() - startTime
	optimize history

getCopyOfTiles = -> level.tiles().map (t) -> t.slice()

optimize = (history) ->
	res = []
	cl = data.currentLevel()
	# combines consecutive moves on the same col/row
	for move in history
		if res.length
			lastMove = res[res.length - 1]
			length = if move[0] is "x" then cl.width else cl.height
			if lastMove[0] is move[0] and lastMove[2] is move[2]
				newMove = lastMove
				newMove[1] = (lastMove[1] + move[1]) % length
				res.pop()  unless newMove[1]
			else
				res.push move
				newMove = move
		else res.push move
	# set negative amounts when it makes sense
	for move in res
		if move[0] is "x" and move[1] > Math.floor(cl.width / 2)
			move[1] -= cl.width
		else if move[1] > Math.floor(cl.height / 2)
			move[1] -= cl.height
	findShortestPath res

findShortestPath = (history) ->
	tiles = getCopyOfTiles()
	tree = new Tree level.checksum()
	testChks = []
	for move in history
		makeMove tiles, move
		testChks.push level.checksum(tiles)
		tree.addChild level.checksum(tiles), move
	for chk, i in testChks
		j = testChks.indexOf(chk, i+1)
		if j > -1
			needOptimization = true
			console.log "duplicate found:", chk, i, j
	if needOptimization
		tree.findPath()
	else
		history

getMaxDepth = ->
	i = 2
	while i++
		backMoveCount = Math.pow 18, i
		forwardMoveCount = Math.pow moves.length, i
		return (i - 1) * 2  if backMoveCount * forwardMoveCount > maxLoopCount
	null

makeMoves = (tiles, history) ->
	makeMove(tiles, move)  for move in history

makeMove = (tiles, move) ->
	level.move[move[0]](move[1], move[2], tiles)

initMoves = ->
	cl = data.currentLevel()
	moves = []
	for col in [0..cl.width - 1]
		for moveLength in [1..cl.height - 1]
			moves.push ["y", moveLength, col]
	for row in [0..cl.height - 1]
		for moveLength in [1..cl.width - 1]
			moves.push ["x", moveLength, row]
	moves = filterMoves moves

filterMoves = (_moves, tiles) ->
	badTiles = getBadTiles tiles
	_moves.filter (move) -> badTiles[move[0] + move[2]] > 0

getBadTiles = (tiles) ->
	badTiles = {}
	cl = data.currentLevel()
	tiles = level.tiles()  unless tiles
	for y in [0..cl.height - 1]
		previousTile = null
		allSameTiles = true
		badTilesCount = cl.width
		for x in [0..cl.width - 1]
			tile = tiles[x][y]
			badTilesCount--  if level.isSame(tile, x, y)
			allSameTiles = false  if previousTile and !level.isSame(tile, previousTile[0], previousTile[1])
			previousTile = tile
		badTiles["x" + y] = if allSameTiles then 0 else badTilesCount
	for x in [0..cl.width - 1]
		previousTile = null
		allSameTiles = true
		badTilesCount = cl.height
		for y in [0..cl.height - 1]
			tile = tiles[x][y]
			badTilesCount--  if level.isSame(tile, x, y)
			allSameTiles = false  if previousTile and !level.isSame(tile, previousTile[0], previousTile[1])
			previousTile = tile
		badTiles["y" + x] = if allSameTiles then 0 else badTilesCount
	badTiles

getMovesBack = (history, cl) ->
	_moves = []
	cols = []
	rows = []
	forwardMoves = history.slice 0, maxDepth / 2
	for move in forwardMoves
		if move[0] is "x" and rows.indexOf(move[2]) is -1
			rows.push move[2]
		else if cols.indexOf(move[2]) is -1
			cols.push move[2]
	for row in rows
		for moveLength in [1..cl.width - 1]
			_moves.push ["x", moveLength, row]
	for col in cols
		for moveLength in [1..cl.height - 1]
			_moves.push ["y", moveLength, col]
	_moves

canMakeMove = (history, move) ->
	# first move, ok
	return true  unless history.length
	# otherwise, check if we move the row/col than last time
	lastMove = history[history.length - 1]
	not(lastMove[0] is move[0] and lastMove[2] >= move[2])

maximize = (tiles, history, depth, top) ->
	score = level.score tiles
	branchTopScore = top?.score || topScore
	if score > branchTopScore
		top =
			score: score
			history: history.slice()
	if depth
		cl = data.currentLevel()
		res = { score: 0 }
		if depth < (maxDepth + 1) / 2
			_moves = getMovesBack history, cl
		else
			_moves = filterMoves moves, tiles
		for move in _moves
			if canMakeMove history, move
				level.move[move[0]] move[1], move[2], tiles
				chk = level.checksum tiles
				unless (savedChk = checksums[chk]) and savedChk >= depth					
					checksumCount++   unless checksums[chk]
					checksums[chk] = depth
					history.push move
					max = maximize tiles, history, depth - 1, top
					if max.score > res.score or (res.history and max.score is res.score and max.history.length < res.history.length)
						res =
							score: max.score
							history: max.history
					history.pop()
				level.move[move[0]] -move[1], move[2], tiles
		return res
	else
		top ||
			score: score
			history: history.slice()

phang.pubsub.subscribe "ai", ->
	console.log JSON.stringify buildSolution()
phang.pubsub.subscribe "testOptimization", (history) ->
	console.log JSON.stringify findShortestPath history

module.exports =
	buildSolution: buildSolution
