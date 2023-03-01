###
Options:
	maxTapCount: 5
	maxPreviewCount: 5 (unused option)
	hasBorders: false (default true)
	initSpeed: 0.1
	showTutorial: true (default false, only works if showHint is true)
	showHint: true (default false)
	ext: "jpg" (default "png")
###

module.exports = [
	width: 3
	height: 3
	initMoves: [["x",-1,2],["y",-1,1]]
	initSpeed: 0.05
	showTutorial: true
	showHint: true
	backgroundColor: "#AAAAAA"
, # Level 2
	width: 3
	height: 3
	initMoves: [["x",-1,2],["y",-1,1]]
	initSpeed: 0.1
	showHint: true
	backgroundColor: "#AAAAAA"
, # Level 3
	width: 3
	height: 3
	initMoves: [["x",1,0],["y",1,1],["x",2,1]]
	initSpeed: 0.15
	backgroundColor: "#AAAAAA"
, # Level 4
	width: 3
	height: 3
	initMoves: [["x",-1,2],["y",-2,1],["x",2,1],["x",1,0],["y",1,2],["y",2,0]]
	initSpeed: 0.15
	backgroundColor: "#AAAAAA"
, # Level 5
	width: 4
	height: 4
	backgroundColor: "#FFBDBD"
, # Level 6
	width: 4
	height: 4
	backgroundColor: "#FFF3CD"
, # Level 7
	width: 4
	height: 4
	backgroundColor: "#D5B0A4"
]