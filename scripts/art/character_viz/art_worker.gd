extends Node2D

## Variable holds specific skin toned face of character.
@onready var face
@onready var prev_pb_value
#

## Modulation colors for worker speed.
var asleep = Color8(77,101,180,255)
var happy = Color8(143,211,255,255)
var meh = Color8(255,255,255,255)
var stressed = Color8(246,129,129,255)
var onfire = Color8(232,59,59,255)
##

func _ready():
	assign_face()
	be_meh()
	prev_pb_value = $GUI/MC_Hover/VBox_MC/PB_Temp.value

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
	$Skeleton.modulate = asleep
	$FX_Fore/CPU_FX_Sleep.emitting = true
	$FX_Back/CPU_FX_Fire.emitting = false
	$FX_Back/CPU_FX_Smoke.emitting = false

func be_happy():
	face.frame = 1
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Walk")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 0.75
	$Skeleton.modulate = happy
	$FX_Fore/CPU_FX_Sleep.emitting = false
	$FX_Back/CPU_FX_Fire.emitting = false
	$FX_Back/CPU_FX_Smoke.emitting = false
	
func be_meh():
	face.frame = 2
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Walk")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 1
	$Skeleton.modulate = meh
	$FX_Fore/CPU_FX_Sleep.emitting = false
	$FX_Back/CPU_FX_Fire.emitting = false
	$FX_Back/CPU_FX_Smoke.emitting = false

func be_stressed():
	face.frame = 3
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Walk")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 1.5
	$Skeleton.modulate = stressed
	$FX_Fore/CPU_FX_Sleep.emitting = false
	$FX_Back/CPU_FX_Fire.emitting = false
	$FX_Back/CPU_FX_Smoke.emitting = true

func be_onfire():
	face.frame = 4
	var anim_length = $AP_Motion.get_animation("Idle").length
	var random_time = randf() * anim_length 
	$AP_Motion.play("Walk")
	$AP_Motion.seek(random_time)
	$AP_Motion.speed_scale = 2
	$Skeleton.modulate = onfire
	$FX_Fore/CPU_FX_Sleep.emitting = false
	$FX_Back/CPU_FX_Fire.emitting = true
	$FX_Back/CPU_FX_Smoke.emitting = false

func go_explode():
	$FX_Fore/CPU_FX_Sleep.emitting = false
	$FX_Back/CPU_FX_Fire.emitting = false
	$FX_Back/CPU_FX_Smoke.emitting = false
	$FX_Back.visible = false
	$FX_Fore/CPU_FX_Explosion.emitting = true
	$AP_Motion.play("Fall")
#

## GUI - On hover visibility
func _on_mc_hover_mouse_entered():
	$GUI/MC_Hover/VBox_MC.visible = true
	#too lazy to make have the vbox control it
	$GUI/PB_Juice.visible = true 

func _on_mc_hover_mouse_exited():
	$GUI/MC_Hover/VBox_MC.visible = false
	#too lazy to make have the vbox control it
	$GUI/PB_Juice.visible = false 
#

## Progress bar juice
func _on_pb_temp_value_changed(value):
	# adjusts position of progressbar particle to match value
	if prev_pb_value > value:
		$GUI/PB_Juice/FX_PB_Temp.position -= Vector2(1.8,0)
		prev_pb_value = value
	elif prev_pb_value < value:
		$GUI/PB_Juice/FX_PB_Temp.position += Vector2(1.8,0)
		prev_pb_value = value

	# hides particle to prevent bleeding if getting close to 100
	if value >= 97:
		$GUI/PB_Juice/FX_PB_Temp.visible = false
	elif value < 97:
		$GUI/PB_Juice/FX_PB_Temp.visible = true

	# change color
	#if value < 21:
		#$GUI/MC_Hover/VBox_MC/PB_Temp.tint_progress = Color8(77,101,180,255)
		#$GUI/PB_Juice/FX_PB_Temp.color = Color8(77,101,180,255)
	#elif value >= 21 and value < 41:
		#$GUI/MC_Hover/VBox_MC/PB_Temp.tint_progress = Color8(14,175,155,255)
		#$GUI/PB_Juice/FX_PB_Temp.color = Color8(14,175,155,255)
	#elif value >= 41 and value < 61:
		#$GUI/MC_Hover/VBox_MC/PB_Temp.tint_progress = Color8(35,144,99,255)
		#$GUI/PB_Juice/FX_PB_Temp.color = Color8(35,144,99,255)
	#elif value >= 61 and value < 81:
		#$GUI/MC_Hover/VBox_MC/PB_Temp.tint_progress = Color8(274,150,23,255)
		#$GUI/PB_Juice/FX_PB_Temp.color = Color8(274,150,23,255)
	#elif value >= 81:
		#$GUI/MC_Hover/VBox_MC/PB_Temp.tint_progress = Color8(174,35,52,255)
		#$GUI/PB_Juice/FX_PB_Temp.color = Color8(174,35,52,255)
#

func _input(event):
	if Input.is_action_just_pressed("test"):
		$GUI/MC_Hover/VBox_MC/PB_Temp.value += 1
