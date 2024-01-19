extends Node2D

var paused:bool = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		$UILayer/PauseUI.visible = !$UILayer/PauseUI.visible
		$UILayer/PauseUI.pause_pressed()
	##
##

func unpause():
	$UILayer/PauseUI.visible = false
	get_tree().paused = false
##
