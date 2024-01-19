extends Node
class_name TickBarComponent

var tick_min_max:Vector2i

var tick_count:int = 0
var tick_max:int = 4
var level:int = 0

var prev_tick_count:int = -1

func tick() -> int:
	if level == 2:
		return -1
	##
	
	if level == 0:
		level = 1
	##
	
	tick_count += 1
	
	if tick_count >= tick_max:
		level = 2
	##
	
	return tick_count
##

func check_for_reset() -> bool:
	if prev_tick_count == tick_count:
		if level == 1:
			tick_count = 0
			level = 0
			return true
		##
	##
		
	prev_tick_count = tick_count
	return false
##

func reset_tick_count():
	tick_count = 0
##

func set_level(l):
	level = l
##

func get_level():
	return level
##

func generate_new_max(min:int, max:int) -> int:
	tick_max = Utility.rand_rangei(min, max)
	return tick_max
##
