extends MeshInstance3D

@onready var rayCast: RayCast3D = $RayCast3D
@onready var tag: PLCTag = $PLCTag

var prevID:int = -9999999

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if rayCast.is_colliding():
		var target := rayCast.get_collider()
		if target.is_in_group("Products"):
			var boxID:int = target.boxID
			if prevID != boxID:
				tag.Write(boxID)
				prevID = boxID
