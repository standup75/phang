###
Options:
	maxTapCount: 5
	maxPreviewCount: 5 (unused option)
	hasBorders: false (default true)
	initSpeed: 0.1
	showHint: true (default false)
	ext: "jpg" (default "png")
###

module.exports = [
	width: 3
	height: 3
	initMoves: [["y",-1,2],["x",-2,1],["y",2,1],["y",1,0],["x",1,2],["x",2,0]]
	initSpeed: 0.05
	showHint: true
	backgroundColor: "#000000"
	equivalentTiles: [[[2,1],[1,2],[1,1],[1,0],[0,1]]]
]