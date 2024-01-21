extends Control

@onready var audio_player = $AudioStreamPlayer2D

var sounds = {
	"pop":load("res://assets/sound/sfx/SFX_Head&Button.wav")
}

var arrows = []
var settings_arrows = []

var platform = ""

# 0 = Resume, 1 = Settings, 2 = Tips, 3 = Quit Game
var curr_pos:int = 0
var max_pos:int = 3

var up_pressed:bool = false
var down_pressed:bool = false

var can_control:bool = false

# 0 = Main Menu, 1 = Tips, 2 = Settings
var curr_screen:int = 0

func _ready():
	audio_player.stream = sounds["pop"]
	var left = $Menu/HBoxContainer/MainMenuComponents/Menu/LArrow.get_children()
	
	$DelayWhilePressedTimer.start()
	
	for ai in range(len(left)):
		arrows.append([left[ai]])
	##
	
	left = $Menu/Settings/LeftBox/LArrow.get_children()
	
	for ai in range(len(left)):
		if left[ai] is Label:
			settings_arrows.append([left[ai]])
		##
	##
##

func _input(event):
	if can_control:
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
##

func _process(_delta):
	if can_control:
		if curr_screen == 0:
			main_menu_interactions()
		elif curr_screen == 1:
			tips_interactions()
		elif curr_screen == 2:
			pass
		##
	##
##

func move_arrows_up():
	if curr_screen == 0:
		audio_player.play()
		arrows[curr_pos][0].text = ""
		curr_pos = curr_pos - 1 if curr_pos > 0 else max_pos
		arrows[curr_pos][0].text = "▶"
	else:
		settings_arrows[settings_curr_pos][0].text = ""
		settings_curr_pos = settings_curr_pos - 1 if settings_curr_pos > 0 else max_pos
		settings_arrows[settings_curr_pos][0].text = "▶"
	##
##

func move_arrows_down():
	if curr_screen == 0:
		audio_player.play()
		arrows[curr_pos][0].text = ""
		curr_pos = curr_pos + 1 if curr_pos < max_pos else 0
		arrows[curr_pos][0].text = "▶"
	else:
		settings_arrows[settings_curr_pos][0].text = ""
		settings_curr_pos = settings_curr_pos + 1 if settings_curr_pos < max_pos else 0
		settings_arrows[settings_curr_pos][0].text = "▶"
	##
##

func show_settings():
	curr_screen = 2
	$Menu/Settings.visible = true
##

func hide_settings():
	$Menu/Settings.visible = true
##

func show_tips():
	curr_screen = 1
	$Menu/Tips.visible = true
##

func hide_tips():
	$Menu/Tips.visible = false
##

func show_main_menu():
	curr_screen = 0
	$Menu/HBoxContainer.visible = true
	$Menu/Credits.visible = true
##

func hide_main_menu():
	$Menu/HBoxContainer.visible = false
	$Menu/Credits.visible = false
	$Menu/HBoxContainer/WildJamStuff.curr_slide = 3
##

func tips_interactions():
	if Input.is_action_pressed("head_interaction") and $DelayWhilePressedTimer.is_stopped():
		audio_player.play()
		hide_tips()
		show_main_menu()
		$DelayWhilePressedTimer.start()
	##
##

func main_menu_interactions():
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
			audio_player.play()
			$LoadDelayTimer.start()
		elif curr_pos == 1:
			pass
		elif curr_pos == 2:
			audio_player.play()
			hide_main_menu()
			show_tips()
			$DelayWhilePressedTimer.start()
		elif curr_pos == 3:
			audio_player.play()
			get_tree().quit()
		##
	##
##

var settings_curr_pos:int = 0

func settings_interactions():
	if up_pressed and $DelayWhilePressedTimer.is_stopped():
		move_arrows_up()
		$DelayWhilePressedTimer.start()
	##
	if down_pressed and $DelayWhilePressedTimer.is_stopped():
		move_arrows_down()
		$DelayWhilePressedTimer.start()
	##
	
	if Input.is_action_pressed("head_interaction") and $DelayWhilePressedTimer.is_stopped():
		if settings_curr_pos == 0:
			get_tree().change_scene_to_file("res://scenes/level.tscn")
		elif settings_curr_pos == 1:
			hide_main_menu()
			show_settings()
			$DelayWhilePressedTimer.start()
		elif settings_curr_pos == 2:
			hide_main_menu()
			show_tips()
			$DelayWhilePressedTimer.start()
		elif settings_curr_pos == 3:
			get_tree().quit()
		##
	##
##

func _on_load_delay_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/level.tscn")
##
