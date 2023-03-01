"use strict"

phang = require "phang"
levels = require "./levels.coffee"
config = require "./config.coffee"

gameLastLevel = if config.freeVersion then config.freeLevelCount else config.fullVersionLevelCount

module.exports =
	currentLevel: -> @levels[@currentLevelNumber()]
	resetLevelData: ->
		phang.persist.snapshot []
		phang.persist.currentPath []
		phang.persist.snapshotLevel @currentLevelNumber()
		phang.persist.previewCount 0
		phang.persist.tapCount 0
	hasSnapshot: -> phang.persist.currentLevel() is phang.persist.snapshotLevel() and phang.persist.snapshot().length
	currentLevelNumber: -> parseInt phang.persist.currentLevel(), 10
	getHighscore: (levelNumber = @currentLevelNumber()) -> phang.persist.highscores()[levelNumber]
	setHighscore: ->
		score = phang.persist.currentPath().length
		levelNumber = @currentLevelNumber()
		highscores = phang.persist.highscores()
		highscores[levelNumber] = score
		phang.persist.highscores highscores
	isHighscore: -> not @getHighscore() or phang.persist.currentPath().length <= @getHighscore()
	addToPath: (move) ->
		currentPath = phang.persist.currentPath()
		if currentPath.length
			lastMove = currentPath[currentPath.length - 1]
			if lastMove[0] is move[0] and lastMove[2] is move[2]
				lastMove[1] = lastMove[1] + move[1]
			else
				currentPath.push move
		else
			currentPath.push move
		phang.persist.currentPath currentPath
		phang.pubsub.publish "pathUpdated"
	hasCurrentPath: -> phang.persist.currentPath()?.length > 0
	popPath: ->
		currentPath = phang.persist.currentPath()
		move = currentPath.pop()
		phang.pubsub.publish "pathUpdated"
		phang.persist.currentPath currentPath
		move
	gotoNextLevel: ->
		lastAvailableLevel = parseInt phang.persist.lastAvailableLevel(), 10
		lastAvailableLevel = Math.max lastAvailableLevel, @currentLevelNumber() + 1
		phang.persist.lastAvailableLevel Math.min gameLastLevel - 1, lastAvailableLevel
		phang.persist.currentLevel Math.min gameLastLevel, @currentLevelNumber() + 1
	gameIsDone: -> @currentLevelNumber() >= gameLastLevel
	levels: levels
