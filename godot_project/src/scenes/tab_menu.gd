extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: save/load settings
	$VBoxContainer/IpContainer/IpEdit.placeholder_text = Snap7Cpp.ipAddress

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible:
		$%CurFps.text = str(Engine.get_frames_per_second())

func UpdateConnectionStatus()->void:
	if Snap7Cpp.IsConnected():
		%Status.text = "true"
	else:
		%Status.text = "false"

func _on_ip_edit_text_submitted(new_text: String) -> void:
	Snap7Cpp.ipAddress = new_text

func _on_connect_button_pressed() -> void:
	var status = Snap7Cpp.ConnectToPLC(Snap7Cpp.ipAddress, 0, 1)
	if status != 0:
		print("connection failed")
	else:
		print("connected to PLC!")
	UpdateConnectionStatus()

func _on_vsync_button_pressed() -> void:
	var mode = DisplayServer.window_get_vsync_mode()
	if mode == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _on_fps_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		Engine.max_fps = int(new_text)
