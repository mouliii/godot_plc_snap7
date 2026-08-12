extends Control

func _ready() -> void:
	await get_tree().process_frame

func _process(delta: float) -> void:
	pass
	#queue_redraw()
