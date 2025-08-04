extends StaticBody2D
class_name Worker

signal worker_quits(worker:Worker)

@export var BaseMoneyContribution:float = 100
@export var EnergyDecreasePerTick:float = -2
@export var TemperatureIncreasePerTick:float = 2

var _stress:float = 0
var _temperature:float = 50
var _cooling_down:bool = false
var _overheating:bool = false
var _multiplier:float = 1
var _energy_change:float
var _is_stressed:bool = false
var _is_affected_by_manager:bool = false

func _ready():
	$ArtWorker.be_meh()
##

func _check_health():
	if _temperature <= 0:
		if _multiplier != 0:
			$ArtWorker.be_asleep()
			_multiplier = 0
		##
		_temperature = 0
	elif _temperature < 33:
		if _multiplier != 0.5:
			$ArtWorker.be_happy()
			_multiplier = 0.5
		##
	elif _temperature < 66:
		if _multiplier != 1:
			$ArtWorker.be_meh()
			_multiplier = 1
		##
	else:
		if _overheating and _cooling_down == false:
			_stress = min(100, _stress + (
					TemperatureIncreasePerTick  *
						(1.0 if _is_affected_by_manager == false else 1.25)
				)
			)
			if _stress >= 100:
				# TODO: Quit animation
				worker_quits.emit(self)
				queue_free() # << Replace this
			##
		##
		
		if _stress < 51 and _is_stressed == false:
			_is_stressed = true
			$ArtWorker.be_stressed()
		elif _stress > 50 and _is_stressed:
			_is_stressed = false
			$ArtWorker.be_onfire()
		##
		
		_cooling_down = false
		_overheating = true
		_multiplier = 2
	##
##

func get_current_contribution():
	return BaseMoneyContribution * (
		_multiplier * (1.0 if _is_affected_by_manager == false else 0.75)
	)
##

func increase_energy(amnt:float):
	if _is_affected_by_manager == false:
		_energy_change = amnt
	##
##

func change_energy():
	if _is_affected_by_manager:
		_temperature += 100 #-_energy_change * 1.5
		$ArtWorker.set_temperature(100)
	else:
		_temperature += _energy_change
		$ArtWorker.add_to_temperature(_energy_change)
	##
	
	if _overheating and _temperature < 66:
		_temperature = 66
	##
	
	if _temperature > 100:
		_temperature = 100
	##
	
	if _temperature < 0:
		_temperature = 0
	##
	
	_energy_change = EnergyDecreasePerTick
	
	_check_health()
	
	if _is_affected_by_manager:
		$ArtWorker.set_multiplier(_multiplier * 0.75)
	else:
		$ArtWorker.set_multiplier(_multiplier)
	##
##

func cooloff(decrease:float):
	if _is_affected_by_manager == false:
		_overheating = false
		_cooling_down = true
		_energy_change = decrease
	##
##

func payoff(decrease:float):
	if _is_affected_by_manager == false:
		_stress += decrease
	##
##

func is_quitting():
	return _stress >= 100
##

func affected_by_dickhead():
	_is_affected_by_manager = true
	if _temperature < 25:
		_temperature = 25
	##
	# Force the energy to be it's usual value
	_energy_change = EnergyDecreasePerTick
##
