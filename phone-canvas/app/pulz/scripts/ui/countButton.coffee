phang = require "phang"
data = require "../data.coffee"
fontSize = 25
buttonMargin = 27
maxSize = 200
countPadding = 10

class CountButton
	constructor: (img, ctx, margin = 0, x = buttonMargin) ->
		@ctx = ctx
		@img = img
		@margin = margin
		cl = data.currentLevel()
		footerY = cl.boardY + cl.boardHeight
		footerY = Math.max footerY, phang.globals.height - maxSize
		footerHeight = phang.globals.height - footerY
		buttonHeight = footerHeight - 2 * buttonMargin
		@y = footerY + buttonMargin
		@width = buttonHeight * img.width / img.height
		@height = buttonHeight
		if x is "centered"
			@x = Math.round (phang.globals.width - @width) / 2
		else
			@x = x
	clear: -> @ctx.clearRect @x, @y - countPadding, @width + countPadding, @height + countPadding
	displayButton: ->
		@ctx.save()
		@ctx.drawImage @img, 0, 0, @img.width, @img.height, @x + @margin, @y + @margin, @width - 2 * @margin, @height - 2 * @margin
		@ctx.globalAlpha = 0.2
		@ctx.fillStyle = "#FFFFFF"
		@ctx.fillRect @x, @y, @width, @height
		@ctx.restore()
	displayCount: (count) ->
		if count > 0
			@ctx.font = "#{fontSize}px Helvetica"
			countWidth = @ctx.measureText(count).width
			countHeight = (2 * countPadding + fontSize)
			right = @x + @width + countPadding
			top = @y - countPadding
			radius = countHeight / 2
			@ctx.fillStyle = "#555555"
			@ctx.fillRect right - countWidth - radius, top, countWidth, countHeight
			@ctx.beginPath()
			@ctx.arc right - radius, top + radius, radius, -Math.PI / 2, Math.PI / 2
			@ctx.fill()
			@ctx.beginPath()
			@ctx.arc right - countWidth - radius, top + radius, radius, Math.PI / 2, 3 * Math.PI / 2
			@ctx.fill()
			@ctx.fillStyle = "#ffffff"
			@ctx.fillText count, right - countWidth - radius, top + countPadding - 2 + fontSize


module.exports = CountButton