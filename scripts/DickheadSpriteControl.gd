extends Node2D

@onready var sprites = $Sprites
@onready var head = $Sprites/Head
@onready var clothes = $Sprites/Clothes
@onready var hands = $Sprites/Hands

# 0 = white, 1 = pink, 2 = brown
var skin_color:int = 0
var head_id:int = 0
var clothes_id:int = 0

func generate_character():
	skin_color = randi() % 3
	head_id = randi() % 3
	clothes_id = randi() % 2
	
	hands.frame_coords = Vector2i(0, skin_color)
	head.frame_coords = Vector2i(head_id * 2, skin_color)
	clothes.frame_coords = Vector2i(clothes_id, 1)
##

func rbf_face():
	head.frame_coords.x = head_id * 2
##

func best_boss_face():
	head.frame_coords.x = head_id * 2 + 1
##
