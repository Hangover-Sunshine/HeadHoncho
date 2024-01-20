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

@export_group("Head Windups")
@export var HEAL_WINDUP:Vector2i = Vector2i(6, 6)

##########################################################################

@onready var head = $CharacterSkeleton/Sprites/Head
@onready var hands = $CharacterSkeleton/Sprites/Hands
@onready var clothes = $CharacterSkeleton/Sprites/Clothes

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

var skin_color:int = 0

var falling:bool = false

func _ready():
	$CharacterSkeleton.set_head(curr_head)
	hands.frame_coords = Vector2i(0, skin_color)
	effect_bar.visible = false
##

func _input(event):
	if event.is_action_pressed("head_interaction"):
		use_head = true
	elif event.is_action_released("head_interaction"):
		use_head = false
	##
	
	if event.is_action_pressed("blow_head_hk") and use_head == false:
		curr_head = Heads.BLOW_HEAD
		$CharacterSkeleton.set_head(curr_head)
		SignalBus.emit_signal("not_money_bags")
	##
	if event.is_action_pressed("coffee_head_hk") and use_head == false:
		curr_head = Heads.COVEFE_HEAD
		$CharacterSkeleton.set_head(curr_head)
		SignalBus.emit_signal("not_money_bags")
	##
	if event.is_action_pressed("fuck_head_hk") and use_head == false:
		curr_head = Heads.FUCK_HEAD
		$CharacterSkeleton.set_head(curr_head)
		SignalBus.emit_signal("is_money_bags")
	##
##

func _physics_process(delta):
	if can_be_controlled:
		var dir = Vector2(Input.get_axis("right", "left"), Input.get_axis("up", "down"))
		
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

func fall():
	if falling == false:
		SignalBus.emit_signal("player_jumped_out_window")
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

func _on_basic_head_area_entered(area):
	if area.is_in_group("seats"):
		open_seats_nearby.append(area)
	##
##

func _on_basic_head_area_exited(area):
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
