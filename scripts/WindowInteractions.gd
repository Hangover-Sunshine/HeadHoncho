extends Area2D

@export var USE_X:bool = true

@onready var fall_pos:Vector2 = $FallPosition.global_position

var bodies_in_zone = []
var glass_shattered:bool = false

func _ready():
	pass
##

func _process(delta):
	if len(bodies_in_zone) > 0 and glass_shattered == false:
		glass_shattered = true
		$EnvGlassTest.visible = false
		SignalBus.emit_signal("window_broken")
		# play shattering sfx
		# play shattering particles
	##
	
	var res = []
	
	for body in bodies_in_zone:
		res.append(body.fall())
		
		if USE_X:
			var dist = abs(fall_pos.x) - abs(body.global_position.x)
			if dist <= 10:
				body.velocity = Vector2.ZERO
			##
		else:
			var dist = abs(fall_pos.y) - abs(body.global_position.y)
			if dist <= 10:
				body.velocity = Vector2.ZERO
			##
		##
	##
	
	for r in range(len(res)):
		if res[r] == true:
			bodies_in_zone.remove_at(r)
		##
	##
##

func _on_body_entered(body):
	if body is Player:
		bodies_in_zone.append(body)
	##
	if body is Dickhead:
		bodies_in_zone.append(body)
	##
##

func _on_body_exited(body):
	pass # Replace with function body.
##
