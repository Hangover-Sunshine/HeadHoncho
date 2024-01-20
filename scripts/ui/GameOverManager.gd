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

func _ready():
	SignalBus.connect("player_jumped_out_window", player_dies_end)
	SignalBus.connect("player_fired", player_fired_end)
	SignalBus.connect("player_survived", survive_end)
	SignalBus.connect("too_many_workers_quit", unionization_end)
	visible = false
##

func _input(event):
	if visible == false:
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
	if visible == false:
		return
	##
	
	if out_of_reading == false:
		if Input.is_action_pressed("head_interaction"):
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
	
	visible = true
	label.text = "By some chance, you fell out the window; whether it was an accident, on purpose, " +\
				"or some other reason will not be investigated. In fact, before the coroner could " +\
				"pronounce you dead due to blunt force trauma, [Company] marched in and stapled " +\
				"'you're fired' to your corpse and your final performance review."
##

func player_fired_end():
	visible = true
	label.text = "Owing to your terrible management of the company's money, you've been " +\
				"summarily fired. You were asked to meet The Bosses on a boat, where you were " +\
				"never heard from again. Your family was not compensated. No one was investiged."
##

func unionization_end():
	visible = true
	label.text = "You decided to not fire workers when they were showing signs they were going to " +\
				"collectivize. This will cost the company greatly. You were arrested by the Bluetonnes " +\
				"and executed for allowing a UNION to come into existence. Now they'll have to fire " +\
				"everyone. Read your handbook on 'Why Unions Are Bad [for the company]'" +\
				"better next time.\nGod bless the US of A, you f*cking commie socialist."
##

func survive_end():
	visible = true
	label.text = "The Company congratulates you for meeting all quotas in the physical year! You've " +\
				"earned that $0.50 wage increase and $2 'Employee of the Month' frame... " +\
				"Yes, you might've been the reason the stock prices are now worth 180% more, but you " +\
				"weren't born with a silver spoon and on third base, so go f*ck yourself before we fire " +\
				"you. Be greatful you have a job."
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
