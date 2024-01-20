extends Node2D

@onready var rotator = $"../Rotator"

@onready var animation_player = $AnimationPlayer
@onready var head_anims = $HeadAnims

@onready var head = $Sprites/Head

@onready var parent = get_parent()

## Particles
@onready var blowie = $"../Rotator/Blowie"
@onready var smoke = $"../Smoke"
@onready var covefe_splash = $"../Rotator/CovefeSplash"
##

var curr_head:Player.Heads
var head_coords:Vector2i = Vector2i.ZERO
var spill:bool = false

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
			if spill:
				if smoke.is_emitting():
					smoke.stop_emitting()
				##
				
				head.frame_coords.x = 0
				head.frame_coords.y = 2
				
				covefe_splash.emit()
				
				if $SpillTimer.is_stopped():
					$SpillTimer.start()
				##
			else:
				head.frame_coords.x = 1
				head.frame_coords.y = 1
				if smoke.is_emitting() == false:
					smoke.emit()
				##
			##
		elif curr_head == Player.Heads.FUCK_HEAD:
			pass
		##
	else:
		head.frame_coords = head_coords
		if curr_head == Player.Heads.BLOW_HEAD:
			blowie.stop_emitting()
		##
		if curr_head == Player.Heads.COVEFE_HEAD:
			smoke.stop_emitting()
			covefe_splash.stop_emitting()
			head.frame_coords.x = 1
			head.frame_coords.y = 1
		##
	##
	
	if curr_head == Player.Heads.COVEFE_HEAD:
		if rotator.facing == 3:
			head.scale.x = 1
		elif rotator.facing == 1:
			head.scale.x = -1
		##
	else:
		head.scale.x = 1
	##
##

func _on_spill_timer_timeout():
	spill = false
	covefe_splash.stop_emitting()
##
