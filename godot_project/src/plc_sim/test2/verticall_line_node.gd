extends Button


var lineLength: int:
	get:
		return lineLength
	set(value):
		lineLength = value
		SetWidth()

func _ready() -> void:
	pass

func SetWidth()->void:
	size.y = lineLength
	#$LineVertical.size.y = lineLength
	$PositionGateComponent/EnoPos.position.y = lineLength

func _on_pressed() -> void:
	grab_focus()
