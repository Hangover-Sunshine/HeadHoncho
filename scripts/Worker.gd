extends StaticBody2D
class_name Worker

@export_group("Temperature")
@export var startingTemp:int = 0
@export var defaultTempModification:int = 1
@export var maxTempurate:int = 100
@export var maxTempColor:Color = Color.ORANGE_RED

@export_group("Energy")
@export var startingEnergy:int = 50
@export var defaultEnergyDecrease:int = 1
@export var energyShieldTickCount:int = 5
@export var maxEnergy:int = 100
@export var minEnergyColor:Color = Color.BLUE_VIOLET

@export_group("Stress")
@export var startingStress:int = 0
@export var defaultStressIncrease:int = 1
@export var ticksUntilStressIncrease:int = 6
@export var maxStress:int = 100

@export_group("General Stats")
@export var defaultMoney:int = 100

var curr_energy:int
var energy_shield:bool = false
var shield_up_ticks:int = 0

var ticks_since_last_cash:int
var money_rate:int

var curr_temp:int
var temp_ticks:int
var temp_tick_rate:int
var temp_dir:int

var curr_stress:int
var stress_tick_rate:int
var stress_ticks:int

func _ready():
	curr_temp = startingTemp
	curr_energy = startingEnergy
	curr_stress = startingStress
	
	get_parent().connect("tick_update", tick_update_receiver)
	
	$CharacterSkeleton.generate_character()
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

func get_stress_rate() -> int:
	var rate:int = 0
	
	if curr_temp >= 25 and curr_temp < 50:
		rate = 4
	elif curr_temp >= 50 and curr_temp < 75:
		rate = 3
	elif curr_temp >= 75:
		rate = 2
	##
	
	return rate
##

func tick_update_receiver():
	ticks_since_last_cash += 1
	temp_ticks += 1
	
	# give the player money every so often :)
	if money_rate > 0 and ticks_since_last_cash >= money_rate:
		ticks_since_last_cash = 0
		SignalBus.emit_signal("give_player_money", floor(defaultMoney))
	##
	
	# Only modify energy while the caffeine shield is down
	if energy_shield == false and curr_energy > 0:
		curr_energy -= defaultEnergyDecrease
		money_rate = get_money_gen_rate()
	##
	
	# If our energy is over 60, it's time to start overheating...
	if curr_energy >= 75:
		temp_dir = 1
		temp_tick_rate = 2
	elif curr_energy > 60:
		temp_dir = 1
		temp_tick_rate = 4
	else:
		temp_dir = -1
		temp_tick_rate = 8
	##
	
	if temp_ticks >= temp_tick_rate:
		temp_ticks = 0
		curr_temp += defaultTempModification * temp_dir
		
		if curr_temp < 0:
			curr_temp = 0
		elif curr_temp > maxTempurate:
			curr_temp = maxTempurate
		##
	##
	
	if stress_tick_rate > 0:
		stress_ticks += 1
		
		if stress_ticks >= stress_tick_rate:
			curr_stress += 1
			stress_ticks = 0
		##
		
		if curr_stress >= maxStress:
			SignalBus.emit_signal("worker_quit")
			get_parent().disconnect("tick_update", tick_update_receiver)
			print("I QUIT MOTHERFUCKER!")
			# TODO: other things
			
			# BAIL! --> worker does nothing else and leaves
			return
		##
	##
	
	stress_tick_rate = get_stress_rate()
	
	# Shield tracker --> only enter if the worker has their shield active;
	#	otherwise, ignore the block
	if energy_shield:
		shield_up_ticks += 1
		
		if shield_up_ticks >= energyShieldTickCount:
			energy_shield = false
			shield_up_ticks = 0
		##
	##
##

func add_energy(energy:int):
	curr_energy += energy
	energy_shield = true
	shield_up_ticks = 0
	
	money_rate = get_money_gen_rate()
	
	if curr_energy > maxEnergy:
		curr_energy = maxEnergy
	##
##

func decrease_temp(temp:int):
	curr_temp -= temp
	
	if curr_temp < 0:
		curr_temp = 0
	##
##

func destress():
	curr_stress -= 1
	
	if curr_stress < 0:
		curr_stress = 0
	##
##
