extends VBoxContainer

var on_jam_cards:bool = false

func _on_anim_swap_timer_timeout():
	if on_jam_cards == false:
		on_jam_cards = true
		$AnimationPlayer.play("swap_to_cards")
	else:
		on_jam_cards = false
		$AnimationPlayer.play("swap_to_jam_logo")
	##
##
