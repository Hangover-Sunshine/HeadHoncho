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
	pass
##

func _on_gameplay_timer_timeout():
	print("Round over!")
##

func _on_tick_timer_timeout():
	print("Tick!")
	
	# Get the amount of money being generated
	for worker in workers:
		pass
	##
	
	%TickTimer.start(TimePerTick)
##
