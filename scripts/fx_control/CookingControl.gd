extends Node2D

@onready var dots = $Dots
@onready var kisses = $Kisses
@onready var hugs = $Hugs
@onready var dots_2 = $Dots2

func _ready():
	dots.emitting = false
	kisses.visible = false
	hugs.emitting = false
	dots_2.emitting = false
##

func is_emitting():
	return dots.emitting
##

func emit():
	dots.emitting = true
	kisses.visible = true
	hugs.emitting = true
	dots_2.emitting = true
##

func stop_emitting():
	dots.emitting = false
	kisses.visible = false
	hugs.emitting = false
	dots_2.emitting = false
##
