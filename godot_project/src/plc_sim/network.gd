extends FoldableContainer

@onready var rung: Control = $"VBoxContainer/Canvas"
@onready var start: Control = $VBoxContainer/Canvas

@onready var vLineInst := preload("uid://8ok3egjpkmlw")
@onready var hLineInst := preload("uid://bda8iioy8pgpc")
@onready var ncInst := preload("uid://4ynfbej3h7oo")

# TODO:
# mistä tulee 40???????????????????????????????????????????? (noin)
# rung.get_child(0).lineLength = get_rect().size.y - start.position.y - 40 # < ?????????????????????

var ladderNodes := []
var yDepth := [0]

var nextBlockPos := Vector2()
var railOffset := Vector2(50, 50)
var containerHeight := 350

func _ready() -> void:
	custom_minimum_size.y = containerHeight
	size.y = containerHeight
	#set_deferred("size", Vector2(size.x, containerHeight))
	# TODO:
	var lineEdit := LineEdit.new()
	add_title_bar_control(lineEdit)
	MakeEmptyNetwork()
	#rung.add_child(hLineInst.instantiate())
	#rung.add_child(ncInst.instantiate())
	#rung.add_child(hLineInst.instantiate())
	#rung.add_child(ncInst.instantiate())
	#rung.add_child(ncInst.instantiate())
	#rung.add_child(hLineInst.instantiate())
	#rung.add_child(ncInst.instantiate())
	#await get_tree().process_frame
	#Reconstruct()

func AddBlock(id:NetworkConsts.NODE_ID)->void:
	match id:
		NetworkConsts.NODE_ID.NOP:
			pass
		NetworkConsts.NODE_ID.NC:
			pass
		NetworkConsts.NODE_ID.COIL:
			pass

func Reconstruct()->void:
	nextBlockPos = railOffset
	# vertical power rail
	rung.get_child(0).position = Vector2(railOffset.x, 0)
	rung.get_child(0).lineLength = get_rect().size.y - start.position.y - 40 # < ?????????????????????
	prints(get_rect().size.y, start.position.y, get_rect().size.y - start.position.y)
	nextBlockPos += Vector2(rung.get_child(0).size.x / 2, 50)
	# half horizontal
	# rest
	for r in range(1, rung.get_child_count(), 1):
		rung.get_child(r).position = nextBlockPos
		nextBlockPos.x += rung.get_child(r).get_node("PositionGateComponent").ENO.position.x

func MakeEmptyNetwork()->void:
	rung.add_child(vLineInst.instantiate())
	rung.add_child(hLineInst.instantiate())
	

func _draw() -> void:
	pass
	#if folded:
	#	return
	# vertical line
	#var startPoint:Vector2 = start.position + railOffset
	#var endPoint := startPoint + Vector2(0, containerHeight)
	#draw_line(startPoint, endPoint, Color.RED, NetworkConsts.lineWidth)


func _on_folding_changed(_is_folded: bool) -> void:
	if _is_folded:
		custom_minimum_size = Vector2(-1,-1)
	else:
		custom_minimum_size.y = containerHeight
		size.y = containerHeight
