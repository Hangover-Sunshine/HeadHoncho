extends Node2D
class_name DickheadManager

@export var WORKER_MANAGER:WorkerManager
@export var BURNING_NODES:Node2D

##########################################################################

@onready var dickhead = load("res://prefabs/dickhead.tscn")

var dickheads_killed:int = 0
var dickheads_satisified:int = 0
var dickheads_removed:int = 0

var positions:Array[Vector2]

func _ready():
	SignalBus.connect("dickhead_left", _dickhead_left)
	SignalBus.connect("dickhead_removed", _dickhead_removed)
	SignalBus.connect("dickhead_died", _dickhead_died)
	SignalBus.connect("round_start", _round_start)
	
	var children = BURNING_NODES.get_children()
	
	for child in children:
		positions.append(child.global_position)
	##
##

func _round_start(_startInfo):
	for child in get_children():
		child.queue_free()
	##
##

func spawn_dickhead():
	var worker = WORKER_MANAGER.select_worker()
	
	if worker == null:
		return
	##
	
	var dh_inst:Dickhead = dickhead.instantiate()
	add_child(dh_inst)
	dh_inst.set_target(worker)
##

func _dickhead_left():
	dickheads_satisified += 1
##

func _dickhead_died():
	dickheads_killed += 1
##

func _dickhead_removed():
	dickheads_removed += 1
##

func pick_position() -> Vector2:
	return positions[randi() % len(positions)]
##
