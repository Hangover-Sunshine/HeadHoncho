extends State
class_name WalkState

@export var WalkSpeed:float = 75

@export var Idle_State:State
@export var Pester_State:State

var nav_agent:NavigationAgent2D
var velocity:Vector2

var is_leaving:bool = false

func exit_state():
	velocity = Vector2.ZERO
##

func physics_process(_delta):
	velocity = Vector2.ZERO
	
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		return
	##
	
	if nav_agent.is_navigation_finished():
		if is_leaving:
			get_parent().change_state(Idle_State)
		else:
			get_parent().change_state(Pester_State)
		##
		return
	##
	
	velocity = get_parent().get_parent()\
				.global_position.direction_to(nav_agent.get_next_path_position()) * WalkSpeed
##

func set_navigation_target(pos):
	nav_agent.target_position = pos
##
