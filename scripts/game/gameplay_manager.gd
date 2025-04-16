extends Node2D

signal round_over(profit:float)

@export var TimePerRound:float = 180
@export var TimePerTick:float = 1.5

# Add to this with every tick
var revenue:float = 0

# Add to this with: hiring, bonuses, pizza parties
var costs:float = 0

# All current workers in the scene
var workers:Array = []

func _ready():
	%TickTimer.start()
	#$GameplayTimer.start()
	
	# TODO: Not this
	for child in get_children():
		if child is Worker:
			workers.append(child)
		##
	##
	pass
##

func _on_gameplay_timer_timeout():
	%TickTimer.stop()
	print("Round over!")
##

func _on_tick_timer_timeout():
	print("Tick!")
	
	var affected = %Player.get_affecting_body()
	var head = %Player.get_current_head()
	
	# Get the amount of money being generated
	for worker in workers:
		if worker.is_quitting():
			continue
		##
		revenue += worker.get_current_contribution()
		if worker == affected:
			if head == 0:
				worker.increase_energy(%Player.EnergyIncreasePerTick)
			elif head == 1:
				worker.cooloff(%Player.EnergyDecreasePerTick)
			##
		##
		worker.change_energy()
	##
	
	%TickTimer.start(TimePerTick)
##

func _worker_quits(worker:Worker):
	# TODO: play death anim
	worker.queue_free()
	
	# 1) Remove the worker
	var index = workers.find(worker)
	workers.remove_at(index)
	
	# 2) Reopen the seat
##
