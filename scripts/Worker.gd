extends StaticBody2D
class_name Worker

@export_group("Temperature")
@export var startingTemp:int = 0
@export var defaultTempModification:int = 1
@export var maxTempurate:int = 100
@export var TEMPERATURE_DECREASE_EFFECT:int = 20
@export var maxTempColor:Color = Color.ORANGE_RED

@export_group("Energy")
@export var ENERGY_INCREASE_EFFECT:int = 20
@export var startingEnergy:int = 50
@export var defaultEnergyDecrease:int = 1
@export var energyShieldTickCount:int = 5
@export var maxEnergy:int = 100
@export var minEnergyColor:Color = Color.BLUE_VIOLET
@export var dickheadTempMod:float = 0.1

@export_group("Stress")
@export var startingStress:int = 0
@export var defaultStressIncrease:int = 1
@export var ticksUntilStressIncrease:int = 6
@export var maxStress:int = 100

@export_group("General Stats")
@export var defaultMoney:int = 100

#################################################################

@onready var effect_bar = $EffectBar

var default_color:Color = Color.WHITE
var energy_color:Color = default_color
var temp_color:Color = default_color
var curr_color:Color = default_color

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

var saved:bool = false
var saved_temp:int
var saved_energy:int
var bosses_nearby:int = 0
var increase_money:float = 0

func _ready():
	$TickReceiver.curr_temp = startingTemp
	$TickReceiver.curr_energy = startingEnergy
	$TickReceiver.curr_stress = startingStress
	
	$TickReceiver.shield_processor.set_max(energyShieldTickCount)
	
	$CharacterSkeleton.generate_character()
	
	SignalBus.connect("aoe_heal", _aoe_heal)
##

func reset_worker():
	$TickReceiver.money_rate = 0
	$TickReceiver.bosses_nearby = 0
	$TickReceiver.curr_temp = $TickReceiver.saved_temp
	$TickReceiver.curr_energy = $TickReceiver.saved_energy
##

func boss_arrived():
	$TickReceiver.bosses_nearby += 1
	
	if $TickReceiver.saved == false:
		$TickReceiver.saved = true
		$TickReceiver.saved_temp = curr_temp
		$TickReceiver.saved_energy = curr_energy
	##
	
	$TickReceiver.increase_money += 0.2
	$TickReceiver.curr_energy = 100
	
	if $TickReceiver.curr_temp < 40:
		$TickReceiver.curr_temp = 40
	##
##

func boss_gone():
	$TickReceiver.bosses_nearby -= 1
	$TickReceiver.increase_money -= 0.2
	
	if bosses_nearby == 0:
		$TickReceiver.saved = false
		$TickReceiver.curr_temp = $TickReceiver.saved_temp
		$TickReceiver.curr_energy = $TickReceiver.saved_energy
		$TickReceiver.increase_money = 0
	##
##

func _aoe_heal(amount):
	$TickReceiver.curr_stress -= amount
	
	if $TickReceiver.curr_stress < 0:
		$TickReceiver.curr_stress = 0
	##
##

func show_effect_bar():
	effect_bar.visible = true
##

func hide_effect_bar():
	effect_bar.value = 0
	effect_bar.visible = false
##

func update_effect_bar(curr_val:int, max_val:int):
	effect_bar.value = clampi((curr_val / float(max_val)) * 100, 0, 100)
##

func apply_blowie_effect():
	$TickReceiver.curr_temp -= TEMPERATURE_DECREASE_EFFECT
	
	if $TickReceiver.curr_temp < 0:
		$TickReceiver.curr_temp = 0
	##
##

func apply_covefe_effect():
	$TickReceiver.curr_energy += ENERGY_INCREASE_EFFECT
	
	$TickReceiver.energy_shield = true
	
	if $TickReceiver.curr_energy > maxEnergy:
		$TickReceiver.curr_energy = maxEnergy
	##
##

func apply_moneybags_effect():
	$TickReceiver.curr_stress -= 1
	
	if $TickReceiver.curr_stress < 0:
		$TickReceiver.curr_stress = 0
	##
##
