extends Node

#TODO: spawni laittaa fault raten ja id, myös roska id

var boxInst = preload("uid://jvcga1w45fq7")

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func _on_box_spawner_body_exited(_body: Node3D) -> void:
	if $Logic/BoxSpawner.get_overlapping_bodies().size() == 0:
		var pos:Vector3 = $Logic/BoxSpawner/SpawnPos.global_position
		var box = boxInst.instantiate()
		$Products.add_child(box)
		box.global_position = pos
		box.faultRate = 0.15
		if randf() < 0.15:
			box.color = Color(255,0,255)
			box.faulty = true
		else:
			var rng = randi_range(0,2)
			match rng:
				0:
					box.color = Color(255,0,0)
				1:
					box.color = Color(0,255,0)
				2:
					box.color = Color(0,0,255)
		box.color = box.color * 0.2


func _on_fault_deleter_body_entered(_body: Node3D) -> void:
	var bodies = $Logic/FaultDeleter.get_overlapping_bodies()
	if $Logic/FaultDeleter.get_overlapping_bodies().size() >= 3:
		for b in bodies:
			b.queue_free()
