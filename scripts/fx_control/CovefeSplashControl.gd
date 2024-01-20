extends Node2D

@onready var covefe_front = $covefe_front
@onready var covefe_back = $covefe_back
@onready var dots = $dots
@onready var hugs = $hugs
@onready var kisses = $kisses

func _ready():
	covefe_front.emitting = false
	covefe_back.visible = false
	dots.emitting = false
	kisses.emitting = false
	hugs.emitting = false
##

func emit():
	covefe_front.emitting = true
	covefe_back.visible = true
	dots.emitting = true
	kisses.emitting = true
	hugs.emitting = true
##

func stop_emitting():
	covefe_front.emitting = false
	covefe_back.visible = false
	dots.emitting = false
	kisses.emitting = false
	hugs.emitting = false
##
