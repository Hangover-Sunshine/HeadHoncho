extends Sprite2D

func _ready():
	$".".frame = 0 + (2*randi() % 2)
