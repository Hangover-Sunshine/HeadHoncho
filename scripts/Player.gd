extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var SPEED:float = 300.0
@export var HEAD_MOVE_PENALTY:float = 0.5

@export_group("Head Info")
@export var GROUP_DESTRESS:int = 10
@export var HEAL_WINDUP:Vector2i = Vector2i(6, 6)
@export var AOE_HEAL_WINDUP:Vector2i = Vector2i(8, 8)
@export var BUY_WORKER_WINDUP:Vector2i = Vector2i(4, 4)
@export var COVEFE_WINDUP:Vector2i = Vector2i(4, 4)
@export var BLOWIE_WINDUP:Vector2i = Vector2i(4, 4)

##########################################################################

@onready var hands = $CharacterSkeleton/Sprites/Hands

enum Heads {
	FUCK_HEAD,		# relax head
	BLOW_HEAD,		# ac head
	COVEFE_HEAD		# coffee head
}

var can_be_controlled:bool = true
var falling:bool = false
var use_head:bool = false

var worker_in_path = []
var dickheads_in_path = []
var open_seats_nearby = []

var skin_color:int = 0

func _ready():
	$CharacterSkeleton.set_head(Heads.BLOW_HEAD)
	$TickReceiver.set_head(Heads.BLOW_HEAD)
	
	hands.frame_coords = Vector2i(0, skin_color)
	
	$EffectBar.visible = false
##

func _input(event):
	if event.is_action_pressed("head_interaction"):
		use_head = true
	elif event.is_action_released("head_interaction"):
		use_head = false
	##
	
	if event.is_action_pressed("blow_head_hk") and use_head == false:
		$CharacterSkeleton.set_head(Heads.BLOW_HEAD)
		$TickReceiver.set_head(Heads.BLOW_HEAD)
		SignalBus.emit_signal("not_money_bags")
	##
	if event.is_action_pressed("coffee_head_hk") and use_head == false:
		$CharacterSkeleton.set_head(Heads.COVEFE_HEAD)
		$TickReceiver.set_head(Heads.COVEFE_HEAD)
		SignalBus.emit_signal("not_money_bags")
	##
	if event.is_action_pressed("fuck_head_hk") and use_head == false:
		$CharacterSkeleton.set_head(Heads.FUCK_HEAD)
		$TickReceiver.set_head(Heads.FUCK_HEAD)
		SignalBus.emit_signal("is_money_bags")
	##
##

func _physics_process(delta):
	if can_be_controlled and use_head == false:
		var dir = Vector2(Input.get_axis("right", "left"), Input.get_axis("up", "down"))
		velocity = dir * SPEED
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

func _on_basic_head_area_entered(area):
	if area.is_in_group("seats"):
		open_seats_nearby.append(area.get_parent())
	##
##

func _on_basic_head_area_exited(area):
	var indx = open_seats_nearby.find(area.get_parent())
	if indx != -1:
		open_seats_nearby.remove_at(indx)
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

func get_list_to_iterate(curr_head) -> Array:
	if len(dickheads_in_path) > 0:
		$CharacterSkeleton.talking = true
		$CharacterSkeleton.aoe_healing = false
		return dickheads_in_path
	elif len(worker_in_path) > 0:
		$CharacterSkeleton.talking = true
		$CharacterSkeleton.aoe_healing = false
		return worker_in_path
	elif curr_head == Heads.BLOW_HEAD or curr_head == Heads.COVEFE_HEAD:
		# if we're either blowie or covefe, don't look at the open seats
		return []
	elif len(open_seats_nearby) > 0:
		$CharacterSkeleton.talking = true
		$CharacterSkeleton.aoe_healing = false
		return open_seats_nearby
	##
	
	$CharacterSkeleton.talking = false
	$CharacterSkeleton.aoe_healing = true
	return []
##
