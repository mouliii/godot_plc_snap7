extends Control

@onready var netowrkScene := preload("uid://htrx4trcd1v2")
@onready var networkContainer: VBoxContainer = $Networks/ScrollContainer/NetworkContainer


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(get_viewport().get_mouse_position())

func UpdateRungs()->void:
	for nw in networkContainer.get_children():
		if !nw.folded:
			nw.Reconstruct()

func _on_scroll_container_sort_children() -> void:
	call_deferred("UpdateRungs")
