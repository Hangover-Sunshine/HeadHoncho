extends CharacterBody2D

@export var MoveSpeed:float = 250

func _process(_delta):
	pass
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
	
	velocity = velocity.normalized() * MoveSpeed
	move_and_slide()
##
