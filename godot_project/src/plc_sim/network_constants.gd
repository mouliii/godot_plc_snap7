extends Node

var lineWidth = 2.0
var railOffset := Vector2(50, 50)
var firstBranchOffsetY := 50
var networkWidth := 500
var networkHeight := 300

var networkdColorOffline := Color.BLACK
var networkColorOff := Color.BLUE
var networkColorOn := Color.LAWN_GREEN

var blockDefaultSize := Vector2(100,30)

enum NODE_ID {NOP, NO, NC, COIL}
