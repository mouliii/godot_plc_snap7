extends Control

@onready var blockInst := preload("res://src/plc_sim/BaseBlock.tscn")
@onready var nwContainer: VBoxContainer = $"../VBoxContainer"
@onready var start: Label = $"../VBoxContainer/Start"

var nextDrawPos := Vector2()
var railOffset := Vector2(50, 100)
var blocks:Array[BaseBlock] = []

func _ready() -> void:
	await get_tree().process_frame
	var pos = start.global_position
	nextDrawPos = pos + railOffset + Vector2(NetworkConsts.lineWidth / 2.0, NetworkConsts.firstBranchOffsetY)
	queue_redraw()
	await get_tree().create_timer(1.0).timeout
	AddBlock()

func AddBlock()->void:
	var initBlock = load("uid://dlf20jwqv0wgg").instantiate() as BaseBlock
	nwContainer.add_child(initBlock)
	await get_tree().process_frame
	initBlock.InitBlock(nextDrawPos)
	#nwContainer.call_deferred("add_child", initBlock)
	#initBlock.call_deferred("InitBlock", nextDrawPos)

func _draw() -> void:
	# vertical line
	var pos = $"../VBoxContainer/Start".position
	var startPoint:Vector2 = pos + NetworkConsts.railOffset
	var endPoint := startPoint + Vector2(0, NetworkConsts.networkHeight)
	draw_line(startPoint, endPoint, Color.RED, NetworkConsts.lineWidth)
