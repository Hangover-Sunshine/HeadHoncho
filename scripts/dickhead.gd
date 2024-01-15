extends CharacterBody2D
class_name Dickhead

@export_group("Movement")
@export var MOVEMENT_SPEED:float = 400.0

#############################################################

@onready var nav_agent = $NavAgent

func _ready():
	nav_agent.path_desired_distance = 15
	nav_agent.target_desired_distance = 15
	
	$CharacterSkeleton.generate_character()
##

func set_target(target_position):
	nav_agent.target_position = target_position
##

func _physics_process(delta):
	velocity = _get_velocity()
	move_and_slide()
##

func _get_velocity():
	if nav_agent.is_navigation_finished():
		return Vector2.ZERO
	##

	return global_position.direction_to(nav_agent.get_next_path_position()) * MOVEMENT_SPEED
##
