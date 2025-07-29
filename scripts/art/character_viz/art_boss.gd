extends Node2D

## Variable holds specific skin toned face of character.
@onready var face
#

##
func _ready():
	assign_face()

func assign_face():
	if $Skeleton/Head/Ginger.visible == true and \
	$Skeleton/Head/Berry.visible == false and \
	$Skeleton/Head/Cocoa.visible == false:
		face = $Skeleton/Head/Ginger/Face
	elif $Skeleton/Head/Ginger.visible == false and \
	$Skeleton/Head/Berry.visible == true and \
	$Skeleton/Head/Cocoa.visible == false:
		face = $Skeleton/Head/Berry/Face
	elif $Skeleton/Head/Ginger.visible == false and \
	$Skeleton/Head/Berry.visible == false and \
	$Skeleton/Head/Cocoa.visible == true:
		face = $Skeleton/Head/Cocoa/Face
#

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

func go_run():
	var anim_length = $AP_Motion.get_animation("Walk").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Walk")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 1.5
##

func go_fall():
	$AP_Motion.play("Fall")
#

## Changes face of character depending on state / activates some 
##func be_asleep(): 
	##face.frame = 5

func be_happy():  ##  trigger when briefcased
	face.frame = 6
	
func be_meh():  ## neutral state, trigger back to if needed
	face.frame = 7

func be_blowned(): ## trigger when blown by fan
	face.frame = 8

func be_onfire(): ## trigger when given coffee
	face.frame = 9
	$FX_Back/CPU_FX_Fire.emitting = true
#

func stop_fire(): ## trigger when given coffee
	$FX_Back/CPU_FX_Fire.emitting = false
#
