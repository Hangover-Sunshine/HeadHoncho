extends Node2D
class_name DickheadManager

@export var WORKER_MANAGER:WorkerManager
@export var BURNING_NODES:Node2D
@export var PLAYER:Player

##########################################################################

@onready var dickhead = load("res://prefabs/dickhead.tscn")
@onready var elevator = $"../StaticEnv/Elevator"

var dickheads_killed:int = 0
var dickheads_satisified:int = 0
var dickheads_removed:int = 0

var positions:Array[Vector2]

var queue_to_leave = []

func _ready():
	SignalBus.connect("dickhead_left", _dickhead_left)
	SignalBus.connect("dickhead_removed", _dickhead_removed)
	SignalBus.connect("dickhead_died", _dickhead_died)
	SignalBus.connect("round_start", _round_start)
	SignalBus.connect("request_new_target", _request_new_target)
	
	var children = BURNING_NODES.get_children()
	
	for child in children:
		positions.append(child.global_position)
	##
##

func _process(_delta):
	if elevator.is_playing() and elevator.is_open() and len(queue_to_leave) > 0:
		for dh in queue_to_leave:
			dh.queue_free()
		##
		queue_to_leave = []
	##
##

func _request_new_target(dickhead:Dickhead):
	var worker = WORKER_MANAGER.select_worker()
	
	# if no workers available, dickhead chuffed
	if worker == null:
		dickhead.set_disgruntled()
		return # stop
	##
	
	dickhead.set_target(worker)
##

func _round_start(_startInfo):
	for child in get_children():
		child.queue_free()
	##
	
	# clear the list so we don't try to free again
	queue_to_leave = []
##

func spawn_dickhead():
	elevator.play_anim()
	
	var worker = WORKER_MANAGER.select_worker()
	
	if worker == null:
		return
	##
	
	var dh_inst:Dickhead = dickhead.instantiate()
	add_child(dh_inst)
	dh_inst.player = PLAYER
	dh_inst.set_target(worker)
##

func _dickhead_left(dickhead:Dickhead):
	if elevator.is_playing():
		dickhead.queue_free()
	else:
		queue_to_leave.append(dickhead)
	##
	
	dickheads_satisified += 1
##

func _dickhead_died():
	dickheads_killed += 1
##

func _dickhead_removed(dickhead:Dickhead):
	if elevator.is_playing():
		dickhead.queue_free()
	else:
		queue_to_leave.append(dickhead)
	##
	
	dickheads_removed += 1
##

func pick_position() -> Vector2:
	return positions[randi() % len(positions)]
##
