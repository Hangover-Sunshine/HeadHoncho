extends Control

func _ready():
	$AnimationPlayer.play("PlaceCard")
##

func _on_animation_player_animation_finished(anim_name):
	$Hand/BusinessCard.can_control = true
##
