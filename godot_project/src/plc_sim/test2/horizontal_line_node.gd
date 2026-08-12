extends Button

var lineLength: int:
	get:
		return lineLength
	set(value):
		lineLength = value
		SetHeight()

func _ready() -> void:
	pass

func SetHeight()->void:
	custom_maximum_size.x = lineLength
	$LineHorizontal.size.y = lineLength
	$PositionGateComponent/EnoPos.position.x = lineLength

func _on_pressed() -> void:
	grab_focus()
