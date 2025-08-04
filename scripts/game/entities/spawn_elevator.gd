extends Node2D

signal manager_created(manager:Manager)

const MANAGER = preload("res://prefabs/entities/manager.tscn")

@export var ManagerSpawnDelay:int = 6
@export var ManagerSpawnDelayMin:int = 4
@export var ManagerSpawnDelayMax:int = 6

var enable_spawning:bool = true

var _door_open:bool = false
var _num_of_ticks:int = 0

func _ready():
	_num_of_ticks = ManagerSpawnDelay
##

func open_door():
	if _num_of_ticks > 0:
		_num_of_ticks -= 1
		return
	##
	
	_num_of_ticks = randi_range(ManagerSpawnDelayMin, ManagerSpawnDelayMax)
	
	if enable_spawning == false:
		return
	##
	
	_door_open = true
	$Elevator.open()
	$DoorControlTimer.start(0.12)
##

func _on_door_control_timer_timeout():
	if _door_open:
		_door_open = false
		var manager = MANAGER.instantiate()
		manager.global_position = $SpawnPos.global_position
		emit_signal("manager_created", manager)
		$DoorControlTimer.start(0.15)
	else:
		$Elevator.close()
	##
##

func get_elevator_wait_pos():
	var basePos = $SpawnPos.global_position
	basePos.x += randf_range(-10, 10)
	basePos.y += randf_range(-5, 5)
	return basePos
##
