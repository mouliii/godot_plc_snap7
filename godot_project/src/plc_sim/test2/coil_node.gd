extends Button


func _ready() -> void:
	pass

func _draw() -> void:
	var circleRadius := 10
	var drawPos:Vector2 = $PositionGateComponent/EnPos.position
	# --
	draw_line(drawPos, drawPos + Vector2(20,0), Color.RED, NetworkConsts.lineWidth)
	drawPos.x += 20 + circleRadius
	# -(
	draw_arc(drawPos, circleRadius, 3 * PI / 2.0, PI / 2.0, 10, Color.WHITE, NetworkConsts.lineWidth)
	# -( )
	draw_arc(drawPos + Vector2(10, 0), circleRadius, -PI / 2.0, PI / 2.0, 10, Color.WHITE, NetworkConsts.lineWidth)
	drawPos += Vector2(10 + 10, 0)
	# -( )
	draw_line(drawPos, drawPos + Vector2(10,0), Color.WHITE, NetworkConsts.lineWidth)
	# -( )-|
	#drawPos.x += 10
	#draw_line(drawPos + Vector2(0, -10), drawPos + Vector2(0,10), Color.WHITE, NetworkConsts.lineWidth)
