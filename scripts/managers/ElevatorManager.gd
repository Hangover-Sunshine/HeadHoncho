extends Node2D

@onready var animation_player = $AnimationPlayer

func play_anim():
	if animation_player.is_playing() == false:
		animation_player.play("Elev_Open")
	##
##

func get_timestep() -> float:
	return animation_player.get_current_animation_position()
##

func is_open() -> bool:
	return animation_player.get_current_animation_position() >= 0.5 and\
		animation_player.get_current_animation_position() <= 2.0
##
