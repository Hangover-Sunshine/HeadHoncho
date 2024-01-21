extends MarginContainer

var arrows = []

var platform = ""

# 0 = Resume, 1 = Settings, 2 = Tips, 3 = Quit Game
var curr_pos:int = 0
var max_pos:int = 3

var up_pressed:bool = false
var down_pressed:bool = false

func _ready():
	var left = $HBoxContainer/MainMenuComponents/Menu/LArrow.get_children()
	
	$DelayWhilePressedTimer.start()
	
	for ai in range(len(left)):
		arrows.append([left[ai]])
	##
##

func _input(event):
	if event.is_action_pressed("up"):
		up_pressed = true
		$DelayWhilePressedTimer.stop()
	elif event.is_action_released("up"):
		up_pressed = false
	##
	if event.is_action_pressed("down"):
		down_pressed = true
		$DelayWhilePressedTimer.stop()
	elif event.is_action_released("down"):
		down_pressed = false
	##
##

func _process(_delta):
	
	if up_pressed and $DelayWhilePressedTimer.is_stopped():
		move_arrows_up()
		$DelayWhilePressedTimer.start()
	##
	if down_pressed and $DelayWhilePressedTimer.is_stopped():
		move_arrows_down()
		$DelayWhilePressedTimer.start()
	##
	
	if Input.is_action_pressed("head_interaction") and $DelayWhilePressedTimer.is_stopped():
		if curr_pos == 0:
			get_tree().change_scene_to_file("res://scenes/level.tscn")
		elif curr_pos == 1:
			pass
		elif curr_pos == 2:
			pass
		elif curr_pos == 3:
			get_tree().quit()
		##
	##
##

func move_arrows_up():
	arrows[curr_pos][0].text = ""
	
	curr_pos = curr_pos - 1 if curr_pos > 0 else max_pos
	
	arrows[curr_pos][0].text = "▶"
##

func move_arrows_down():
	arrows[curr_pos][0].text = ""
	
	curr_pos = curr_pos + 1 if curr_pos < max_pos else 0
	
	arrows[curr_pos][0].text = "▶"
##
