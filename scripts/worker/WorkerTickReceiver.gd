extends Node

##################################################

@onready var character_skeleton = $"../CharacterSkeleton"
@onready var money_processor:AbilityTickProcessor = $MoneyProcessor
@onready var shield_processor:AbilityTickProcessor = $ShieldProcessor
@onready var temperature_processor:AbilityTickProcessor = $TemperatureProcessor
@onready var stress_processor:AbilityTickProcessor = $StressProcessor

##################################################

var default_color:Color = Color.WHITE
var energy_color:Color = default_color
var temp_color:Color = default_color
var curr_color:Color = default_color

var curr_energy:int = 60
var energy_shield:bool = false

var curr_temp:int
var temp_dir:int

var curr_stress:int

var saved:bool = false
var saved_temp:int
var saved_energy:int
var bosses_nearby:int = 0
var increase_money:float = 0

#####################
var maxTempColor:Color
var minEnergyColor:Color

var maxTempurate:int
var maxStress:int
var energyShieldTickCount:int

var defaultMoney:int
var defaultEnergyDecrease:int
var defaultTempModification:int
var dickheadTempMod:float
######################

func _ready():
	defaultMoney = get_parent().defaultMoney
	defaultEnergyDecrease = get_parent().defaultEnergyDecrease
	defaultTempModification = get_parent().defaultTempModification
	dickheadTempMod = get_parent().dickheadTempMod
	maxTempurate = get_parent().maxTempurate
	maxStress = get_parent().maxStress
	energyShieldTickCount = get_parent().energyShieldTickCount
	
	maxTempColor = get_parent().maxTempColor
	minEnergyColor = get_parent().minEnergyColor
	
	SignalBus.connect("tick_update", tick_update_receiver)
##

func tick_update_receiver():
	# give the player money every so often :)
	if money_processor.get_max() > 0 and money_processor.tick():
		money_processor.reset_tick_count()
		SignalBus.emit_signal("give_player_money", floor(defaultMoney * (1.0 + increase_money)))
	elif money_processor.get_max() == 0:
		money_processor.reset_tick_count()
	##
	
	# Only modify energy while the caffeine shield is down
	if energy_shield == false and curr_energy > 0:
		curr_energy -= defaultEnergyDecrease
		money_processor.set_max(_get_money_gen_rate())
	##
	
	# If our energy is over 60, it's time to start overheating...
	if curr_energy >= 75:
		temp_dir = 1
		temperature_processor.set_max(2)
	elif curr_energy > 60:
		temp_dir = 1
		temperature_processor.set_max(4)
	else:
		temp_dir = -1
		temperature_processor.set_max(8)
	##
	
	if temperature_processor.tick():
		temperature_processor.reset_tick_count()
		
		curr_temp += ceil(defaultTempModification * temp_dir * (1.0 + dickheadTempMod))
		
		if curr_temp < 0:
			curr_temp = 0
		elif curr_temp > maxTempurate:
			curr_temp = maxTempurate
		##
	##
	
	character_skeleton.control_display(curr_stress, curr_temp, curr_energy, temp_color, energy_color)
	
	if stress_processor.get_max() > 0 and stress_processor.tick():
		SignalBus.emit_signal("worker_quit", self)
		SignalBus.disconnect("tick_update", tick_update_receiver)
		
		# TODO: other things
		
		# BAIL! --> worker does nothing else and leaves
		return
	##
	
	stress_processor.set_max(_get_stress_rate())
	
	# Shield tracker --> only enter if the worker has their shield active;
	#	otherwise, ignore the block
	if energy_shield and shield_processor.tick():
		energy_shield = false
		shield_processor.reset_tick_count()
	##
##

func _get_stress_rate() -> int:
	var rate:int = 0
	temp_color = default_color
	
	if curr_temp >= 25 and curr_temp < 50:
		rate = 4
		temp_color = maxTempColor / 4
	elif curr_temp >= 50 and curr_temp < 75:
		rate = 3
		temp_color = maxTempColor / 2
	elif curr_temp >= 75:
		rate = 2
		temp_color = maxTempColor
	##
	
	return rate
##

func _get_money_gen_rate() -> int:
	var rate:int = 4
	
	if curr_energy >= 0 and curr_energy < 10:
		rate = 0
		energy_color = minEnergyColor
	elif curr_energy >= 10 and curr_energy < 25:
		rate = 6
		energy_color = minEnergyColor / 2.0
	elif curr_energy >= 25 and curr_energy < 40:
		rate = 5
		energy_color = minEnergyColor / 4.0
	elif curr_energy >= 61 and curr_energy < 75:
		rate = 3
		energy_color = default_color
	elif curr_energy >= 75:
		rate = 2
		energy_color = default_color
	##
	
	return rate
##