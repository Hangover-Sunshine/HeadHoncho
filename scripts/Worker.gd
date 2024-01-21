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
@export var maxStress:int = 100

@export_group("General Stats")
@export var defaultMoney:int = 100

#################################################################

@onready var effect_bar = $EffectBar
@onready var audio_player = $AudioStreamPlayer2D

var sounds = {
	"fire":load("res://assets/sound/sfx/SFX_Fire.wav"),
	"snore":null
}

var default_color:Color = Color.WHITE
var energy_color:Color = default_color
var temp_color:Color = default_color
var curr_color:Color = default_color

var bosses_nearby:int = 0

func _ready():
	$TickReceiver.curr_temp = startingTemp
	$TickReceiver.curr_energy = startingEnergy
	$TickReceiver.curr_stress = startingStress
	
	$TickReceiver.shield_processor.set_max(energyShieldTickCount)
	
	$CharacterSkeleton.generate_character()
	
	SignalBus.connect("aoe_heal", _aoe_heal)
##

func reset_worker():
	$TickReceiver.money_increase_perc = 0
	$TickReceiver.load_stats()
##

func boss_arrived():
	bosses_nearby += 1
	$TickReceiver.save_stats()
	
	$TickReceiver.money_increase_perc = 0.2 * bosses_nearby
	$TickReceiver.curr_energy = 100
	$TickReceiver.covefe_fed()
##

func boss_gone():
	bosses_nearby -= 1
	$TickReceiver.money_increase_perc = 0.2 * bosses_nearby
	$TickReceiver.dickheadTempMod = dickheadTempMod * bosses_nearby
	
	if bosses_nearby == 0:
		$TickReceiver.load_stats() 
		$TickReceiver.covefe_fed()
	##
##

func _aoe_heal(amount):
	$TickReceiver.curr_stress -= amount
	
	if $TickReceiver.curr_stress > 0 and $TickReceiver.curr_stress % 4 == 0:
		$GoodPerformance.emitting = true
	##
	
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
	$TickReceiver.covefe_fed()
	
	$TickReceiver.energy_shield = true
	
	if $TickReceiver.curr_energy > maxEnergy:
		$TickReceiver.curr_energy = maxEnergy
	##
##

func apply_moneybags_effect():
	$TickReceiver.curr_stress -= 1
	
	if $TickReceiver.curr_stress > 0 and $TickReceiver.curr_stress % 4 == 0:
		$GoodPerformance.emitting = true
	##
	
	if $TickReceiver.curr_stress < 0:
		$TickReceiver.curr_stress = 0
	##
##
