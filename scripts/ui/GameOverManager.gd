extends Control

@onready var label = $TextBG/MarginContainer/VBoxContainer/Label
@onready var text_bg = $TextBG

@onready var survive_all_quotas = $Jpegs/SurviveAllQuotas
@onready var fall_out = $Jpegs/FallOut
@onready var unionization = $Jpegs/Unionization
@onready var fired = $Jpegs/Fired

@onready var to_game_menu = $ToGameMenu
@onready var replay_arrow = $ToGameMenu/ReplayArrow
@onready var mid_arrow = $ToGameMenu/MidArrow
@onready var menu_arrow = $ToGameMenu/MenuArrow

var curr_pos:int = 0

var up_pressed:bool = false
var down_pressed:bool = false

var arrows = []

var out_of_reading:bool = false

var first_signal:bool = false

var in_gameover:bool = false

func _ready():
	SignalBus.connect("player_jumped_out_window", player_dies_end)
	SignalBus.connect("player_fired", player_fired_end)
	SignalBus.connect("player_survived", survive_end)
	SignalBus.connect("too_many_workers_quit", unionization_end)
	visible = false
##

func _input(event):
	if in_gameover == false:
		return
	##
	
	if event.is_action_pressed("up") or event.is_action_pressed("left"):
		up_pressed = true
		$ToGameMenu/DelayWhilePressedTimer.stop()
	elif event.is_action_released("up") or event.is_action_released("left"):
		up_pressed = false
	##
	if event.is_action_pressed("down") or event.is_action_pressed("right"):
		down_pressed = true
		$ToGameMenu/DelayWhilePressedTimer.stop()
	elif event.is_action_released("down") or event.is_action_released("right"):
		down_pressed = false
	##
##

func _process(_delta):
	if in_gameover == false:
		return
	##
	
	if out_of_reading == false:
		if Input.is_action_pressed("head_interaction") and $ToGameMenu/DelayWhilePressedTimer.is_stopped():
			text_bg.visible = false
			to_game_menu.visible = true
			out_of_reading = true
			$ToGameMenu/DelayWhilePressedTimer.start()
		##
		return
	##
	
	if up_pressed and $ToGameMenu/DelayWhilePressedTimer.is_stopped():
		move_arrows_up()
		$ToGameMenu/DelayWhilePressedTimer.start()
	##
	if down_pressed and $ToGameMenu/DelayWhilePressedTimer.is_stopped():
		move_arrows_down()
		$ToGameMenu/DelayWhilePressedTimer.start()
	##
	
	if Input.is_action_pressed("head_interaction") and $ToGameMenu/DelayWhilePressedTimer.is_stopped():
		if curr_pos == 0:
			get_tree().change_scene_to_file("res://scenes/level.tscn")
		elif curr_pos == 1:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		##
	##
##

func player_dies_end():
	if first_signal == false:
		first_signal = true
		return
	##
	
	in_gameover = true
	
	$ToGameMenu/DelayWhilePressedTimer.start()
	
	visible = true
	label.text = "By some chance, you fell out the window; whether it was an accident, on purpose, " +\
				"or some other reason, your cause of death was never investigated. In fact, before 
				the coroner could pronounce you dead due to blunt force trauma, MLM Corp. stapled" +\
				"a termination letter to your corpse as a response, due in part, to your lackluster" +\
				"performance post-death."
##

func player_fired_end():
	in_gameover = true
	$ToGameMenu/DelayWhilePressedTimer.start()
	visible = true
	label.text = "Owing to your terrible management of the company's money, you've been " +\
				"summarily terminated. You were asked to meet management on a boat, where you were " +\
				"never heard from again. Your family was not compensated. No one was investigated."
##

func unionization_end():
	in_gameover = true
	$ToGameMenu/DelayWhilePressedTimer.start()
	visible = true
	label.text = "You decided to not fire workers when they were showing signs they were going to " +\
				"unionize. This cost MLM Corp. greatly and you were immediately let go for" +\
				"failing to create a healthy and happy work environment. MLM Corp. takes" +\
				"employee stresss seriously; we are a family, and we cannot have staff" +\
				"who contribute to a toxic work environment."
##

func survive_end():
	in_gameover = true
	$ToGameMenu/DelayWhilePressedTimer.start()
	visible = true
	label.text = "The Company congratulates you for meeting all quotas in the fiscal year!" +\
				"MLM Corp. stock has risen 50%; our company is now bringing record breaking profits " +\
				"because of your contributions. Speaking of which, due to cost cutting measures and a " +\
				"turbulent economic crisis, our team has to make some cuts and you have been let go." +\
				"Please expect your paycheck in the next couple of weeks. We do not cash out PTO."
##

func move_arrows_up():
	if curr_pos == 0:
		replay_arrow.text = ""
		mid_arrow.text = ">>>>>"
	elif curr_pos == 1:
		menu_arrow.text = ""
		mid_arrow.text = "<<<<<"
	##
	
	curr_pos = curr_pos - 1 if curr_pos > 0 else 1
	
	if curr_pos == 0:
		replay_arrow.text = ">>>>>"
	elif curr_pos == 1:
		menu_arrow.text = "<<<<<"
	##
##

func move_arrows_down():
	if curr_pos == 0:
		replay_arrow.text = ""
		mid_arrow.text = ">>>>>"
	elif curr_pos == 1:
		menu_arrow.text = ""
		mid_arrow.text = "<<<<<"
	##
	
	curr_pos = curr_pos + 1 if curr_pos < 1 else 0
	
	if curr_pos == 0:
		replay_arrow.text = ">>>>>"
	elif curr_pos == 1:
		menu_arrow.text = "<<<<<"
	##
##
