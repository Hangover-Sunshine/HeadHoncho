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
	SignalBus.connect("dickhead_gone", _dickhead_gone)
	
	var children = BURNING_NODES.get_children()
	
	for child in children:
		positions.append(child.global_position)
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

func _dickhead_gone(means:SignalBus.WhyDickheadLeft, worker:Worker):
	if means == SignalBus.WhyDickheadLeft.ATTACKED:
		dickheads_removed += 1
	elif means == SignalBus.WhyDickheadLeft.LEFT:
		dickheads_satisified += 1
	else:
		dickheads_killed += 1
	##
##

func pick_position() -> Vector2:
	return positions[randi() % len(positions)]
##
