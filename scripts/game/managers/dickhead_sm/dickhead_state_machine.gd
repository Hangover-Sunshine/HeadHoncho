extends StateMachine

func _ready():
	var states = get_children()
	
	for state in states:
		add_state(state)
	##
	
	_curr_state = $WalkState
##
