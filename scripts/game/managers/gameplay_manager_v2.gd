extends Node2D

signal round_over(profit:float)

const WORKER = preload("res://prefabs/entities/worker.tscn")

@export var TimePerRound:float = 180
@export var TimePerTick:float = 1.5

# Add to this with every tick
var revenue:float = 0

# Add to this with: hiring, bonuses, pizza parties
var costs:float = 0

# All current dickheads in the scene
var dickheads:Array = []
# All current workers in the scene
var workers:Array = []
# All current seats in the scene
var seats:Array[Seat] = []
# Open workers
var open_seats:Array[int] = []
# Pot to leave
var waiting_to_leave:Array[Dickhead]

var elevator_called:bool = false

func _ready():
	%TickTimer.start()
	#$GameplayTimer.start()
	
	# Get all the seats.
	for child in $Seats.get_children():
		seats.push_back(child)
	##
	
	var id = 0
	for child in %WorkerRepository.get_children():
		if child is Worker:
			child.worker_quits.connect(_worker_quits)
			workers.append(child)
			seats[id].disable_seat()
			open_seats.push_back(id)
			id += 1
		##
	##
	
	for i in range($Seats.get_child_count() - len(workers)):
		workers.append(null)
	##
	
	$Elevator.connect("dickhead_created", _dickhead_created)
	$Elevator2.connect("elevator_door_open", _dickheads_leave)
##

func _on_gameplay_timer_timeout():
	%TickTimer.stop()
	print("Round over!")
##

func _on_tick_timer_timeout():
	print("Tick!")
	
	#var affected = %Player.get_affecting_body()
	var aff_seats = %Player.get_affected_seats()
	var aff_bodies = %Player.get_affected_bodies()
	var head = %Player.get_current_head()
	
	# Only attempt to spawn if we have it open
	if len(open_seats) > 0:
		$Elevator.open_door()
	##
	
	if len(waiting_to_leave) > 0:
		elevator_called = true
	##
	
	if elevator_called:
		$Elevator2.open_door()
		elevator_called = false
	##
	
	for dickhead in dickheads:
		if dickhead in aff_bodies:
			if head == Player.PlayerHead.COFFEE:
				#dickhead.stop_moving()
				#dickhead.run_burn(_get_random_position(dickhead.global_position))
				print("burn!")
			elif head == Player.PlayerHead.FAN:
				print("blow!") # blow 'em
			else:
				print("convince!") # convince them to leave nicely
			##
		##
	##
	
	# Get the amount of money being generated
	for worker in workers:
		if worker == null or worker.is_quitting():
			continue
		##
		revenue += worker.get_current_contribution()
		if worker in aff_bodies:
			if head == Player.PlayerHead.COFFEE:
				worker.increase_energy(%Player.EnergyIncreasePerTick)
			elif head == Player.PlayerHead.FAN:
				worker.cooloff(%Player.EnergyDecreasePerTick)
			##
		##
		worker.change_energy()
	##
	
	if head == Player.PlayerHead.BRIEF_CASE:
		for afs in aff_seats:
			var seatID:int = seats.find(afs)
			if seats[seatID].IsOpen:
				var newWorker = WORKER.instantiate()
				%WorkerRepository.add_child(newWorker)
				newWorker.worker_quits.connect(_worker_quits)
				newWorker.global_position = afs.global_position
				workers[seatID] = newWorker
				open_seats.push_back(seatID)
				afs.disable_seat()
			##
		##
	##
	
	%TickTimer.start(TimePerTick)
##

func _worker_quits(worker:Worker):
	var index = workers.find(worker)
	workers[index] = null
	
	# Renable the seat for the player to hire a new motor
	seats[index].enable_seat()
	var indx = open_seats.find(index)
	if indx > -1:
		open_seats.remove_at(indx)
	##
##

func _dickhead_created(dickhead):
	%DickheadSuppository.add_child(dickhead)
	dickhead.connect("awaiting_leaving", add_dickhead)
	dickhead.connect("not_awaiting_anymore", remove_dickhead)
	var rindx:int = randi() % len(open_seats)
	dickhead.go_to_elevator.connect(_exit_level)
	dickhead.set_goal_position(seats[open_seats[rindx]].get_standing_pos())
	open_seats.remove_at(rindx)
	dickheads.append(dickhead)
##

func _exit_level(dickhead:Dickhead):
	dickhead.set_goal_position($Elevator2.get_elevator_wait_pos())
##

func _get_random_position(old_pos:Vector2):
	var new_pos = NavigationServer2D.region_get_random_point(
															$NavigationRegion2D.get_rid(),
															1, false)
	
	while old_pos.distance_to(new_pos) < 10:
		new_pos = NavigationServer2D.region_get_random_point(
															$NavigationRegion2D.get_rid(),
															1, false)
	##
	
	return new_pos
##

func add_dickhead(dickhead:Dickhead):
	waiting_to_leave.push_back(dickhead)
	elevator_called = true
##

func remove_dickhead(dickhead:Dickhead):
	var id = waiting_to_leave.find(dickhead)
	waiting_to_leave.remove_at(id)
##

func _dickheads_leave():
	var ids_to_clean:Array[int] = []
	
	var then = Time.get_ticks_usec()
	
	while then - Time.get_ticks_usec() < 0.18 and len(waiting_to_leave) > 0:
		var rand_amnt = randi_range(1, 2) if len(waiting_to_leave) > 2 else 1
		
		for i in range(rand_amnt):
			var picked = waiting_to_leave.pick_random()
			
			dickheads.remove_at(dickheads.find(picked))
			waiting_to_leave.remove_at(waiting_to_leave.find(picked))
			picked.queue_free()
		##
		
		await get_tree().create_timer(0.08).timeout
	##
##
