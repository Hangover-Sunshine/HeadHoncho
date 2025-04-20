extends Node2D

## Ginger = 0; Berry = 1; Cocoa = 2
@onready var skin = 0
@onready var ext = 0

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
	$Hair/Ext1.frame = 0
	$Hair/Ext2.frame = 0
	$Hair/Ext3.frame = 0
	$"../Hands".frame = skin
	if $Ginger.frame == 1:
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif $Ginger.frame == 2:
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true
	elif $Ginger.frame == 3:
		ext = randi() % 3
		if ext == 1:
			$Hair/Ext1.visible = true
		if ext == 2:
			$Hair/Ext3.visible = true
	elif $Ginger.frame == 4:
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif $Ginger.frame == 5:
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true

func be_berry():
	$Ginger.visible = false
	$Berry.visible = true
	$Cocoa.visible = false
	$Berry.frame = randi() % 8
	$Hair/Ext1.frame = 1
	$Hair/Ext2.frame = 1
	$Hair/Ext3.frame = 1
	$"../Hands".frame = skin
	if $Berry.frame == 1:
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif $Berry.frame == 2:
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true
	elif $Berry.frame == 3:
		ext = randi() % 3
		if ext == 1:
			$Hair/Ext1.visible = true
		if ext == 2:
			$Hair/Ext3.visible = true
	elif $Berry.frame == 4:
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif $Berry.frame == 5:
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true

func be_cocoa():
	$Ginger.visible = false
	$Berry.visible = false
	$Cocoa.visible = true
	$Cocoa.frame = randi() % 8
	$Hair/Ext1.frame = 2
	$Hair/Ext2.frame = 2
	$Hair/Ext3.frame = 2
	$"../Hands".frame = skin
	if $Cocoa.frame == 1:
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif $Cocoa.frame == 2:
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true
	elif $Cocoa.frame == 3:
		ext = randi() % 3
		if ext == 1:
			$Hair/Ext1.visible = true
		if ext == 2:
			$Hair/Ext3.visible = true
	elif $Cocoa.frame == 4:
		ext = randi() % 2
		if ext == 1:
			$Hair/Ext1.visible = true
	elif $Cocoa.frame == 5:
		ext = randi() % 4
		if ext == 1:
			$Hair/Ext1.visible = true
		elif ext == 2:
			$Hair/Ext2.visible = true
		elif ext == 3:
			$Hair/Ext3.visible = true
