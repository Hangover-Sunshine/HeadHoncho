extends CharacterBody2D
class_name Player

@export var MoveSpeed:float = 250
@export var PenaltyWhileAbilityActive:float = 0.75
@export_range(0, 15) var EnergyIncreasePerTick:float = 2
@export_range(-15, 0) var EnergyDecreasePerTick:float = -2

enum PlayerHead {
	COFFEE,
	FAN,
	BRIEF_CASE,
	FUCKHEAD
}

var _curr_head:PlayerHead = PlayerHead.COFFEE
var _use_head:bool = false
var _selected_body

func _input(event):
	if event.is_action_pressed("primary"):
		_use_head = true
	##
	if event.is_action_released("primary"):
		_use_head = false
	##
	
	if event.is_action_pressed("coffee"):
		_curr_head = PlayerHead.COFFEE
	##
	if event.is_action_pressed("fan"):
		_curr_head = PlayerHead.FAN
	##
	if event.is_action_pressed("brief_case"):
		_curr_head = PlayerHead.BRIEF_CASE
	##
##

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity += Vector2(0, -1)
		$Pivot.rotation_degrees = 90
	##
	if Input.is_action_pressed("down"):
		velocity += Vector2(0, 1)
		$Pivot.rotation_degrees = 270
	##
	if Input.is_action_pressed("left"):
		velocity += Vector2(-1, 0)
		$Pivot.rotation_degrees = 0
	##
	if Input.is_action_pressed("right"):
		velocity += Vector2(1, 0)
		$Pivot.rotation_degrees = 180
	##
	
	velocity = velocity.normalized() * MoveSpeed * (PenaltyWhileAbilityActive if _use_head else 1)
	move_and_slide()
##

func _on_single_target_area_body_entered(body):
	_selected_body = body
##

func _on_single_target_area_body_exited(body):
	if _selected_body == body:
		_selected_body = null
	##
##

func get_affecting_body():
	if _use_head:
		return _selected_body
	##
	return null
##

func get_current_head():
	return _curr_head
##

func _on_single_target_area_entered(area):
	_selected_body = area
##

func _on_single_target_area_exited(area):
	if _selected_body == area:
		_selected_body = null
	##
##
