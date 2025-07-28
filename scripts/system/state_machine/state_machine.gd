extends Node
class_name StateMachine

var _state_table = []
var _state_to_id:Dictionary[State, int] = {}

var _curr_state:State = null
var _prev_state:State = null

var CurrState:State :
	get:
		return _curr_state
	##
##

var PrevState:State :
	get:
		return _prev_state
	##
##

func add_state(state:State):
	_state_to_id[state] = len(_state_table)
	
	var edges = []
	for i in range(len(_state_table)):
		edges.append(null)
	##
	
	_state_table.append(edges)
	
	# Add in references to other states
	for i in range(len(_state_table)):
		_state_table[i].append(null)
	##
##

func add_edge(start:State, end:State, trans_func:Callable):
	var startID = _state_to_id[start]
	var endID = _state_to_id[end]
	
	_state_table[startID][endID] = trans_func
##

func remove_edge(start:State, end:State):
	var startID = _state_to_id[start]
	var endID = _state_to_id[end]
	
	_state_table[startID][endID] = null
##

func process_state(delta):
	_curr_state.process(delta)
##

func physics_process_state(delta):
	_curr_state.physics_process(delta)
##

func change_state(next_state:State):
	var trans = _state_table[_state_to_id[_curr_state]][_state_to_id[next_state]]
	
	# Do any cleanup
	_curr_state.exit_state()
	
	if trans != null:
		trans.call(_curr_state, next_state)
	##
	
	# Start the next state, giving the current state as input in case it needs
	#	to copy anything from before
	next_state.enter_state(_curr_state)
	
	# Set it all around
	_prev_state = _curr_state
	_curr_state = next_state
##
