extends Node2D

@export_group("Timer Control")
@export var tickUpdateTimer:float = 0.5
@export var quarterTimer:float = 60

@export_group("Dickhead Control")
@export var dickheadTimerMinMax:Vector2 = Vector2(1, 8)

############################################

@onready var tickTimer = $Timers/TickUpdateTimer
@onready var dickhead_timer = $Timers/DickheadTimer
@onready var quarter_timer = $Timers/QuarterTimer

var quarterlyMoneyCounter:int = 0

func _ready():
	tickTimer.start(tickUpdateTimer)
	quarter_timer.start(quarterTimer)
	SignalBus.connect("give_player_money", _give_player_money_receiver)
##

func _input(event):
	if event.is_action_pressed("ui_right"):
		spawn_worker()
	##
	if event.is_action_pressed("ui_left"):
		_on_dickhead_timer_timeout()
	##
##

func _on_tick_update_timer_timeout():
	SignalBus.emit_signal("tick_update")
	tickTimer.start(tickUpdateTimer)
##

func _give_player_money_receiver(money:int):
	#quarterlyMoneyCounter += money
	pass
##

func _on_quarter_timer_timeout():
	stop_all_timers()
	$Player.can_be_controlled = false
##

func stop_all_timers():
	quarter_timer.stop()
	tickTimer.stop()
	dickhead_timer.stop()
##

func unpause_all_timers():
	quarter_timer.paused = false
	tickTimer.paused = false
	dickhead_timer.paused = false
##

func pause_all_timers():
	quarter_timer.paused = true
	tickTimer.paused = true
	dickhead_timer.paused = true
##

func spawn_worker():
	$WorkerManager.spawn_worker()
##

func _on_dickhead_timer_timeout():
	$DickheadManager.spawn_dickhead()
##
