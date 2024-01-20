extends Node2D

@onready var fire = $Fire
@onready var dots = $Dots
@onready var kisses = $Kisses
@onready var hugs = $Hugs
@onready var dots_2 = $Dots2

func emit():
	fire.emitting = true
	dots.emitting = true
	kisses.emitting = true
	hugs.emitting = true
	dots_2.emitting = true
##

func _on_fire_finished():
	queue_free()
##
