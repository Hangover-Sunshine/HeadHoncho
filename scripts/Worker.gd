extends Node2D
class_name Worker

@export_group("Temperature")
@export var startingTemp:int = 0
@export var defaultTempIncrease:int = 1

@export_group("Energy")
@export var startingEnergy:int = 50
@export var defaultEnergyDecrease:int = 1
@export var energyShieldTickCount:int = 5

@export_group("Stress")
@export var startingStress:int = 0
@export var maxStressToQuit:int = 100
@export var ticksUntilStressIncrease:int = 6

@export_group("General Stats")
@export var defaultMoney:int = 100

# 0 -- 1 -- 2
var curr_energy:int
var ticks_since_last_cash:int
var money_rate:int

var workLifeBalance:float = 1.0
var givePlayerMoneyTickCounter:int = 0

var currTemp:int
var currStress:int

var energy_shield:bool = false
var ticksSinceShieldStarted:int = 0
var ticksSinceOverstressed:int = 0

func _ready():
	currTemp = startingTemp
	curr_energy = startingEnergy
	currStress = startingStress
	
	get_parent().connect("tick_update", tick_update_receiver)
##

func _input(event):
	if event.is_action_pressed("head_interaction"):
		curr_energy += 20
		energy_shield = true
		ticksSinceShieldStarted = 0
		
		if curr_energy > 100:
			curr_energy = 100
		##
		
		workLifeBalance = curr_energy / 100.0 * 2
	##
##

func get_money_gen_rate() -> int:
	var rate:int = 4
	
	if curr_energy >= 0 and curr_energy < 10:
		rate = 0
	elif curr_energy >= 10 and curr_energy < 25:
		rate = 6
	elif curr_energy >= 25 and curr_energy < 40:
		rate = 5
	elif curr_energy >= 61 and curr_energy < 75:
		rate = 3
	elif curr_energy >= 75:
		rate = 2
	##
	
	return rate
##

func tick_update_receiver():
	ticks_since_last_cash += 1
	
	# give the player money
	if money_rate > 0 and ticks_since_last_cash >= money_rate:
		ticks_since_last_cash = 0
		SignalBus.emit_signal("give_player_money", floor(defaultMoney))
	##
	
	if energy_shield == false and curr_energy > 0:
		curr_energy -= defaultEnergyDecrease
		money_rate = get_money_gen_rate()
	##
	
	print("curr energy:", curr_energy)
	
	print("---")
##

