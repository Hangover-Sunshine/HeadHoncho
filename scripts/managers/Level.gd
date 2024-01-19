extends Node2D

var paused:bool = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		$UILayer/PauseUI.visible = !$UILayer/PauseUI.visible
		$UILayer/PauseUI.paused = true
		$UILayer/PauseUI.pause_pressed()
	##
##

func unpause():
	$UILayer/PauseUI.visible = false
	$UILayer/PauseUI.paused = false
	get_tree().paused = false
##
