extends State
class_name PesterState

@export var StressArea:CollisionShape2D

func enter_state(_prev_state:State):
	StressArea.disabled = false
##

func exit_state():
	StressArea.disabled = true
##
