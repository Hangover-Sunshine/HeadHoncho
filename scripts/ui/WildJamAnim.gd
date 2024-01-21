extends VBoxContainer

# 0 = title, 1 = content warning, #2 = GDJ logo, #3 = cards
var curr_slide:int = 3

var anim_dict:Array = ["Slide1>2", "Slide2>3", "Slide3>4", "Slide4>1"]

func _on_anim_swap_timer_timeout():
	curr_slide += 1
	curr_slide = curr_slide % len(anim_dict)
	$AnimationPlayer.play(anim_dict[curr_slide])
##
