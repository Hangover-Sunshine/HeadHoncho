extends Area2D
class_name Seat

var IsOpen:bool = true

func get_standing_pos():
	return $Marker2D.global_position
##

func enable_seat():
	$CollisionShape2D.disabled = false
	IsOpen = true
##

func disable_seat():
	$CollisionShape2D.disabled = true
	IsOpen = false
##
