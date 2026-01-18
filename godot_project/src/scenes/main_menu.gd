extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Scene1/PlayBtn.pressed.connect(StartScene1)
	$HBoxContainer/Scene2/PlayBtn.pressed.connect(StartScene2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_video_btn_pressed() -> void:
	OS.shell_open("https://www.youtube.com/watch?v=vNWSEvBKPj0&list=PL1rq2aiF4jozrMs9-kxwQHnVzFuRz58cr&index=19")

func StartScene1()->void:
	get_tree().change_scene_to_file("uid://cc5ge4ut10bag")

func StartScene2()->void:
	get_tree().change_scene_to_file("uid://dg45do12wrruw")
