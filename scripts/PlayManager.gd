extends Node2D

@export_group("Timer Control")
@export var SECONDS_PER_TICK:float = 0.5
@export var SECONDS_PER_ROUND:float = 60

@export_group("Dickhead Control")
@export var dickheadTimerMinMax:Vector2 = Vector2(1, 8)

@export_group("Costs")
@export var AOE_HEAL_COST:int = 700
@export var WORKER_COST:int = 400

############################################

@onready var tick_timer = $Timers/TickUpdateTimer
@onready var dickhead_timer = $Timers/DickheadTimer
@onready var quarter_timer = $Timers/QuarterTimer

var quota:int = 4000
var quarterlyMoneyCounter:int = 0
var appreciation:int = 100
var broken_window_count:int = 0

func _ready():
	SignalBus.connect("give_player_money", _give_player_money_receiver)
	SignalBus.connect("round_start", _round_start)
	SignalBus.connect("aoe_heal", _aoe_heal)
	SignalBus.connect("window_broken", _window_broken)
	
	tick_timer.start(SECONDS_PER_TICK)
	quarter_timer.start(SECONDS_PER_ROUND)
##

func _on_tick_update_timer_timeout():
	SignalBus.emit_signal("tick_update")
	tick_timer.start(SECONDS_PER_TICK)
##

func _give_player_money_receiver(money:int):
	quarterlyMoneyCounter += money
##

func _aoe_heal(_amount:int):
	var count:int = $WorkerManager.get_num_of_workers()
	
	quarterlyMoneyCounter -= 600 + AOE_HEAL_COST * count
##

func _on_quarter_timer_timeout():
	stop_all_timers()
	
	var results = SignalBus.roundResults.duplicate()
	
	results["money"] = quarterlyMoneyCounter
	results["quota"] = quota
	results["appreciation"] = appreciation
	results["broken_windows"] = broken_window_count
	results["worker_cost"] = WORKER_COST
	results["dickheads_killed"] = $DickheadManager.dickheads_killed
	results["dickheads_satisfied"] = $DickheadManager.dickheads_satisified
	results["dickheads_removed"] = $DickheadManager.dickheads_removed
	results["employees_quit"] = $WorkerManager.total_workers_quit
	
	get_tree().paused = true
	SignalBus.emit_signal("round_over", results)
##

func _window_broken():
	broken_window_count += 1
##

func _round_start(starting:Dictionary):
	broken_window_count = 0
	$DickheadManager.dickheads_killed = 0
	$DickheadManager.dickheads_satisified = 0
	$DickheadManager.dickheads_removed = 0
	$WorkerManager.total_workers_quit = 0
	
	quarterlyMoneyCounter = 0
	quota = starting["quota"]
	appreciation = starting["appreciation"]
	
	tick_timer.start(SECONDS_PER_TICK)
	quarter_timer.start(SECONDS_PER_ROUND)
##

func stop_all_timers():
	quarter_timer.stop()
	tick_timer.stop()
	dickhead_timer.stop()
##

func unpause_all_timers():
	quarter_timer.paused = false
	tick_timer.paused = false
	dickhead_timer.paused = false
##

func pause_all_timers():
	quarter_timer.paused = true
	tick_timer.paused = true
	dickhead_timer.paused = true
##

func _on_dickhead_timer_timeout():
	$DickheadManager.spawn_dickhead()
##
