extends State
class_name RunState

@export var RunSpeed:float = 150
@export var BurnTimerTime:float = 4.0

var manager:Dickhead
var nav_agent:NavigationAgent2D
var velocity:Vector2

var target:Vector2
var run_out:bool :
	set(val):
		run_out = val
		if val:
			$BurnTimer.stop()
		##
	##
##

func enter_state(_prev_state:State):
	run_out = false
	velocity = Vector2.ZERO
	$BurnTimer.start(BurnTimerTime)
##

func exit_state():
	velocity = Vector2.ZERO
##

func physics_process(delta):
	velocity = Vector2.ZERO
	
	if run_out == false:
		if manager.global_position.distance_to(nav_agent.target_position) < 10:
			manager.needs_new_burning_point.emit(manager)
		##
		
		if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
			return
		##
		
		if nav_agent.is_navigation_finished():
			return
		##
		
		velocity = get_parent().get_parent()\
					.global_position.direction_to(nav_agent.get_next_path_position()) * RunSpeed
	else:
		velocity = manager.global_position.direction_to(target).normalized() * RunSpeed
	##
##

func _on_burn_timer_timeout():
	manager.stop_burning()
##
