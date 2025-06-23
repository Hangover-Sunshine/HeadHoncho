extends Node2D

signal dickhead_created(dickhead)

const DICKHEAD = preload("res://prefabs/entities/dickhead.tscn")

@export var DickheadSpawnDelay:int = 6
@export var DickheadSpawnDelayMin:int = 4
@export var DickheadSpawnDelayMax:int = 6

var enable_spawning:bool = true

var _door_open:bool = false
var _num_of_ticks:int = 0

func _ready():
	_num_of_ticks = DickheadSpawnDelay
##

func open_door():
	if _num_of_ticks > 0:
		_num_of_ticks -= 1
		return
	##
	
	_num_of_ticks = randi_range(DickheadSpawnDelayMin, DickheadSpawnDelayMax)
	
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
		var dickhead = DICKHEAD.instantiate()
		dickhead.global_position = $SpawnPos.global_position
		emit_signal("dickhead_created", dickhead)
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
