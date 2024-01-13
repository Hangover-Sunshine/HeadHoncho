extends CharacterBody2D

@export_group("Movement")
@export var SPEED:float = 300.0
@export var HEAD_MOVE_PENALTY:float = 0.5

@export_group("Head Benefits")
@export var ADD_ENERGY:int = 20
@export var ADD_ENERGY_TR:int = 4
@export var COOLDOWN_WORKER:int = 20
@export var COOLDOWN_TR:int = 4
@export var DESTRESS_TICK_RATE:int = 2

@onready var rotator = $Rotator

@onready var basic_head_area = $Rotator/BasicHeadArea
@onready var fuck_head_zone = $Rotator/FuckHeadArea

enum Heads {
	MONEY_HEAD,		# HR mode
	FUCK_HEAD,		# relax head
	BLOW_HEAD,		# ac head
	COVEFE_HEAD		# coffee head
}

var curr_head:Heads = Heads.BLOW_HEAD
var use_head:bool = false
var workers_in_path = []
var dickheads_in_path = []
var ticks_passed:int = 0

var direction:Vector2 = Vector2.ZERO
var last_key_dir:Vector2 = Vector2(1, 0)

func _ready():
	get_parent().connect("tick_update", _tick_update_receiver)
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
		ticks_passed = 0
	##
	
	if event.is_action_pressed("blow_head_hk") and use_head == false:
		curr_head = Heads.BLOW_HEAD
		basic_head_area.monitoring = true
		basic_head_area.monitorable = true
		fuck_head_zone.monitoring = false
		fuck_head_zone.monitorable = false
	##
	if event.is_action_pressed("coffee_head_hk") and use_head == false:
		curr_head = Heads.COVEFE_HEAD
		basic_head_area.monitoring = true
		basic_head_area.monitorable = true
		fuck_head_zone.monitoring = false
		fuck_head_zone.monitorable = false
	##
	if event.is_action_pressed("fuck_head_hk") and use_head == false:
		curr_head = Heads.FUCK_HEAD
		basic_head_area.monitoring = false
		basic_head_area.monitorable = false
		fuck_head_zone.monitoring = true
		fuck_head_zone.monitorable = true
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

func _on_body_entered_area(body):
	if body is Worker:
		workers_in_path.append(body)
	##
##

func _on_body_exited_area(body):
	if body is Worker:
		workers_in_path.remove_at(workers_in_path.find(body))
	##
##

func _tick_update_receiver():
	if use_head:
		ticks_passed += 1
		
		if curr_head == Heads.BLOW_HEAD and ticks_passed >= COOLDOWN_TR:
			ticks_passed = 0
			
			for worker in workers_in_path:
				worker.decrease_temp(COOLDOWN_WORKER)
			##
		##
		
		if curr_head == Heads.COVEFE_HEAD and ticks_passed >= ADD_ENERGY_TR:
			ticks_passed = 0
			
			for worker in workers_in_path:
				worker.add_energy(ADD_ENERGY)
			##
		##
		
		if curr_head == Heads.FUCK_HEAD and ticks_passed >= DESTRESS_TICK_RATE:
			ticks_passed = 0
			
			for worker in workers_in_path:
				worker.destress()
			##
		##
	##
##
