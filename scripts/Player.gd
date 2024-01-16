extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var SPEED:float = 300.0
@export var HEAD_MOVE_PENALTY:float = 0.5

@export_group("Head Benefits")
@export var ADD_ENERGY:int = 20
@export var ADD_ENERGY_TR:int = 4
@export var COOLDOWN_WORKER:int = 20
@export var COOLDOWN_TR:int = 4
@export var DESTRESS_TICK_RATE:int = 2

##########################################################################

@onready var head = $CharacterSkeleton/Sprites/Head
@onready var hands = $CharacterSkeleton/Sprites/Hands
@onready var clothes = $CharacterSkeleton/Sprites/Clothes

@onready var animation_player = $CharacterSkeleton/AnimationPlayer

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
var worker_in_path = []
var dickheads_in_path = []
var ticks_passed:int = 0

var direction:Vector2 = Vector2.ZERO
var last_key_dir:Vector2 = Vector2(1, 0)
var last_key_dir_save:Vector2

var head_coords:Vector2i = Vector2i.ZERO
var skin_color:int = 0


func _ready():
	hands.frame_coords = Vector2i(0, skin_color)
	SignalBus.connect("tick_update", _tick_update_receiver)
##

func _input(event):
	if event.is_action_pressed("head_interaction"):
		use_head = true
	elif event.is_action_released("head_interaction"):
		use_head = false
		ticks_passed = 0
		animation_player.stop()
	##
	
	if event.is_action_pressed("blow_head_hk") and use_head == false:
		curr_head = Heads.BLOW_HEAD
		head_coords.x = 0
		head_coords.y = 0
		swap_to_normal_head()
	##
	if event.is_action_pressed("coffee_head_hk") and use_head == false:
		curr_head = Heads.COVEFE_HEAD
		head_coords.x = 1
		head_coords.y = 1
		swap_to_normal_head()
	##
	if event.is_action_pressed("fuck_head_hk") and use_head == false:
		curr_head = Heads.FUCK_HEAD
		head_coords.x = 1
		head_coords.y = 3
		swap_to_fuck_head()
	##
##

func _process(delta):
	if use_head:
		if curr_head == Heads.BLOW_HEAD:
			animation_player.play("Blowing", -1, 2.5)
		elif curr_head == Heads.COVEFE_HEAD:
			animation_player.play("Energizing")
		elif curr_head == Heads.FUCK_HEAD:
			pass
		elif curr_head == Heads.MONEY_HEAD:
			pass
		##
	else:
		head.frame_coords = head_coords
	##
##

func _physics_process(delta):
	var dir = Vector2(Input.get_axis("right", "left"), Input.get_axis("up", "down"))
	
	if dir.length_squared() != 0:
		if dir.x == 0:
			if dir.y == 1:
				rotator.rotation_degrees = 90
			else:
				rotator.rotation_degrees = 270
			##
		##
		
		if dir.y == 0:
			if dir.x == 1:
				rotator.rotation_degrees = 0
			else:
				rotator.rotation_degrees = 180
			##
		##
	##
	
	velocity = dir * SPEED
	
	if use_head:
		velocity = Vector2.ZERO
	##
	
	move_and_slide()
##

func _on_body_entered_area(body):
	if body is Worker:
		worker_in_path.append(body)
	##
	if body is Dickhead:
		dickheads_in_path.append(body)
	##
##

func _on_body_exited_area(body):
	if body is Worker:
		worker_in_path.remove_at(worker_in_path.find(body))
	##
	if body is Dickhead:
		if body.being_blown:
			body.not_being_blown()
		dickheads_in_path.remove_at(dickheads_in_path.find(body))
	##
##

func swap_to_normal_head():
	basic_head_area.monitoring = true
	basic_head_area.monitorable = true
	fuck_head_zone.monitoring = false
	fuck_head_zone.monitorable = false
##

func swap_to_fuck_head():
	basic_head_area.monitoring = false
	basic_head_area.monitorable = false
	fuck_head_zone.monitoring = true
	fuck_head_zone.monitorable = true
##

func _tick_update_receiver():
	if use_head:
		ticks_passed += 1
		
		if curr_head == Heads.BLOW_HEAD and ticks_passed >= COOLDOWN_TR:
			ticks_passed = 0
			
			for person in dickheads_in_path:
				person.get_blown_away(global_position)
			##
			
			if len(dickheads_in_path) == 0:
				for person in worker_in_path:
					person.decrease_temp(COOLDOWN_WORKER)
				##
			##
		##
		
		if curr_head == Heads.COVEFE_HEAD and ticks_passed >= ADD_ENERGY_TR:
			ticks_passed = 0
			
			for person in dickheads_in_path:
				person.burning()
			##
			
			if len(dickheads_in_path) == 0:
				for person in worker_in_path:
					person.add_energy(ADD_ENERGY)
				##
			##
		##
		
		if curr_head == Heads.FUCK_HEAD and ticks_passed >= DESTRESS_TICK_RATE:
			ticks_passed = 0
			
			for person in worker_in_path:
				person.destress()
			##
		##
	else:
		if curr_head == Heads.BLOW_HEAD and ticks_passed >= COOLDOWN_TR:
			for person in dickheads_in_path:
				print("in here asd")
				person.not_being_blown()
			##
		##
	##
##
