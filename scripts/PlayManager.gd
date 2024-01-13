extends Node2D

signal tick_update

@export var tickUpdateTimer:float = 0.5
@export var quarterTimer:float = 60

@onready var tickTimer = $TickUpdateTimer

var quarterlyMoneyCounter:int = 0

func _ready():
	tickTimer.start(tickUpdateTimer)
	SignalBus.connect("give_player_money", _give_player_money_receiver)
##

func _on_tick_update_timer_timeout():
	tickTimer.start(tickUpdateTimer)
	emit_signal("tick_update")
##

func _give_player_money_receiver(money:int):
	quarterlyMoneyCounter += money
	print("MONEY:", quarterlyMoneyCounter)
##

func _on_quarter_timer_timeout():
	pass # Replace with function body.
##
