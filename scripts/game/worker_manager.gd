extends Node

signal worker_quit(open_seat:int)

const WORKER = preload("res://prefabs/entities/worker.tscn")

@export var MaxNumberWorkers:int = 16

# All current workers in the scene
var workers:Array = []
# Open workers
var not_pestered_workers:Array[int] = []

func _ready():
	var id = 0
	for child in %WorkerRepository.get_children():
		if child is Worker:
			child.worker_quits.connect(_worker_quits)
			workers.append(child)
			not_pestered_workers.push_back(id)
			id += 1
		##
	##
	
	for i in range(MaxNumberWorkers - len(workers)):
		workers.append(null)
	##
##

func create_worker(seatID:int, sitting_position:Vector2):
	var newWorker = WORKER.instantiate()
	self.add_child(newWorker)
	newWorker.worker_quits.connect(_worker_quits)
	newWorker.global_position = sitting_position
	workers[seatID] = newWorker
	not_pestered_workers.push_back(seatID)
##

func worker_unpestered(worker:int):
	not_pestered_workers.push_back(worker)
##

func get_rand_unpestered_worker():
	var rindx:int = randi() % len(not_pestered_workers)
	var worker:int = not_pestered_workers[rindx]
	not_pestered_workers.remove_at(rindx)
	return worker
##

func _worker_quits(worker:Worker):
	var index = workers.find(worker)
	workers[index] = null
	
	# Renable the seat for the player to hire a new motor
	worker_quit.emit(index)
	var indx = not_pestered_workers.find(index)
	if indx > -1:
		not_pestered_workers.remove_at(indx)
	##
##
