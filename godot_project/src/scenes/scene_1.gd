extends Node

signal UpdateTabMenu()

@onready var n_boxes: Label3D = $Machines/NBoxes

var boxInst = preload("uid://jvcga1w45fq7")

func _ready() -> void:
	UpdateTabMenu.connect($CanvasLayer/TabMenu.UpdateConnectionStatus)
	var status = Snap7Cpp.ConnectToPLC("192.168.0.90",0,1)
	if status != 0:
		print("connection failed")
	else:
		print("connected to PLC!")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_tabmenu"):
		$CanvasLayer/TabMenu.visible = !$CanvasLayer/TabMenu.visible
		if $CanvasLayer/TabMenu.visible:
			emit_signal("UpdateTabMenu")

func _process(_delta: float) -> void:
	n_boxes.text = str(int(n_boxes.get_child(0).Read()))


func _on_player_catcher_body_entered(body: Node3D) -> void:
	if body is Player:
		body.global_position = $Logic/PlayerCatcher/Marker3D.global_position


func _on_box_spawner_body_exited(_body: Node3D) -> void:
	if $Logic/BoxSpawner.get_overlapping_bodies().size() == 0:
		var pos:Vector3 = $Logic/BoxSpawner/SpawnPos.global_position
		var box = boxInst.instantiate()
		$Boxes.add_child(box)
		box.global_position = pos

func _on_box_despawner_body_entered(body: Node3D) -> void:
	if body.is_in_group("Products"):
		body.queue_free()
