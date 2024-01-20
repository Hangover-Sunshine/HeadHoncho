extends Node2D

func show_arrow(time:float = 0.25):
	$Arrow.modulate = Color.WHITE
	$TimeToDisappearTimer.start(time)
##

func _on_time_to_disappear_timer_timeout():
	$AnimationPlayer.play("Disapear")
##
