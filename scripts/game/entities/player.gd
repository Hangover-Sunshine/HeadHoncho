extends CharacterBody2D

@export var MoveSpeed:float = 250
@export var PenaltyWhileAbilityActive:float = 0.75
@export var EnergyIncreasePerTick:float = 2

var _use_head:bool = false
var _selected_body

func _input(event):
	if event.is_action_pressed("primary"):
		_use_head = true
	##
	if event.is_action_released("primary"):
		_use_head = false
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
