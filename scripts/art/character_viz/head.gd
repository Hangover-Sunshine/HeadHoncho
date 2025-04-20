extends Node2D

## Ginger = 0; Berry = 1; Cocoa = 2
@onready var skin = 0
@onready var ext = 0
@onready var hair = 0
@onready var head

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
	$Hair/Ext1.frame = 0
	$Hair/Ext2.frame = 0
	$Hair/Ext3.frame = 0
	head = $Ginger
	assign_hair()
	$"../Hands".frame = skin
	

func be_berry():
	$Ginger.visible = false
	$Berry.visible = true
	$Cocoa.visible = false
	$Hair/Ext1.frame = 1
	$Hair/Ext2.frame = 1
	$Hair/Ext3.frame = 1
	head = $Berry
	assign_hair()
	$"../Hands".frame = skin

func be_cocoa():
	$Ginger.visible = false
	$Berry.visible = false
	$Cocoa.visible = true
	$Hair/Ext1.frame = 2
	$Hair/Ext2.frame = 2
	$Hair/Ext3.frame = 2
	head = $Cocoa
	assign_hair()
	$"../Hands".frame = skin

func assign_hair():
	hair = randi() % 16
	if hair == 0:
		head.frame = 0
	elif hair == 1 || hair == 2:
		head.frame = 1
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif hair > 2 and hair < 7:
		head.frame = 2
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true
	elif hair > 6 and hair < 10:
		head.frame = 3
		ext = randi() % 3
		if ext == 1:
			$Hair/Ext1.visible = true
		if ext == 2:
			$Hair/Ext3.visible = true
	elif hair == 10 || hair == 11:
		head.frame = 4
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif hair > 11 and hair < 14:
		head.frame = 5
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true
	elif hair == 14:
		head.frame = 6
	elif hair == 15:
		head.frame = 7
