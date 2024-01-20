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

@onready var nav_agent = $NavAgent
@onready var effect_bar = $EffectBar

var player:Player

var annoy_worker:bool = false
var target:Worker
var arrived:bool = false

var blowing_away:bool = false
var dir_from_player_to_me:Vector2

var being_burned:bool = false
var burn_countdown:int = 0

var bullshitted:bool = false

var leave_target:Vector2
var unkind_leave:bool = false
var kind_leave:bool = false

var falling:bool = false

func _ready():
	nav_agent.path_desired_distance = 15
	nav_agent.target_desired_distance = 15
	
	$CharacterSkeleton.generate_character()
	
	SignalBus.connect("tick_update", _tick_update)
	
	effect_bar.visible = false
	effect_bar.value = 0
##

func leaving():
	return unkind_leave or kind_leave
##

func is_interacting_with_player():
	return effect_bar.visible
##

func _tick_update():
	if falling == false:
		if nav_agent.is_navigation_finished() and !leaving() and !is_interacting_with_player():
			if arrived == false:
				arrived = true
				target.boss_arrived()
			##
		elif is_interacting_with_player() and arrived:
			target.boss_gone()
			arrived = false
		##
		
		if unkind_leave == true and nav_agent.is_navigation_finished():
			SignalBus.emit_signal("dickhead_removed")
			queue_free()
		##
		
		if kind_leave == true and nav_agent.is_navigation_finished():
			SignalBus.emit_signal("dickhead_left")
			queue_free()
		##
		
		if being_burned:
			if burn_countdown > 0:
				burn_countdown -= 1
			else:
				being_burned = false
				unkind_leave = true
				nav_agent.target_position = leave_target
			##
		##
	##
##

func fall():
	if falling == false:
		$CharacterSkeleton/AnimationPlayer.play("Falling")
		falling = true
	##
	if $CharacterSkeleton/AnimationPlayer.is_playing() == false:
		SignalBus.emit_signal("dickhead_died")
		queue_free()
		return true
	##
	return false
##

func set_target(targ_worker):
	target = targ_worker
	nav_agent.target_position = target.global_position
##

func set_leave(leave_targ):
	leave_target = leave_targ
##

func _physics_process(delta):
	if falling == false:
		if blowing_away:
			if velocity.length() < 5:
				velocity = Vector2.ZERO
				collision_mask &= 4
				collision_mask |= 8
				unkind_leave = true
				nav_agent.target_position = leave_target
				blowing_away = false
			##
			
			velocity /= 1 + lerpf(0, DRAG, 0.2)
		else:
			velocity = _velocity_from_path()
			
			if velocity.is_equal_approx(Vector2.ZERO) and being_burned:
				nav_agent.target_position = get_parent().pick_position()
			##
		##
	##
	
	move_and_slide()
##

func _dist_to_target():
	return global_position.distance_to(target.global_position)
##

func _velocity_from_path():
	if nav_agent.is_navigation_finished():
		return Vector2.ZERO
	##

	return global_position.direction_to(nav_agent.get_next_path_position()) * MOVEMENT_SPEED
##

func show_effect_bar():
	if blowing_away == false and being_burned == false:
		effect_bar.visible = true
	##
##

func hide_effect_bar():
	effect_bar.value = 0
	effect_bar.visible = false
##

func update_effect_bar(curr_val:int, max_val:int):
	if blowing_away == false and being_burned == false:
		effect_bar.value = clampi((curr_val / float(max_val)) * 100, 0, 100)
	##
##

func apply_blowie_effect():
	if blowing_away == false:
		blowing_away = true
	else:
		return
	##
	
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
	if being_burned == false:
		being_burned = true
	else:
		return
	##
	
	hide_effect_bar()
	
	burn_countdown = randi_range(BURN_COUNTDOWN.x, BURN_COUNTDOWN.y)
	
	nav_agent.target_position = get_parent().pick_position()
##

func apply_moneybags_effect():
	if bullshitted == false:
		bullshitted = true
	else:
		return
	##
	
	hide_effect_bar()
	
	kind_leave = true
	nav_agent.target_position = leave_target
##
