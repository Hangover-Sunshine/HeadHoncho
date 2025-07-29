extends State

@export var StressAreaCollider:CollisionShape2D

func enter_state(_prev_state:State):
	StressAreaCollider.disabled = true
##
