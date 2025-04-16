extends StaticBody2D
class_name Worker

signal worker_quits(worker:Worker)

@export var BaseMoneyContribution:float = 100
@export var EnergyDecreasePerTick:float = -2
@export var TemperatureIncreasePerTick:float = 2

var _temperature:float = 0
var _cooling_down:bool = false
var _overheating:bool = false
var _energy_level:float = 50
var _multiplier:float = 1
var _energy_change:float

func _check_health():
	if _energy_level <= 0:
		_multiplier = 0
		_energy_level = 0
	elif _energy_level < 33:
		_multiplier = 0.5
	elif _energy_level < 66:
		_multiplier = 1
	else:
		if _overheating and _cooling_down == false:
			_temperature = min(100, _temperature + TemperatureIncreasePerTick)
			if _temperature >= 100:
				worker_quits.emit(self)
			##
		##
		_cooling_down = false
		_overheating = true
		_multiplier = 2
	##
	
	if _energy_level < 66:
		_temperature = max(0, _temperature - TemperatureIncreasePerTick)
	##
##

func get_current_contribution():
	return BaseMoneyContribution * _multiplier
##

func increase_energy(amnt:float):
	_energy_change = amnt
##

func change_energy():
	_energy_level += _energy_change
	
	if _overheating and _energy_level < 66:
		_energy_level = 66
	##
	
	if _energy_level > 100:
		_energy_level = 100
	##
	
	_energy_change = EnergyDecreasePerTick
	
	_check_health()
##

func cooloff(decrease:float):
	_overheating = false
	_cooling_down = true
	_energy_change = decrease
##

func is_quitting():
	return _temperature >= 100
##
