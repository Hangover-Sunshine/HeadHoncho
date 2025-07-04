extends Node2D

## Variable holds specific skin toned face of character.
@onready var face
@onready var head = 0
#

##
func _ready():
	assign_skin()
	go_idle()
	equip_fan()

func assign_skin():
	$PC/Skeleton/Hands.frame = randi() % 3
#

## Assign head
func equip_fan():
	$PC/Skeleton/Head/Fan.visible = true
	$PC/Skeleton/Head/Coffee.visible = false
	$PC/Skeleton/Head/Briefcase.visible = false
	head = 0

func equip_coffee():
	$PC/Skeleton/Head/Fan.visible = false
	$PC/Skeleton/Head/Coffee.visible = true
	$PC/Skeleton/Head/Briefcase.visible = false
	head = 1

func equip_briefcase():
	$PC/Skeleton/Head/Fan.visible = false
	$PC/Skeleton/Head/Coffee.visible = false
	$PC/Skeleton/Head/Briefcase.visible = true
	head = 2
#

## Movement animations
func go_idle():
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Idle")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 1

func go_walk():
	var anim_length = $AP_Motion.get_animation("Walk").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Walk")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 1

func go_fall():
	$AP_Motion.play("Fall")
#

## Head animations; 0 = fan, 1 = cafe, 2 = brief
func activate_head():
	$AP_Charge.play("Charge")
	if head == 0:
		$PC/Skeleton/Head/Fan/AP_Fan.play("Blow")
		$PC/Skeleton/Head/Fan/CPU_FX_Charge_Wind.emitting = true
	elif head == 1:
		$PC/Skeleton/Head/Coffee/AP_Coffee.play("Brew")
	elif head == 2:
		$PC/Skeleton/Head/Briefcase/AP_Briefcase.play("Shake")

func idle_head():
	if head == 0:
		$PC/Skeleton/Head/Fan/AP_Fan.play("Idle")
	if head == 1:
		$PC/Skeleton/Head/Coffee/AP_Coffee.play("Idle")
	elif head == 2:
		$PC/Skeleton/Head/Briefcase/AP_Briefcase.play("Idle")

func activate_aoe():
	if head == 0:
		$FX_Fore/CPU_FX_Blow.emitting = true
		$PC/Skeleton/Head/Fan/CPU_FX_Charge_Wind.emitting = false
	if head == 1:
		$FX_Fore/CPU_FX_Coffee.emitting = true
	elif head == 2:
		$FX_Fore/CPU_FX_Money.emitting = true
		$FX_Fore/CPU_FX_Coins.emitting = true

func open_briefcase():
	if head == 2:
		$PC/Skeleton/Head/Briefcase/AP_Briefcase2.play("Open")
#
