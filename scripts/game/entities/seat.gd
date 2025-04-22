extends Area2D
class_name Seat

var IsOpen:bool = true

func enable_seat():
	$CollisionShape2D.disabled = false
	IsOpen = true
##

func disable_seat():
	$CollisionShape2D.disabled = true
	IsOpen = false
##
