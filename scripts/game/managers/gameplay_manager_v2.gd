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

var elevator_called:bool = false

func _ready():
	%TickTimer.start()
	#$GameplayTimer.start()
	
	$Elevator.connect("manager_created", manager_created)
	$Elevator2.connect("elevator_door_open", %ManagerRepository.managers_leave)
	
	%Player.connect("player_is_falling", _player_is_falling)
	%Player.connect("player_dead", _player_dead)
##

func _process(_delta):
	var aff_bodies = %Player.get_affected_bodies()
	if len(aff_bodies) > 0:
		for body in aff_bodies:
			if body in %ManagerRepository.managers and body.is_doing_nothing() == false\
				and body.leaving_opinion == 0:
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
	
	var aff_seats = %Player.get_affected_seats()
	var aff_bodies = %Player.get_affected_bodies()
	var head = %Player.get_current_head()
	
	# Only attempt to spawn if we have it open
	if len(%WorkerRepository.not_pestered_workers) > 0:
		$Elevator.open_door()
	##
	
	if len(%ManagerRepository.waiting_to_leave) > 0:
		elevator_called = true
	##
	
	if elevator_called:
		$Elevator2.open_door()
		elevator_called = false
	##
	
	for manager in %ManagerRepository.managers:
		if manager == null:
			continue # ignore, we need to clean up
		##
		
		if manager in aff_bodies:
			if head == Player.PlayerHead.COFFEE:
				var new_pos = %ManagerRepository.get_random_position(manager.global_position)
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
				%ManagerRepository.exit_level(manager)
				manager.leaving_opinion = LeaveAfterGoodThing
			##
			
			if manager.selected_worker > 0:
				%WorkerRepository.worker_unpestered(manager.selected_worker)
				manager.selected_worker = -1
			##
		##
		
		if manager.is_doing_nothing() and manager not in aff_bodies:
			manager.revert()
		##
	##
	
	# Get the amount of money being generated
	for worker in %WorkerRepository.workers:
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
			var seatID:int = %Seats.get_seat_id(afs)
			if %Seats.is_seat_available_id(seatID):
				%WorkerRepository.create_worker(seatID, afs.global_position)
				%Seats.disable_seat(seatID)
			##
		##
	##
	
	%TickTimer.start(TimePerTick)
##

func manager_created(manager):
	var rand_worker:int = %WorkerRepository.get_rand_unpestered_worker()
	$ManagerRepository.manager_created(manager,
										rand_worker,
										%Seats.get_standing_position(rand_worker)
									)
##

func _player_dead():
	pass
##

func _player_is_falling():
	%TickTimer.stop()
##
