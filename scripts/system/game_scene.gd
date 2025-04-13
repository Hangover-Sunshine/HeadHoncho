extends Node2D

func _ready():
	Verho.added_scene.connect(_new_scene_added)
##

func _input(event):
	if event.is_action_pressed("pause"):
		pause_unpause()
	##
##

func _new_scene_added(scene):
	if scene != self:
		queue_free()
	##
##

func pause_unpause():
	GlobalSignals.pause_status.emit(!get_tree().paused)
	get_tree().paused = !get_tree().paused
	%PauseLayer.visible = get_tree().paused
	$PauseLayer/HubPause.to_pause()
##
