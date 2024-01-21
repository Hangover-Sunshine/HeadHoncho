extends Control

@onready var landing_menu = $MarginContainer/MainPauseMenu/LandingMenu
@onready var quit_game = $MarginContainer/MainPauseMenu/LandingMenu/MainSettings/QuitGame

@onready var game = $"../.."

var paused:bool = false

var arrows = []

var platform = ""

# 0 = Resume, 1 = Settings, 2 = Quit to Menu, 3 = Quit Game
var curr_pos:int = 0
var max_pos:int = 3

var up_pressed:bool = false
var down_pressed:bool = false

func _ready():
	platform = OS.get_name()
	
	var left = $MarginContainer/MainPauseMenu/LandingMenu/VBoxContainer.get_children()
	var right = $MarginContainer/MainPauseMenu/LandingMenu/VBoxContainer2.get_children()
	
	for ai in range(len(left)):
		arrows.append([left[ai], right[ai]])
	##
	
	visible = false
	
	# hide quit game on web -- doesn't really make sense
	if platform == "Web":
		quit_game.visible = false
		max_pos = 2
	##
##

func pause_pressed():
	arrows[curr_pos][0].text = ""
	arrows[curr_pos][1].text = ""
	curr_pos = 0
	arrows[curr_pos][0].text = ">>>>>"
	arrows[curr_pos][1].text = "<<<<<"
##

func _input(event):
	if paused == false:
		return
	##
	
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
	if paused == false:
		return
	##
	
	if up_pressed and $DelayWhilePressedTimer.is_stopped():
		move_arrows_up()
		$DelayWhilePressedTimer.start()
	##
	if down_pressed and $DelayWhilePressedTimer.is_stopped():
		move_arrows_down()
		$DelayWhilePressedTimer.start()
	##
	
	if Input.is_action_pressed("head_interaction"):
		if curr_pos == 0:
			pause_pressed()
			game.unpause()
		elif curr_pos == 1:
			pass
		elif curr_pos == 2:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif curr_pos == 3:
			get_tree().quit()
		##
	##
##

func move_arrows_up():
	arrows[curr_pos][0].text = ""
	arrows[curr_pos][1].text = ""
	
	curr_pos = curr_pos - 1 if curr_pos > 0 else max_pos
	
	arrows[curr_pos][0].text = ">>>>>"
	arrows[curr_pos][1].text = "<<<<<"
##

func move_arrows_down():
	arrows[curr_pos][0].text = ""
	arrows[curr_pos][1].text = ""
	
	curr_pos = curr_pos + 1 if curr_pos < max_pos else 0
	
	arrows[curr_pos][0].text = ">>>>>"
	arrows[curr_pos][1].text = "<<<<<"
##
