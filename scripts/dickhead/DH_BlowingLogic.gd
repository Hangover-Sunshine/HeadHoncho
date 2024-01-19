extends Node2D

var being_blown_cd:int = 0
var blow_start_cd:int = 4
var being_blown:bool = false

func getting_blown() -> int:
	if being_blown == false:
		being_blown = true
	##
	
	being_blown_cd += 1
	
	return ceil(being_blown_cd / blow_start_cd) * 100
##

func reset_being_blown():
	being_blown_cd = 0
	being_blown = false
##
