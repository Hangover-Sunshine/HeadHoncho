extends CharacterBody2D
class_name Dickhead

@export_group("Movement")
@export var MOVEMENT_SPEED:float = 400.0

@export_group("Being Blown")
@export var BLOW_FORCE:float = 1500.0
@export var DRAG:float = 200.0
@export var BLOW_CD:Vector2i = Vector2i(6, 12)

@export_group("Burning")
@export var BURN_SPEED:float = 600.0
@export var BURN_TICK_CD:Vector2i = Vector2i(6, 12)
@export var BURN_END_CD:Vector2i = Vector2i(10, 14)

@export_group("Bloviation")
@export var BLOVIATION_CD:Vector2i = Vector2i(6, 12)

#############################################################

@onready var nav_agent = $NavAgent
@onready var effect_progress = $EffectProgress

var annoy_worker:bool = false
var target:Worker
var arrived:bool = false

var interacting_with_player:bool = false
var indisposed:bool = false

var blow_level_cd:int = 0
var blow_finished_cd:int = 4
var prev_blow_tick_count:int = -1
# 0 - nothing, 1 - being blown, 2 - gone
var blow_level:int = 0
var dir_from_player_to_me:Vector2

var burn_tick_count:int = 0
var burning_finished_cd:int = 4
var prev_burn_tick_count:int = -1
var burndown_cd:int = 0
var burndown_finished_cd:int = 4
# 0 - nothing, 1 - being blown, 2 - gone
var burning_level:int = 0

var bloviation_countdown:int = 0
var blovation_cd_start:int = 4
var prev_bloviating_tick_count:int = -1
# 0 - nothing, 1 - being blown, 2 - gone
var bloviating_level:int = 0

var leave_target:Vector2
var unkind_leave:bool = false
var kind_leave:bool = false

var falling:bool = false

func _ready():
	nav_agent.path_desired_distance = 15
	nav_agent.target_desired_distance = 15
	
	$CharacterSkeleton.generate_character()
	
	SignalBus.connect("tick_update", _tick_update)
	
	effect_progress.visible = false
	effect_progress.value = 0
##

func _tick_update():
	if falling == false:
		if nav_agent.is_navigation_finished():
			print('hello there')
		if nav_agent.is_navigation_finished() and blow_level == 0 and burning_level == 0 and\
			bloviating_level == 0:
			if arrived == false:
				arrived = true
				target.boss_arrived()
			##
		elif blow_level != 0 or burning_level != 0 or bloviating_level != 0 and arrived:
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
		
		if blow_level_cd == prev_blow_tick_count:
			if blow_level == 2:
				blow_level_cd = 0
				blow_level = 3
			elif blow_level == 1:
				blow_level = 0
				blow_level_cd = 0
				effect_progress.visible = false
			##
		##
		
		prev_blow_tick_count = blow_level_cd
		
		if prev_burn_tick_count == burn_tick_count:
			if burning_level == 1:
				effect_progress.visible = false
				burning_level = 0
				burn_tick_count = 0
			elif burning_level == 2:
				if burndown_cd >= burndown_finished_cd:
					unkind_leave = true
					nav_agent.target_position = leave_target
					burndown_cd = 0
					burning_level = 0
					burn_tick_count = 0
				else:
					burndown_cd += 1
				##
			##
		##
		
		prev_burn_tick_count = burn_tick_count
		
		if bloviation_countdown == prev_bloviating_tick_count:
			if bloviating_level == 1:
				effect_progress.visible = false
				bloviation_countdown = 0
				bloviating_level = 0
			##
		##
		
		prev_bloviating_tick_count = bloviation_countdown
	##
##

func bloviate():
	if bloviating_level == 2:
		return
	##
	
	if bloviating_level == 0:
		bloviating_level = 1
		effect_progress.visible = true
	##
	
	bloviation_countdown += 1
	effect_progress.value = clampi((bloviation_countdown / float(blovation_cd_start)) * 100, 0, 100)
	
	if bloviation_countdown >= blovation_cd_start:
		effect_progress.visible = false
		bloviating_level = 2
		kind_leave = true
		nav_agent.target_position = leave_target
	##
##

func burning():
	if burning_level == 2:
		return
	##
	
	if burning_level == 0:
		burning_level = 1
		effect_progress.visible = true
	##
	
	burn_tick_count += 1
	
	effect_progress.value = clampi((burn_tick_count / float(burning_finished_cd)) * 100, 0, 100)
	
	if burn_tick_count >= burning_finished_cd:
		effect_progress.visible = false
		burning_level = 2
		nav_agent.target_position = get_parent().pick_position()
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

func getting_blown(player_pos):
	if blow_level == 2:
		return
	##
	
	if blow_level == 0:
		blow_level = 1
		effect_progress.visible = true
	##
	
	blow_level_cd += 1
	effect_progress.value = clampi((blow_level_cd / float(blow_finished_cd)) * 100, 0, 100)
	
	if blow_level_cd >= blow_finished_cd:
		effect_progress.visible = false
		blow_level = 2
		
		dir_from_player_to_me = global_position - player_pos
	
		if abs(dir_from_player_to_me.y) > abs(dir_from_player_to_me.x):
			dir_from_player_to_me.x = 0
		##
		if abs(dir_from_player_to_me.x) > abs(dir_from_player_to_me.y):
			dir_from_player_to_me.y = 0
		##
		
		dir_from_player_to_me = dir_from_player_to_me.normalized()
		
		collision_mask &= 4
		collision_mask |= 16
	##
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
		if blow_level == 2:
			velocity = lerpf(0, BLOW_FORCE, 0.7) * dir_from_player_to_me
		elif blow_level == 3:
			if velocity.length() < 2:
				blow_level == 0
				velocity = Vector2.ZERO
				collision_mask &= 4
				collision_mask |= 8
				unkind_leave = true
				nav_agent.target_position = leave_target
			else:
				velocity /= 1 + lerpf(0, DRAG, 0.3)
			##
		else:
			velocity = _velocity_from_path()
			if velocity.is_equal_approx(Vector2.ZERO) and burning_level == 2:
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
