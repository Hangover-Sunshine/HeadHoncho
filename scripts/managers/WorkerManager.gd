extends Node2D
class_name WorkerManager

@export var WORKER_SEATS:Node
@export var MAX_DICKHEADS_PER:int = 3
@export var quitFailPercent:float = 0.6

####################################################

@onready var worker = load("res://prefabs/worker.tscn")

var total_qrtr_workers:int = 0
var total_workers_quit:int = 0

# key = id, val = [WorkerObject, num_dickheads] 
var workers = []
var dickheads_per_worker = []

func _ready():
	for i in range(16):
		workers.append(null)
		dickheads_per_worker.append(0)
	##
	
	# pre-load
	workers[0] = $Worker
	workers[1] = $Worker2
	
	total_qrtr_workers = 2
	
	SignalBus.connect("dickhead_gone", _dickhead_gone)
	SignalBus.connect("worker_quit", _worker_quit)
##

func select_worker():
	# Select a worker at random...
	var filled_list = []
	for i in workers:
		if i != null and dickheads_per_worker[workers.find(i)] < MAX_DICKHEADS_PER:
			filled_list.append(i)
		##
	##
	
	if len(filled_list) == 0:
		return null
	##
	
	var worker = Utility.choose(filled_list)[0]
	dickheads_per_worker[workers.find(worker)] += 1
	
	return worker
##

func spawn_worker():
	var index:int = -1
	for i in range(len(workers)):
		if workers[i] == null:
			index = i
			break
		##
	##
	
	if index == -1:
		return
	##
	
	var wrk_inst:Worker = worker.instantiate()
	add_child(wrk_inst)
	
	var seat = WORKER_SEATS.get_child(index)
	wrk_inst.global_position = seat.global_position
	
	wrk_inst.generate_character()
	
	workers[index] = wrk_inst
	
	if (index >= 0 and index <= 3) or (index >= 8 and index <= 11):
		wrk_inst.z_index = 20
	elif index >= 4 and index <= 7 or (index >= 12 and index <= 15):
		wrk_inst.z_index = 5
	##
##

func _round_start():
	total_qrtr_workers = get_child_count()
	total_workers_quit = 0
##

func _worker_quit(worker:Worker):
	var indx = workers.find(worker)
	workers.remove_at(indx)
	
	total_workers_quit += 1
	
	if total_workers_quit / total_qrtr_workers >= quitFailPercent:
		SignalBus.emit_signal("too_many_workers_quit")
	##
##

func _dickhead_gone(_means:SignalBus.WhyDickheadLeft, worker:Worker):
	var indx = workers.find(worker)
	dickheads_per_worker[indx] -= 1
##
