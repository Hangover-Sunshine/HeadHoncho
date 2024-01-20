extends Node2D

@onready var pointer = $Pointer

var up:bool = false
var down:bool = false
var left:bool = false
var right:bool = false

var facing:int = 1

func _input(event):
	if event.is_action_pressed("up"):
		up = true
	elif event.is_action_released("up"):
		up = false
	##
	
	if event.is_action_pressed("down"):
		down = true
	elif event.is_action_released("down"):
		down = false
	##
	
	if event.is_action_pressed("left"):
		left = true
	elif event.is_action_released("left"):
		left = false
	##
	
	if event.is_action_pressed("right"):
		right = true
	elif event.is_action_released("right"):
		right = false
	##
##

func _facing(curr_facing):
	if (up and down) or (up and left) or (up and right) or (left and right) or (down and left) or\
		(down and right):
		return curr_facing
	##
		
	if up:
		return 0
	if down:
		return 2
	if right:
		return 3
	if left:
		return 1
	##
	
	return curr_facing
##

func _process(_delta):
	var prev_facing = facing
	facing = _facing(facing)
	
	if prev_facing != facing:
		match facing:
			0:
				rotation_degrees = 270
			1:
				rotation_degrees = 0
			2:
				rotation_degrees = 90
			3:
				rotation_degrees = 180
			##
		##
		
		pointer.show_arrow()
	##	
##
