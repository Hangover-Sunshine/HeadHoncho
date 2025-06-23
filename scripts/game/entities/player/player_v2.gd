extends CharacterBody2D
class_name PlayerV2

@export var MoveSpeed:float = 250
@export var PenaltyWhileAbilityActive:float = 0.75
@export_range(0, 15) var EnergyIncreasePerTick:float = 2
@export_range(-15, 0) var EnergyDecreasePerTick:float = -2

enum PlayerHead {
	COFFEE,
	FAN,
	BRIEF_CASE
}

var _curr_head:PlayerHead = PlayerHead.COFFEE
var _use_head:bool = false
var _selected_body
var _is_walking:bool = false

var _entities_in_range:Array = []
var _seats_selected:Array[Seat] = []

func _ready():
	$ArtPlayer.go_idle()
	$ArtPlayer.equip_coffee()
##

func _input(event):
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

func _on_single_target_area_entered(area):
	if area is Seat:
		_seats_selected.append(area)
	else:
		_entities_in_range.append(area)
	##
##

func _on_single_target_area_exited(area):
	if area is Seat:
		var indx = _seats_selected.find(area)
		_seats_selected.remove_at(indx)
	else:
		var indx = _entities_in_range.find(area)
		_entities_in_range.remove_at(indx)
	##
##
