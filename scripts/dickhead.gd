extends CharacterBody2D
class_name Dickhead

@export_group("Movement")
@export var MOVEMENT_SPEED:float = 400.0

@export_group("Being Blown")
@export var BLOW_FORCE:float = 1500.0
@export var DRAG:float = 200.0

@export_group("Burning")
@export var BURN_SPEED:float = 600.0
@export var BURN_TICK_CD:int = 12

@export_group("Bloviation")
@export var BLOVIATION_CD:Vector2 = Vector2i(6, 12)

#############################################################

@onready var nav_agent = $NavAgent

var annoy_worker:bool = false
var target:Worker
var arrived:bool = false

var interacting_with_player:bool = false
var indisposed:bool = false

var being_blown:bool = false
var dir_from_player_to_me:Vector2

var being_burned:bool = false
var burning_countdown:int = 0

var being_bloviated:bool = false
var bloviation_countdown:int = 4

var leave_target:Vector2
var unkind_leave:bool = false
var kind_leave:bool = false

var falling:bool = false

func _ready():
	nav_agent.path_desired_distance = 15
	nav_agent.target_desired_distance = 15
	
	$CharacterSkeleton.generate_character()
	
	SignalBus.connect("tick_update", _tick_update)
##

func _process(delta):
	pass
##

func _tick_update():
	if falling == false:
		if unkind_leave == false and kind_leave == false and _dist_to_target() < 25 \
			and indisposed == false:
			if arrived == false:
				arrived = true
				target.boss_arrived()
			##
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
			burning_countdown -= 1
			
			if burning_countdown <= 0:
				being_burned = false
				unkind_leave = true
				indisposed = false
				nav_agent.target_position = leave_target
				burning_countdown = 0
			##
		##
		
		if being_bloviated:
			bloviation_countdown -= 1
			
			if bloviation_countdown <= 0:
				kind_leave = true
				nav_agent.target_position = leave_target
			##
		##
	##
##

func bloviate():
	if being_bloviated == false:
		indisposed = true
		being_bloviated = true
		bloviation_countdown = 4
	##
##

func not_bloviating():
	indisposed = false
	being_bloviated = false
##

func burning():
	if being_burned == false:
		being_burned = true
		indisposed = true
		nav_agent.target_position = get_parent().pick_position()
	##
	burning_countdown = BURN_TICK_CD
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

func get_blown_away(player_pos):
	indisposed = true
	arrived = false
	target.boss_gone()
	being_blown = true
	velocity = Vector2.ZERO
	
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

func not_being_blown():
	indisposed = false
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
		if being_blown:
			if indisposed:
				velocity = lerpf(0, BLOW_FORCE, 0.7) * dir_from_player_to_me
			else:
				if velocity.length() < 2:
					being_blown = false
					velocity = Vector2.ZERO
					collision_mask &= 4
					collision_mask |= 8
					unkind_leave = true
					nav_agent.target_position = leave_target
				else:
					velocity /= 1 + lerpf(0, DRAG, 0.3)
				##
			##
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
