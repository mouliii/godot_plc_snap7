extends Snap7Wrapper

#TODO rename 'wrapper'

func _ready() -> void:
	pollRate = 0.150
	$Timer.wait_time = pollRate
	

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if IsConnected():
		get_tree().call_group("PLC_TAGS", "PollPlcData")
