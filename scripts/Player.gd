extends CharacterBody2D

@export_group("Movement")
@export var SPEED:float = 300.0
@export var HEAD_MOVE_PENALTY:float = 0.5

@export_group("Head Benefits")
@export var ADD_ENERGY:int = 20
@export var COOLDOWN_WORKER:int = 20
@export var STRESS_TICK_COUNTDOWN:int = 8

@onready var rotator = $Rotator

@onready var head_power_zone = $Rotator/HeadPowerZone
@onready var basic_head_zone = $Rotator/HeadPowerZone/BasicHeadZone
@onready var fuck_head_zone = $Rotator/HeadPowerZone/FuckHeadZone

enum Heads {
	MONEY_HEAD,		# HR mode
	FUCK_HEAD,		# relax head
	BLOW_HEAD,		# ac head
	COVEFE_HEAD,	# coffee head
}

var curr_head:Heads = Heads.BLOW_HEAD
var direction:Vector2 = Vector2.ZERO
var use_head:bool = false
var last_key_dir:Vector2 = Vector2(1, 0)

func _ready():
	pass
##

func _input(event):
	if event.is_action_pressed("up"):
		direction.y -= 1
		last_key_dir.y = -1
		last_key_dir.x = 0
	elif event.is_action_released("up"):
		direction.y += 1
	##
	
	if event.is_action_pressed("down"):
		direction.y += 1
		last_key_dir.y = 1
		last_key_dir.x = 0
	elif event.is_action_released("down"):
		direction.y -= 1
	##
	
	if event.is_action_pressed("left"):
		direction.x += 1
		last_key_dir.y = 0
		last_key_dir.x = 1
	elif event.is_action_released("left"):
		direction.x -= 1
	##
	
	if event.is_action_pressed("right"):
		direction.x -= 1
		last_key_dir.y = 0
		last_key_dir.x = -1
	elif event.is_action_released("right"):
		direction.x += 1
	##
	
	if event.is_action_pressed("head_interaction"):
		use_head = true
	elif event.is_action_released("head_interaction"):
		use_head = false
	##
	
	if event.is_action_pressed("blow_head_hk"):
		curr_head = Heads.BLOW_HEAD
		basic_head_zone.disabled = false
		fuck_head_zone.disabled = true
	##
	if event.is_action_pressed("coffee_head_hk"):
		curr_head = Heads.COVEFE_HEAD
		basic_head_zone.disabled = false
		fuck_head_zone.disabled = true
	##
	if event.is_action_pressed("fuck_head_hk"):
		curr_head = Heads.FUCK_HEAD
		basic_head_zone.disabled = true
		fuck_head_zone.disabled = false
	##
##

func _physics_process(delta):
	velocity = direction * SPEED
	if use_head:
		if curr_head == Heads.FUCK_HEAD:
			velocity = Vector2.ZERO
		else:
			velocity *= HEAD_MOVE_PENALTY
		##
	##
	move_and_slide()
	
	# now update the zones
	if last_key_dir.x == 0:
		if last_key_dir.y == 1:
			rotator.rotation_degrees = 90
		else:
			rotator.rotation_degrees = 270
		##
	##
	
	if last_key_dir.y == 0:
		if last_key_dir.x == 1:
			rotator.rotation_degrees = 0
		else:
			rotator.rotation_degrees = 180
		##
	##
##
