extends Node2D

signal round_over(profit:float)

const WORKER = preload("res://prefabs/entities/worker.tscn")

@export var TimePerRound:float = 180
@export var TimePerTick:float = 1.5

@export var LeaveAfterBadThing:float = -4
@export var FallOutWindow:float = -2
@export var LeaveAfterGoodThing:float = 2

# Add to this with every tick
var revenue:float = 0

# Add to this with: hiring, bonuses, pizza parties
var costs:float = 0

# All current managers in the scene
var managers:Array = []
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
	$Elevator2.connect("elevator_door_open", _managers_leave)
##

func _process(_delta):
	var aff_bodies = %Player.get_affected_bodies()
	if len(aff_bodies) > 0:
		for body in aff_bodies:
			if body in managers and body.is_doing_nothing() == false and body.leaving_opinion == 0:
				body.stop_doing_stuff()
			##
		##
	##
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
	
	for manager in managers:
		if manager == null:
			continue # ignore, we need to clean up
		##
		
		if manager in aff_bodies:
			if head == Player.PlayerHead.COFFEE:
				var new_pos = _get_random_position(manager.global_position)
				manager.run_burn(new_pos[0], new_pos[1] >= 0)
				manager.leaving_opinion = LeaveAfterBadThing
			elif head == Player.PlayerHead.FAN:
				var move = Vector2(
					1 * sign(
						%Player.global_position.
							direction_to(manager.global_position).normalized().x
						),
					0
				)
				
				manager.get_blown(
					move * %Player.BlowPower
				)
				
				manager.leaving_opinion = LeaveAfterBadThing
			else:
				_exit_level(manager)
				manager.leaving_opinion = LeaveAfterGoodThing
			##
			
			open_seats.append(manager.selected_worker)
		##
		
		if manager.is_doing_nothing() and manager not in aff_bodies:
			manager.revert()
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
			elif head == Player.PlayerHead.BRIEF_CASE:
				worker.payoff(%Player.TempDecreasePerTick)
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

func _dickhead_created(manager):
	%DickheadSuppository.add_child(manager)
	manager.connect("awaiting_leaving", add_dickhead)
	manager.connect("not_awaiting_anymore", remove_dickhead)
	manager.connect("needs_new_burning_point", _generate_new_point)
	var rindx:int = randi() % len(open_seats)
	manager.go_to_elevator.connect(_exit_level)
	manager.selected_worker = open_seats[rindx]
	manager.set_goal_position(seats[open_seats[rindx]].get_standing_pos())
	open_seats.remove_at(rindx)
	managers.append(manager)
##

func _exit_level(manager:Dickhead):
	manager.set_goal_position($Elevator2.get_elevator_wait_pos(), true)
##

func _get_random_position(old_pos:Vector2):
	var new_pos = NavigationServer2D.region_get_random_point(
					$OfficeSpace.get_rid(),
					1,
					false
	)
	
	var rand = randi() % 100
	var distances = [
		$FallingArea/Marker2D.global_position.distance_to(old_pos),
		$FallingArea/Marker2D2.global_position.distance_to(old_pos),
		$FallingArea/Marker2D3.global_position.distance_to(old_pos)
	]
	
	var shortest_dist = distances.min()
	var sdi = distances.find(shortest_dist)
	
	if shortest_dist < 250 and rand > 20:
		match sdi:
			0:
				new_pos = $FallingArea/Marker2D.global_position
			1:
				new_pos = $FallingArea/Marker2D2.global_position
			2:
				new_pos = $FallingArea/Marker2D3.global_position
			##
		##
	else:
		sdi = -1
		while old_pos.distance_to(new_pos) < 10:
			new_pos = NavigationServer2D.region_get_random_point(
						$OfficeSpace.get_rid(),
						1,
						false
			)
		##
	##
	
	return [new_pos, sdi]
##

func add_dickhead(manager:Dickhead):
	waiting_to_leave.push_back(manager)
	elevator_called = true
##

func remove_dickhead(manager:Dickhead):
	var id = waiting_to_leave.find(manager)
	waiting_to_leave.remove_at(id)
##

func _managers_leave():
	var ids_to_clean:Array[int] = []
	
	var then = Time.get_ticks_usec()
	
	while then - Time.get_ticks_usec() < 0.18 and len(waiting_to_leave) > 0:
		var rand_amnt = randi_range(1, 2) if len(waiting_to_leave) > 2 else 1
		
		for i in range(rand_amnt):
			var picked = waiting_to_leave.pick_random()
			
			managers.remove_at(managers.find(picked))
			waiting_to_leave.remove_at(waiting_to_leave.find(picked))
			picked.queue_free()
		##
		
		await get_tree().create_timer(0.08).timeout
	##
##

func _generate_new_point(manager:Dickhead):
	var new_pos = _get_random_position(manager.global_position)
	manager.run_burn(new_pos[0], new_pos[1] >= 0)
##
