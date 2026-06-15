extends BaseBlock

func _ready() -> void:
	size = NetworkConsts.blockDefaultSize

func _draw() -> void:
	var pos := Vector2(0, size.y / 2.0)
	var endPos := pos + Vector2(NetworkConsts.networkWidth,0)
	draw_line(pos, endPos, NetworkConsts.networkdColorOffline, NetworkConsts.lineWidth)

func InitBlock(pos:Vector2)->void:
	global_position = pos - Vector2(0, size.y / 2.0)
	nextBlock = self
	size = Vector2(NetworkConsts.networkWidth, 30)
