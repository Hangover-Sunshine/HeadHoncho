extends Node2D

@onready var fire = $Fire
@onready var dots = $Dots
@onready var dots_2 = $Dots2
@onready var kisses = $Kisses
@onready var hugs = $Hugs

func _ready():
	fire.emitting = false
	dots.emitting = false
	dots_2.visible = false
	kisses.emitting = false
	hugs.emitting = false
##

func is_emitting():
	return fire.emitting
##

func emit():
	fire.emitting = true
	dots.emitting = true
	dots_2.visible = true
	kisses.emitting = true
	hugs.emitting = true
##

func stop_emitting():
	fire.emitting = false
	dots.emitting = false
	dots_2.visible = false
	kisses.emitting = false
	hugs.emitting = false
##
