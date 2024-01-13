extends CharacterBody2D

@export var SPEED:float = 300.0
@export var HEAD_MOVE_PENALTY:float = 0.5

enum Heads {
	NO_HEAD,		# default for the moment
	FUCK_HEAD,		# relax head
	BLOW_HEAD,		# ac head
	COVEFE_HEAD,	# coffee head
}

var curr_head:Heads = Heads.NO_HEAD
var direction:Vector2 = Vector2.ZERO
var use_head:bool = false

func _ready():
	pass
##

func _input(event):
	if event.is_action_pressed("up"):
		direction.y -= 1
	elif event.is_action_released("up"):
		direction.y += 1
	##
	
	if event.is_action_pressed("down"):
		direction.y += 1
	elif event.is_action_released("down"):
		direction.y -= 1
	##
	
	if event.is_action_pressed("left"):
		direction.x += 1
	elif event.is_action_released("left"):
		direction.x -= 1
	##
	
	if event.is_action_pressed("right"):
		direction.x -= 1
	elif event.is_action_released("right"):
		direction.x += 1
	##
	
	if event.is_action_pressed("head_interaction"):
		use_head = true
	elif event.is_action_released("head_interaction"):
		use_head = false
	##
##

func _physics_process(delta):
	velocity = direction * SPEED
	if use_head:
		if curr_head == Heads.FUCK_HEAD:
			velocity = Vector2.ZERO
		else:
			velocity *= SPEED
		##
	##
	move_and_slide()
##
