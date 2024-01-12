extends CharacterBody2D

@export var SPEED:float = 300.0

enum Heads {
	NO_HEAD,		# default for the moment
	FUCK_HEAD,		# relax head
	BLOW_HEAD,		# ac head
	COVEFE_HEAD,	# coffee head
	HR_HEAD			# can't actually be in this one during gameplay
}

var curr_head:Heads = Heads.NO_HEAD
var direction:Vector2 = Vector2.ZERO

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
##

func _physics_process(delta):
	velocity = direction * SPEED
	move_and_slide()
##
