extends Control

@onready var netowrkScene := preload("uid://htrx4trcd1v2")

func _ready() -> void:
	await get_tree().process_frame
	var nw := netowrkScene.instantiate()
	#$Networks/VBoxContainer.add_child(nw)
	$Networks/VBoxContainer.call_deferred("add_child", nw)
	#nw.queue_redraw()
	#queue_redraw()

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(get_viewport().get_mouse_position())
