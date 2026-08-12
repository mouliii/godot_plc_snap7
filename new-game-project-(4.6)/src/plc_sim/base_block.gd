extends Button
class_name BaseBlock

@export var parentBlock:BaseBlock = null
@export var nextBlock:BaseBlock = null
@export var energized := false

func _init() -> void:
	pass

func _on_pressed() -> void:
	self.grab_focus()

func _on_focus_entered() -> void:
	pass

func _draw() -> void:
	pass

func InitBlock(pos:Vector2)->void:
	global_position = pos - Vector2(0, size.y / 2.0)
	size = Vector2(NetworkConsts.networkWidth, 30)
