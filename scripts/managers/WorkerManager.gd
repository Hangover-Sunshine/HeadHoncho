extends Node2D
class_name WorkerManager

@export var PLAYER_INFORMATION_UI:Control
@export var WORKER_SEATS:Node
@export var MAX_DICKHEADS_PER:int = 3
@export var quitTotalPerQuota = 10

####################################################

@onready var worker = load("res://prefabs/worker.tscn")
@onready var explosion = load("res://prefabs/fx/explosion.tscn")

@onready var audio_player = $AudioStreamPlayer2D

var sounds = {
	"explosion":load("res://assets/sound/sfx/SFX_Explosion.wav")
}

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
	
	WORKER_SEATS.get_child(0).player_can_interact(false)
	WORKER_SEATS.get_child(1).player_can_interact(false)
	
	for seat in WORKER_SEATS.get_children():
		seat.hide_icon()
	##
	
	PLAYER_INFORMATION_UI.set_workers_quit(0)
	
	SignalBus.connect("dickhead_gone", _dickhead_gone)
	
	SignalBus.connect("worker_quit", _worker_quit)
	SignalBus.connect("is_money_bags", _is_money_bags)
	SignalBus.connect("not_money_bags", _not_money_bags)
	SignalBus.connect("hire_worker", spawn_worker_at)
	SignalBus.connect("round_start", _round_start)
##

func _round_start(_startInfo):
	for dh in range(16):
		if workers[dh] != null:
			workers[dh].reset_worker()
		dickheads_per_worker[dh] = 0
	##
	total_workers_quit = 0
	PLAYER_INFORMATION_UI.set_workers_quit(total_workers_quit)
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

func spawn_worker_at(area):
	var index: int = -1
	for ci in range(len(WORKER_SEATS.get_children())):
		if WORKER_SEATS.get_children()[ci] == area:
			index = ci
		##
	##
	
	var wrk_inst:Worker = worker.instantiate()
	add_child(wrk_inst)
	
	var seat = WORKER_SEATS.get_child(index)
	seat.player_can_interact(false)
	
	wrk_inst.global_position = seat.global_position
	
	workers[index] = wrk_inst
	
	if (index >= 0 and index <= 3) or (index >= 8 and index <= 11):
		wrk_inst.z_index = 20
	elif index >= 4 and index <= 7 or (index >= 12 and index <= 15):
		wrk_inst.z_index = 5
	##
##

func get_num_of_workers():
	var count:int = 0
	
	for i in range(16):
		if workers[i] != null:
			count += 1
		##
	##
	
	return count
##

func _worker_quit(worker:Worker):
	var indx = workers.find(worker)
	workers[indx] = null
	dickheads_per_worker[indx] = 0
	
	WORKER_SEATS.get_child(indx).player_can_interact(true)
	
	worker.queue_free()
	
	var expl_inst = explosion.instantiate()
	get_parent().add_child(expl_inst)
	expl_inst.global_position = WORKER_SEATS.get_child(indx).global_position
	expl_inst.emit()
	
	audio_player.stream = sounds["explosion"]
	audio_player.play()
	
	total_workers_quit += 1
	
	PLAYER_INFORMATION_UI.set_workers_quit(total_workers_quit)
	
	if total_workers_quit >= quitTotalPerQuota:
		SignalBus.emit_signal("too_many_workers_quit")
	##
##

func _dickhead_gone(worker:Worker):
	var indx = workers.find(worker)
	dickheads_per_worker[indx] -= 1
	worker.boss_gone()
##

func _is_money_bags():
	for seat in WORKER_SEATS.get_children():
		seat.show_icon()
	##
##

func _not_money_bags():
	for seat in WORKER_SEATS.get_children():
		seat.hide_icon()
	##
##
