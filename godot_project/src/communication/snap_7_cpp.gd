extends Snap7Wrapper


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pollRate = 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if IsConnected():
		get_tree().call_group("PLC_TAGS", "PollPlcData")
