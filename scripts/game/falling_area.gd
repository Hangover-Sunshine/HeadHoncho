extends Area2D

func _on_body_entered(body):
	if body is PlayerV2:
		print("player dead!")
	##
	if body is Dickhead:
		body.start_falling()
	##
##
