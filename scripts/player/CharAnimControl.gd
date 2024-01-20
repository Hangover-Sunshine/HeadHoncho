extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var head_anims = $HeadAnims

@onready var head = $Sprites/Head

@onready var parent = get_parent()

## Particles
@onready var blowie = $"../Rotator/Blowie"
##

var curr_head:Player.Heads
var head_coords:Vector2i = Vector2i.ZERO

func _ready():
	pass
##

func play_animation(flag):
	pass
##

func set_head(new_head):
	curr_head = new_head
	
	if curr_head == Player.Heads.BLOW_HEAD:
		head_coords.x = 0
		head_coords.y = 0
	elif curr_head == Player.Heads.COVEFE_HEAD:
		head_coords.x = 1
		head_coords.y = 1
	elif curr_head == Player.Heads.FUCK_HEAD:
		head_coords.x = 1
		head_coords.y = 2
	##
##

func _process(delta):
	if parent.velocity.length_squared() != 0 and animation_player.current_animation != "All_Walk":
		animation_player.play("All_Walk")
	##
	
	if parent.velocity.length_squared() == 0 and animation_player.current_animation != "All_Idle":
		animation_player.play("All_Idle")
	##
	
	if parent.use_head:
		if curr_head == Player.Heads.BLOW_HEAD:
			head_anims.play("blowie", -1, 2.5)
			blowie.emit()
		elif curr_head == Player.Heads.COVEFE_HEAD:
			pass
		elif curr_head == Player.Heads.FUCK_HEAD:
			pass
		##
	else:
		head.frame_coords = head_coords
		if curr_head == Player.Heads.BLOW_HEAD:
			blowie.stop_emitting()
		##
	##
##
