extends Node

func _ready():
	Verho.set_loaded_scene_parent(self)
	Verho.change_scene("res://scenes/menus/hub_menu.tscn",
						"res://prefabs/transitions/fade_to_black.tscn")
##
