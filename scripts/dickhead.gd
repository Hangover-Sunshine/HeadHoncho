extends CharacterBody2D
class_name Dickhead

@export_group("Movement")
@export var SPEED:float = 300.0

func _physics_process(delta):
	move_and_slide()
##
