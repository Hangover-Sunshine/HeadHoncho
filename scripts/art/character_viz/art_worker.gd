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

## Changes face of character depending on state.
func be_asleep():
	face.frame = 0
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Idle")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 0.5

func be_happy():
	face.frame = 1
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Idle")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 0.75
	
func be_meh():
	face.frame = 2
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Idle")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 1

func be_stressed():
	face.frame = 3
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Idle")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 1.5

func be_onfire():
	face.frame = 4
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Idle")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 2

func go_explode():
	$AP_Motion.play("Fall")
#
