extends Node2D

## Ginger = 0; Berry = 1; Cocoa = 2
@onready var skin = 0

func _ready():
	skin = randi() % 3
	if skin == 0:
		be_ginger()
	elif skin == 1:
		be_berry()
	elif skin == 2:
		be_cocoa()

func be_ginger():
	$Ginger.visible = true
	$Berry.visible = false
	$Cocoa.visible = false
	$Ginger.frame = randi() % 8
	$"../Hands".frame = skin
	
func be_berry():
	$Ginger.visible = false
	$Berry.visible = true
	$Cocoa.visible = false
	$Berry.frame = randi() % 8
	$"../Hands".frame = skin

func be_cocoa():
	$Ginger.visible = false
	$Berry.visible = false
	$Cocoa.visible = true
	$Cocoa.frame = randi() % 8
	$"../Hands".frame = skin
