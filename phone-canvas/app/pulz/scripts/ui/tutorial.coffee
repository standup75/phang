"use strict"

phang = require "phang"
data = require "../data.coffee"

handImg = phang.images.load "hand.png"
moveProperties = move = stepNumber = timer = null
imgSize = ctx = stepCountTotal = null
scaleStep = 0.05
startHandScale = handScale = 2
handOffset =
  x: 325
  y: 25
increment = 0.05 # speed at which moves are made

reset = ->
  handScale = startHandScale
  moveProperties = move = stepNumber = timer = null

init = ->
  ctx = phang.globals.previewCtx
  imgSize = handImg.height
  stepCountTotal = 1 / increment

makeMove = (hint) ->
  reset()
  l = data.currentLevel()
  if l.showTutorial
    move = hint
    stepNumber = 0
    moveProperties =
      handX: Math.round l.boardX + (l.tileWidthDest - handOffset.x) / 2
      handY: Math.round l.boardY + (l.tileHeightDest - handOffset.y) / 2
    if hint[0] is "x"
      moveProperties.stepX = l.tileWidthDest * increment
      moveProperties.stepY = 0
      if hint[1] < 0
        moveProperties.stepX *= -1
        moveProperties.handX += (l.width - 1) * l.tileWidthDest
      moveProperties.handY += hint[2] * l.tileHeightDest
    else
      moveProperties.stepY = l.tileHeightDest * increment
      moveProperties.stepX = 0
      if hint[1] < 0
        moveProperties.stepY *= -1
        moveProperties.handY += (l.height - 1) * l.tileHeightDest
      moveProperties.handX += hint[2] * l.tileWidthDest
    setTimeout ->
      phang.pubsub.subscribe "repaint", showHand
    , 2000

scaleHand = ->
  phang.ui.clear ctx
  ctx.save()
  ctx.scale handScale, handScale
  drawHand()
  ctx.restore()

showHand = ->
  scaleHand()
  handScale -= scaleStep
  if handScale < 1
    phang.pubsub.unsubscribe "repaint", showHand
    phang.pubsub.subscribe "repaint", moveHand
    phang.pubsub.publish "makeMove", move, increment

moveHand = ->
  phang.ui.clear ctx
  drawHand()
  stepNumber++
  if stepNumber >= stepCountTotal
    phang.pubsub.unsubscribe "repaint", moveHand
    phang.pubsub.subscribe "repaint", hideHand

hideHand = ->
  scaleHand()
  handScale += scaleStep
  if handScale > 2
    console.log "ok"
    data.addToPath move
    phang.pubsub.unsubscribe "repaint", hideHand
    phang.pubsub.publish "moved"
    phang.ui.clear ctx

drawHand = ->
  ctx.drawImage(
    handImg
    moveProperties.handX + stepNumber * moveProperties.stepX
    moveProperties.handY + stepNumber * moveProperties.stepY)

phang.pubsub.subscribe "imagesLoaded", init
phang.pubsub.subscribe "hint", makeMove, 300
