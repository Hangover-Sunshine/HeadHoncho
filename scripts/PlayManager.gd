extends Node2D

@export var tickUpdateTimer:float = 0.5
@export var quarterTimer:float = 60
@export var quitFailPercent:float = 0.6
@export var dickheadTimerMinMax:Vector2 = Vector2(1, 8)

############################################

@onready var dickhead = load("res://prefabs/dickhead.tscn")
@onready var tickTimer = $Timers/TickUpdateTimer
@onready var dickhead_timer = $Timers/DickheadTimer

var quarterlyMoneyCounter:int = 0

var total_qrtr_workers:int = 0
var total_workers_quit:int = 0

var workers = []
var boss_per_worker = []
var dickheads_out:int = 0

func _ready():
	tickTimer.start(tickUpdateTimer)
	SignalBus.connect("give_player_money", _give_player_money_receiver)
	SignalBus.connect("worker_quit", _worker_quit)
	
	for i in range(16):
		workers.append(null)
		boss_per_worker.append(0)
	##
	
	# pre-load
	workers[0] = $Workers/Worker
	workers[1] = $Workers/Worker2
	
	total_qrtr_workers = 2
##

func _on_tick_update_timer_timeout():
	tickTimer.start(tickUpdateTimer)
	SignalBus.emit_signal("tick_update")
##

func _give_player_money_receiver(money:int):
	#quarterlyMoneyCounter += money
	pass
##

func _on_quarter_timer_timeout():
	pass # Replace with function body.
##

func _worker_quit():
	total_workers_quit += 1
	
	# if this worker quiting exceeds the threshold, fail the player
	#if total_workers_quit / total_qrtr_workers > quitFailPercent:
		#pass
	##
##

func _on_dickhead_timer_timeout():
	var dh_inst:Dickhead = dickhead.instantiate()
	add_child(dh_inst)
	
	# Select a worker at random...
	var filled_list = []
	for i in workers:
		if i != null and boss_per_worker[workers.find(i)] < 3:
			filled_list.append(i)
		##
	##
	
	var worker = Utility.choose(filled_list)[0]
	boss_per_worker[workers.find(worker)] += 1
	
	dh_inst.set_target(worker)
##
