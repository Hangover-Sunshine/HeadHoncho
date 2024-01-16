extends Node2D

@onready var sprites = $Sprites
@onready var head = $Sprites/Head
@onready var clothes = $Sprites/Clothes
@onready var hands = $Sprites/Hands

# 0 = white, 1 = pink, 2 = brown
var skin_color:int = 0
var head_id:int = 0
var clothes_id:int = 0

func _ready():
	sprites = $Sprites
	head = $Sprites/Head
	clothes = $Sprites/Clothes
	hands = $Sprites/Hands
##

func generate_character():
	skin_color = randi() % 3
	head_id = randi() % 3
	clothes_id = randi() % 2
	
	hands.frame_coords = Vector2i(0, skin_color)
	head.frame_coords = Vector2i(0, (skin_color * 3) + head_id)
	clothes.frame_coords = Vector2i(1 + clothes_id, 0)
##

func crunch_face():
	head.frame_coords.x = 3
##

func snooze_face():
	head.frame_coords.x = 2
##

func hot_face():
	head.frame_coords.x = 1
##

func neutral_face():
	head.frame_coords.x = 0
##

func change_hue(color):
	sprites.modulate = color
##
