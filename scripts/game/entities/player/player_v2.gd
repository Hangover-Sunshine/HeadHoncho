extends CharacterBody2D
class_name PlayerV2

signal player_is_falling
signal player_dead

@export var MoveSpeed:float = 250
@export var PenaltyWhileAbilityActive:float = 0.75
@export var BlowPower:float = 500
@export_range(0, 15) var EnergyIncreasePerTick:float = 2
@export_range(-15, 0) var EnergyDecreasePerTick:float = -2
@export_range(-15, 0) var TempDecreasePerTick:float = -2

enum PlayerHead {
	COFFEE,
	FAN,
	BRIEF_CASE
}

var _curr_head:PlayerHead = PlayerHead.COFFEE
var _use_head:bool = false
var _selected_body
var _is_walking:bool = false
var _is_falling:bool = false
var _finished:bool = false

var _entities_in_range:Array = []
var _seats_selected:Array[Seat] = []

func _ready():
	$ArtPlayer.go_idle()
	$ArtPlayer.equip_coffee()
##

func _input(event):
	if _is_falling:
		return
	##
	
	if event.is_action_pressed("primary"):
		_use_head = true
	##
	if event.is_action_released("primary"):
		_use_head = false
	##
	
	if event.is_action_pressed("coffee"):
		_curr_head = PlayerHead.COFFEE
		$LargeTargetArea/CollisionShape2D.disabled = false
		$SmallTargetArea/CollisionShape2D.disabled = true
		$ArtPlayer.equip_coffee()
	##
	if event.is_action_pressed("fan"):
		_curr_head = PlayerHead.FAN
		$LargeTargetArea/CollisionShape2D.disabled = false
		$SmallTargetArea/CollisionShape2D.disabled = true
		$ArtPlayer.equip_fan()
	##
	if event.is_action_pressed("brief_case"):
		_curr_head = PlayerHead.BRIEF_CASE
		$LargeTargetArea/CollisionShape2D.disabled = true
		$SmallTargetArea/CollisionShape2D.disabled = false
		$ArtPlayer.equip_briefcase()
	##
##

func _physics_process(_delta):
	if _is_falling:
		if $ArtPlayer.is_falling_finished() and !_finished:
			player_dead.emit()
			_finished = true
		##
		return
	##
	
	if _use_head:
		$ArtPlayer.activate_head()
	else:
		$ArtPlayer.idle_head()
	##
	
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity += Vector2(0, -1)
	##
	if Input.is_action_pressed("down"):
		velocity += Vector2(0, 1)
	##
	if Input.is_action_pressed("left"):
		velocity += Vector2(-1, 0)
	##
	if Input.is_action_pressed("right"):
		velocity += Vector2(1, 0)
	##
	
	if velocity.length_squared() != 0 and _is_walking == false:
		$ArtPlayer.go_walk()
		_is_walking = true
	elif velocity.length_squared() == 0 and _is_walking:
		$ArtPlayer.go_idle()
		_is_walking = false
	##
	
	velocity = velocity.normalized() * MoveSpeed * (PenaltyWhileAbilityActive if _use_head else 1)
	move_and_slide()
##

func get_affected_bodies():
	if _use_head:
		return _entities_in_range
	##
	return []
##

func get_affected_seats():
	if _use_head:
		return _seats_selected
	##
	return []
##

func get_current_head():
	return _curr_head
##

func is_falling():
	$ArtPlayer.go_fall()
	_is_falling = true
	player_is_falling.emit()
##

func _on_single_target_area_entered(area):
	_seats_selected.append(area)
##

func _on_single_target_body_entered(body):
	_entities_in_range.append(body)
##

func _on_single_target_area_exited(area):
	var indx = _seats_selected.find(area)
	_seats_selected.remove_at(indx)
##

func _on_single_target_body_exited(body):
	var indx = _entities_in_range.find(body)
	_entities_in_range.remove_at(indx)
##
