extends State
class_name LeaveState
# Waiting by the elevator to be whisked away.

var manager:Manager

func enter_state(_prev_state:State):
	manager.emit_signal("awaiting_leaving", manager)
##

func exit_state():
	manager.emit_signal("not_awaiting_anymore", manager)
##
