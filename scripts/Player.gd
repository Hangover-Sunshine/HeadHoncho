extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var SPEED:float = 300.0
@export var HEAD_MOVE_PENALTY:float = 0.5

@export_group("Head Benefits")
@export var ADD_ENERGY:int = 20
@export var COOLDOWN_WORKER:int = 20
@export var INDIV_DESTRESS:int = 20
@export var GROUP_DESTRESS:int = 10

@export_group("Head Drawbacks")
@export var HEAL_WINDUP:Vector2i = Vector2i(6, 6)

##########################################################################

@onready var head = $CharacterSkeleton/Sprites/Head
@onready var hands = $CharacterSkeleton/Sprites/Hands
@onready var clothes = $CharacterSkeleton/Sprites/Clothes

@onready var animation_player = $CharacterSkeleton/AnimationPlayer

@onready var rotator = $Rotator

@onready var basic_head_area = $Rotator/BasicHeadArea
@onready var fuck_head_zone = $Rotator/FuckHeadArea

@onready var effect_bar = $EffectBar

enum Heads {
	FUCK_HEAD,		# relax head
	BLOW_HEAD,		# ac head
	COVEFE_HEAD		# coffee head
}

var can_be_controlled:bool = true

var curr_head:Heads = Heads.BLOW_HEAD
var use_head:bool = false
var worker_in_path = []
var dickheads_in_path = []
var open_seats_nearby = []

var direction:Vector2 = Vector2.ZERO
var last_key_dir:Vector2 = Vector2(1, 0)
var last_key_dir_save:Vector2

var head_coords:Vector2i = Vector2i.ZERO
var skin_color:int = 0

var falling:bool = false

func _ready():
	hands.frame_coords = Vector2i(0, skin_color)
	SignalBus.connect("tick_update", _tick_update_receiver)
	effect_bar.visible = false
##

func _input(event):
	if event.is_action_pressed("head_interaction"):
		use_head = true
	elif event.is_action_released("head_interaction"):
		use_head = false
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
		head_coords.y = 2
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
		##
	else:
		head.frame_coords = head_coords
	##
##

func _physics_process(delta):
	if can_be_controlled:
		var dir = Vector2(Input.get_axis("right", "left"), Input.get_axis("up", "down"))
		
		if use_head:
			dir = Vector2.ZERO
		##
		
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
	else:
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
		dickheads_in_path.remove_at(dickheads_in_path.find(body))
	##
##

func swap_to_normal_head():
	$Rotator/BasicHeadArea/BasicHeadZone.disabled = false
	$Rotator/FuckHeadArea/FuckHeadZone.disabled = true
##

func swap_to_fuck_head():
	$Rotator/BasicHeadArea/BasicHeadZone.disabled = true
	$Rotator/FuckHeadArea/FuckHeadZone.disabled = false
##

func _tick_update_receiver():
	if use_head:
		if curr_head == Heads.BLOW_HEAD:
			for person in dickheads_in_path:
				person.getting_blown(global_position)
			##
			
			if len(dickheads_in_path) == 0:
				for person in worker_in_path:
					person.decrease_temp(COOLDOWN_WORKER)
				##
			##
		##
		
		if curr_head == Heads.COVEFE_HEAD:
			for person in dickheads_in_path:
				person.burning()
			##
			
			if len(dickheads_in_path) == 0:
				for person in worker_in_path:
					person.add_energy(ADD_ENERGY)
				##
			##
		##
		
		if curr_head == Heads.FUCK_HEAD:
			for person in dickheads_in_path:
				person.bloviate()
			##
			
			if len(dickheads_in_path) == 0:
				for person in worker_in_path:
					person.destress(INDIV_DESTRESS)
				##
			##
			
			if len(dickheads_in_path) == 0 and len(worker_in_path) == 0:
				for seat in open_seats_nearby:
					seat.get_parent().hire_worker()
				##
			##
			
			if len(dickheads_in_path) == 0 and len(worker_in_path) == 0 and len(open_seats_nearby) == 0:
				cure_three()
			##
		##
	##
	
	$RaidwideHealComponent.check_for_reset()
		
	if $RaidwideHealComponent.get_level() == 0:
		effect_bar.visible = false
	##
##

func fall():
	if falling == false:
		$CharacterSkeleton/AnimationPlayer.play("Falling")
		falling = true
		can_be_controlled = false
	##
	if $CharacterSkeleton/AnimationPlayer.is_playing() == false:
		SignalBus.emit_signal("player_jumped_out_window")
		return true
	##
	return false
##

func _on_fuck_head_area_area_entered(area):
	if area.is_in_group("seats"):
		open_seats_nearby.append(area)
	##
##

func _on_fuck_head_area_area_exited(area):
	var indx = open_seats_nearby.find(area)
	if indx != -1:
		open_seats_nearby.remove_at(indx)
	##
##

func cure_three(): # is that a final fantasy reference?!
	if $RaidwideHealComponent.get_level() == 0:
		$RaidwideHealComponent.generate_new_max(4, 4)
		effect_bar.visible = true
		effect_bar.value = 0
	##
	
	var result:int = $RaidwideHealComponent.tick()
	
	effect_bar.value = clampi((result / float(4)) * 100, 0, 100)
	
	if result >= 4:
		$RaidwideHealComponent.reset_tick_count()
		$RaidwideHealComponent.set_level(1)
		SignalBus.emit_signal("aoe_heal", GROUP_DESTRESS)
	##
##
