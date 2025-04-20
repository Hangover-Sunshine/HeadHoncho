extends Node2D

## Variable holds specific skin toned face of character.
@onready var face
#

##
func _ready():
	assign_face()
	be_meh()
	go_idle()

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
#

## Changes face of character depending on state.
func be_asleep():
	face.frame = 5

func be_happy():
	face.frame = 6
	
func be_meh():
	face.frame = 7

func be_stressed():
	face.frame = 8

func be_onfire():
	face.frame = 9
#
