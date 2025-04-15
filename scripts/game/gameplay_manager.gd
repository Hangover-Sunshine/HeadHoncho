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
	
	# Get the amount of money being generated
	for worker in workers:
		revenue += worker.get_current_contribution()
		if worker == affected:
			worker.increase_energy(%Player.EnergyIncreasePerTick)
		##
		worker.change_energy()
	##
	
	print(revenue)
	
	%TickTimer.start(TimePerTick)
##
