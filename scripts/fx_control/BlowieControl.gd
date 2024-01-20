extends Node2D

@onready var stream = $Stream
@onready var dots = $Dots
@onready var kisses = $Kisses
@onready var hugs = $Hugs
@onready var square = $Square

func _ready():
	stream.emitting = false
	dots.emitting = false
	kisses.emitting = false
	hugs.emitting = false
	square.visible = false
##

func emit():
	stream.emitting = true
	dots.emitting = true
	kisses.emitting = true
	hugs.emitting = true
	square.visible = true
##

func stop_emitting():
	stream.emitting = false
	dots.emitting = false
	kisses.emitting = false
	hugs.emitting = false
	square.visible = false
##
