extends Node

@onready var angry = $"../Angry"
@onready var speech_bubble = $"../SpeechBubble"
@onready var fireball = $"../Fireball"

###########################################

var target:Worker
var arrived:bool = false

var being_burned:bool = false
var burn_countdown:int = 0

var bullshitted:bool = false

var falling:bool = false

var prev_value:int = 0

func _ready():
	SignalBus.connect("tick_update", _tick_update)
##

func leaving():
	return get_parent().unkind_leave or get_parent().kind_leave
##

func is_interacting_with_player():
	return get_parent().effect_bar.visible
##

func interacting_with_worker():
	return get_parent().nav_agent.is_navigation_finished() and !leaving() and !is_interacting_with_player()
##

func _tick_update():
	if falling == false:
		if interacting_with_worker() and arrived == false and target != null:
			arrived = true
			target.boss_arrived()
			angry.emit()
		##
		
		if is_interacting_with_player():
			if angry.is_emitting():
				angry.stop_emitting()
			##
			
			#if arrived:
				#if target != null:
					#target.boss_gone()
				###
				#arrived = false
			###
		##
		
		
		if prev_value == get_parent().effect_bar.value:
			get_parent().hide_effect_bar()
		##
		
		if is_interacting_with_player():
			prev_value = get_parent().effect_bar.value
		##
		
		if being_burned:
			if burn_countdown > 0:
				burn_countdown -= 1
			else:
				fireball.stop_emitting()
				being_burned = false
				get_parent().unkind_leave = true
				get_parent().nav_agent.target_position = get_parent().leave_target
			##
		##
	##
##
