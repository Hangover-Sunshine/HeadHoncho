extends CPUParticles2D

func aoe_heal_setup():
	amount = 100
	direction = Vector2(0, -1)
	initial_velocity_min = 200
	initial_velocity_max = 500
##

func buy_worker_setup():
	amount = 30
	direction = Vector2(0, -1)
	spread = 90
	initial_velocity_min = 200
	initial_velocity_max = 400
##

func emit():
	emitting = true
##
