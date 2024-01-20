extends Node2D

@onready var circles = $circles
@onready var hugs = $hugs
@onready var kisses = $kisses
@onready var zzz = $zzz

func _ready():
	circles.emitting = false
	zzz.emitting = false
	kisses.emitting = false
	hugs.emitting = false
##

func is_emitting():
	return circles.emitting
##

func emit():
	circles.emitting = true
	zzz.emitting = true
	kisses.emitting = true
	hugs.emitting = true
##

func stop_emitting():
	circles.emitting = false
	zzz.emitting = false
	kisses.emitting = false
	hugs.emitting = false
##
