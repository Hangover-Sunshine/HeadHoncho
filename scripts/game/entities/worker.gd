extends StaticBody2D
class_name Worker

@export var BaseMoneyContribution:float = 100
@export var EnergyDecreasePerTick:float = -2

var _overheating:bool = false
var _energy_levels:float = 50
var _multiplier:float = 1
var _energy_change:float

func _check_energy():
	if _energy_levels <= 0:
		_multiplier = 0
		_energy_levels = 0
	elif _energy_levels < 33:
		_multiplier = 0.5
	elif _energy_levels < 66:
		_multiplier = 1
	else:
		_overheating = true
		_multiplier = 2
	##
##

func get_current_contribution():
	return BaseMoneyContribution * _multiplier
##

func increase_energy(amnt:float):
	_energy_change = amnt
##

func change_energy():
	_energy_levels += _energy_change
	
	if _overheating and _energy_levels < 66:
		_energy_levels = 66
	##
	
	if _energy_levels > 100:
		_energy_levels = 100
	##
	
	_energy_change = EnergyDecreasePerTick
	
	_check_energy()
##
