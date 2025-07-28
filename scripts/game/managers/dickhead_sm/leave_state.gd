extends State
class_name LeaveState
# Waiting by the elevator to be whisked away.

var dickhead:Dickhead

func enter_state(_prev_state:State):
	dickhead.emit_signal("awaiting_leaving", dickhead)
##

func exit_state():
	dickhead.emit_signal("not_awaiting_anymore", dickhead)
##
