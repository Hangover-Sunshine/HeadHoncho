extends Node2D

@onready var grrrr = $grrrr
@onready var grrrr_2 = $grrrr2

func _ready():
	grrrr.emitting = false
##

func is_emitting():
	return grrrr.emitting
##

func emit():
	grrrr.emitting = true
##

func stop_emitting():
	grrrr.emitting = false
##
