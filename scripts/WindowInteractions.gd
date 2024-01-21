extends Area2D

@export var USE_X:bool = true

@onready var fall_pos:Vector2 = $FallPosition.global_position

var bodies_in_zone = []
var glass_shattered:bool = false

func _process(delta):
	if len(bodies_in_zone) > 0 and glass_shattered == false:
		glass_shattered = true
		$EnvGlassTest.visible = false
		SignalBus.emit_signal("window_broken")
		# play shattering sfx
		$GlassBreak.emitting = true
	##
##

func _on_body_entered(body):
	body.falling = true
	
	if USE_X:
		var pos = Vector2($FallPosition.global_position.x, body.global_position.y)
		body.fall_lerp_to = pos
	else:
		var pos = Vector2(body.global_position.x, $FallPosition.global_position.y)
		body.fall_lerp_to = pos
	##
##
