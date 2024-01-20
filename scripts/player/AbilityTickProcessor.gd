extends Node
class_name AbilityTickProcessor

var _min:int = 4
var _max:int = 4

var _curr_tick_count:int = 0
var _max_ticks:int = 0

var _is_active:bool = false

func set_tick_range(nmin, nmax):
	_min = nmin
	_max = nmax
##

func get_is_active() -> bool:
	return _is_active
##

func get_new_max() -> int:
	_max_ticks = randi_range(_min, _max)
	return _max_ticks
##

func get_tick_count() -> int:
	return _curr_tick_count
##

func reset_tick_count():
	_curr_tick_count = 0
##

func factory_reset():
	_curr_tick_count = 0
	_is_active = false
##

func tick() -> bool:
	if _is_active == false:
		_is_active = true
	##
	
	_curr_tick_count += 1
	
	return _curr_tick_count >= _max_ticks
##
