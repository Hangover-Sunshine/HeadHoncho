extends Node2D

signal round_over(profit:float)

const WORKER = preload("res://prefabs/entities/worker.tscn")

@export var TimePerRound:float = 180
@export var TimePerTick:float = 1.5

# Add to this with every tick
var revenue:float = 0

# Add to this with: hiring, bonuses, pizza parties
var costs:float = 0

# All current workers in the scene
var workers:Array = []
# All current seats in the scene
var seats:Array[Seat] = []

func _ready():
	%TickTimer.start()
	#$GameplayTimer.start()
	
	# Get all the seats.
	for child in $Seats.get_children():
		seats.push_back(child)
	##
	
	var id = 0
	for child in get_children():
		if child is Worker:
			child.worker_quits.connect(_worker_quits)
			workers.append(child)
			seats[id].disable_seat()
			id += 1
		##
	##
	
	for i in range($Seats.get_child_count() - len(workers)):
		workers.append(null)
	##
##

func _on_gameplay_timer_timeout():
	%TickTimer.stop()
	print("Round over!")
##

func _on_tick_timer_timeout():
	print("Tick!")
	
	var affected = %Player.get_affecting_body()
	var head = %Player.get_current_head()
	
	# TODO: Dickhead management first
	
	# Get the amount of money being generated
	for worker in workers:
		if worker == null or worker.is_quitting():
			continue
		##
		revenue += worker.get_current_contribution()
		if worker == affected:
			if head == Player.PlayerHead.COFFEE:
				worker.increase_energy(%Player.EnergyIncreasePerTick)
			elif head == Player.PlayerHead.FAN:
				worker.cooloff(%Player.EnergyDecreasePerTick)
			##
		##
		worker.change_energy()
	##
	
	if affected is Seat and head == Player.PlayerHead.BRIEF_CASE:
		var seatID:int = seats.find(affected)
		if seats[seatID].IsOpen:
			var newWorker = WORKER.instantiate()
			add_child(newWorker)
			newWorker.worker_quits.connect(_worker_quits)
			newWorker.global_position = seats[seatID].global_position
			workers[seatID] = newWorker
			seats[seatID].disable_seat()
		##
	##
	
	%TickTimer.start(TimePerTick)
##

func _worker_quits(worker:Worker):
	var index = workers.find(worker)
	workers[index] = null
	
	# Renable the seat for the player to hire a new motor
	seats[index].enable_seat()
##
