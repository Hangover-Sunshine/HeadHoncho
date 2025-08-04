extends State
class_name GetBlownState

@export var DRAG:float = 200.0
@export var DragDelay:float = 0.05

var manager:Manager
var velocity:Vector2
var curr_drag:float

var _curr_delay:float = 0

func enter_state(_prev_state:State):
	curr_drag = 0
##

func physics_process(delta):
	_curr_delay += delta
	if _curr_delay >= DragDelay:
		curr_drag += 0.005
		curr_drag = clampf(curr_drag, 0, DRAG)
		velocity /= 1 + curr_drag
		_curr_delay = 0
	##
	
	if velocity.length_squared() < 50:
		manager.stop_burning()
	##
##
