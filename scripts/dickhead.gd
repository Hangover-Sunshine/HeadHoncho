extends CharacterBody2D
class_name Dickhead

@export_group("Movement")
@export var MOVEMENT_SPEED:float = 400.0

@export_group("Being Blown")
@export var BLOW_FORCE:float = 1500.0
@export var DRAG:float = 200.0

@export_group("Burning")
@export var BURN_SPEED:float = 600.0
@export var BURN_COUNTDOWN:Vector2i = Vector2i(8, 12)

#############################################################

@onready var speech_bubble = $SpeechBubble
@onready var bad_performance = $BadPerformance
@onready var good_performance = $GoodPerformance
@onready var fireball = $Fireball
@onready var angry = $Angry

@onready var nav_agent = $NavAgent
@onready var effect_bar = $EffectBar

#############################################################

var player:Player
var dir_from_player_to_me:Vector2
var curr_drag:float

var worker_target:Worker
var leave_target:Vector2
var curr_target:Vector2
var fall_lerp_to:Vector2

var blowing_away:bool = false

var bullshitted:bool = false

var falling:bool = false

var unkind_leave:bool = false
var kind_leave:bool = false

func _ready():
	nav_agent.path_desired_distance = 15
	nav_agent.target_desired_distance = 5
	
	$CharacterSkeleton.generate_character()
	
	SignalBus.connect("worker_quit", _worker_quit)
	
	effect_bar.visible = false
	effect_bar.value = 0
##

func _worker_quit(worker:Worker):
	if worker_target == worker:
		SignalBus.emit_signal("request_new_target", self)
	##
##

func fall():
	if $TickUpdateReceiver.falling == false:
		$CharacterSkeleton/AnimationPlayer.play("Falling")
		fireball.stop_emitting()
		$TickUpdateReceiver.falling = true
	##
	if $CharacterSkeleton/AnimationPlayer.is_playing() == false:
		SignalBus.emit_signal("dickhead_died")
		queue_free()
		return true
	##
	return false
##

func set_target(targ_worker):
	if targ_worker != null:
		worker_target = targ_worker
		$TickUpdateReceiver.target = targ_worker
		nav_agent.target_position = $TickUpdateReceiver.target.global_position
	else:
		SignalBus.emit_signal("request_new_target", self)
	##
##

func set_leave(leave_targ):
	leave_target = leave_targ
##

func _process(_delta):
	if unkind_leave == true and curr_target == null:
		nav_agent.target_position = leave_target
		return
	##
	
	if unkind_leave == true and nav_agent.is_navigation_finished():
		SignalBus.emit_signal("dickhead_removed")
	##
	
	if kind_leave == true and nav_agent.is_navigation_finished():
		SignalBus.emit_signal("dickhead_left")
	##
	
	if falling:
		$TickUpdateReceiver.falling = true
		global_position = global_position.lerp(fall_lerp_to, 0.01)
		fireball.stop_emitting()
		
		if $CharacterSkeleton/AnimationPlayer.is_playing() == false and\
			$CharacterSkeleton.fall_anim_played:
			SignalBus.emit_signal("dickhead_died")
			queue_free()
		##
	##
##

func _physics_process(delta):
	if $TickUpdateReceiver.falling == false and effect_bar.visible == false:
		if blowing_away:
			if velocity.length() < 10:
				velocity = Vector2.ZERO
				collision_mask &= 4
				collision_mask |= 8
				unkind_leave = true
				nav_agent.target_position = leave_target
				blowing_away = false
			##
			
			curr_drag = lerpf(curr_drag, DRAG, 0.015)
			velocity /= 1 + curr_drag
		else:
			if nav_agent.is_navigation_finished() and $TickUpdateReceiver.being_burned:
				nav_agent.target_position = get_parent().pick_position()
			##
			
			velocity = _velocity_from_path()
		##
	else:
		velocity = Vector2.ZERO
	##
	
	move_and_slide()
##

func _velocity_from_path():
	if nav_agent.is_navigation_finished():
		return Vector2.ZERO
	##

	if $TickUpdateReceiver.being_burned:
		return global_position.direction_to(nav_agent.get_next_path_position()) * BURN_SPEED
	##
	
	return global_position.direction_to(nav_agent.get_next_path_position()) * MOVEMENT_SPEED
##

func show_effect_bar():
	if blowing_away == false and $TickUpdateReceiver.being_burned == false:
		effect_bar.visible = true
		speech_bubble.emit()
	##
##

func hide_effect_bar():
	effect_bar.value = 0
	effect_bar.visible = false
	speech_bubble.stop_emitting()
##

func update_effect_bar(curr_val:int, max_val:int):
	if blowing_away == false and $TickUpdateReceiver.being_burned == false:
		effect_bar.value = clampi((curr_val / float(max_val)) * 100, 0, 100)
	##
##

func apply_blowie_effect():
	if blowing_away == false:
		blowing_away = true
	else:
		return
	##
	
	bad_performance.emitting = true
	
	hide_effect_bar()
	
	dir_from_player_to_me = global_position - player.global_position
	
	if abs(dir_from_player_to_me.y) > abs(dir_from_player_to_me.x):
		dir_from_player_to_me.x = 0
	##
	if abs(dir_from_player_to_me.x) > abs(dir_from_player_to_me.y):
		dir_from_player_to_me.y = 0
	##
	
	dir_from_player_to_me = dir_from_player_to_me.normalized()
	
	collision_mask &= 4
	collision_mask |= 16
	
	velocity = BLOW_FORCE * dir_from_player_to_me
##

func apply_covefe_effect():
	if $TickUpdateReceiver.being_burned == false:
		$TickUpdateReceiver.being_burned = true
	else:
		return
	##
	
	bad_performance.emitting = true
	
	hide_effect_bar()
	
	fireball.emit()
	$TickUpdateReceiver.burn_countdown = randi_range(BURN_COUNTDOWN.x, BURN_COUNTDOWN.y)
	
	nav_agent.target_position = get_parent().pick_position()
##

func apply_moneybags_effect():
	if bullshitted == false:
		bullshitted = true
	else:
		return
	##
	
	good_performance.emitting = true
	$CharacterSkeleton.best_boss_face()
	
	hide_effect_bar()
	
	kind_leave = true
	curr_target = leave_target
	nav_agent.target_position = leave_target
##

func set_disgruntled():
	unkind_leave = true
	nav_agent.target_position = leave_target
	bad_performance.emitting = true
##
