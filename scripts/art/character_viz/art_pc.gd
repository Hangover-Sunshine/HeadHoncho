extends Node2D

## Variable holds specific skin toned face of character.
@onready var face
#

##
func _ready():
	assign_skin()

func assign_skin():
	$Skeleton/Hands.frame = randi() % 3
#

## Assign head
func equip_fan():
	$Skeleton/Head/Fan.visible = true
	$Skeleton/Head/Coffee.visible = false
	$Skeleton/Head/Briefcase.visible = false

func equip_coffee():
	$Skeleton/Head/Fan.visible = false
	$Skeleton/Head/Coffee.visible = true
	$Skeleton/Head/Briefcase.visible = false

func equip_briefcase():
	$Skeleton/Head/Fan.visible = false
	$Skeleton/Head/Coffee.visible = false
	$Skeleton/Head/Briefcase.visible = true

## Animations
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
#
