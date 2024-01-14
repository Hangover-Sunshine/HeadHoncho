extends CharacterBody2D
class_name Dickhead

func _ready():
	$CharacterSkeleton.generate_character()
##

func _physics_process(delta):
	move_and_slide()
##
