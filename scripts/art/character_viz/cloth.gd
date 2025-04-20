extends Sprite2D

func _ready():
	$".".frame = $".".frame + 2*(randi() % 2)
