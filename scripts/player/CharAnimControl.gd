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
@onready var revenue = $"../Revenue"
@onready var speech_bubble = $"../SpeechBubble"
##

var curr_head:Player.Heads
var head_coords:Vector2i = Vector2i.ZERO

var spill:bool = false
var aoe_healing:bool = false
var aoe_healing_done:bool = false
var talking:bool = false
var spawned_particles:bool = false
var hire_worker:bool = false

var fall_anim_played:bool = false

func _ready():
	SignalBus.connect("hire_worker", _hire_worker)
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
	if get_parent().falling:
		if animation_player.current_animation != "Falling" and fall_anim_played == false:
			animation_player.play("Falling")
			fall_anim_played = true
			get_parent().kill_all_particles()
		##
		return
	##
	
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
			if talking:
				head_anims.play("talkie", -1, 1.5)
				if speech_bubble.is_emitting() == false:
					speech_bubble.emit()
				##
			elif aoe_healing:
				if aoe_healing_done:
					if spawned_particles == false:
						spawned_particles = true
						revenue.aoe_heal_setup()
						revenue.emit()
					##
					
					head_anims.stop()
					head.frame_coords.x = 0
					head.frame_coords.y = 3
					$StayOpenTimer.start()
					head.rotation = 0
				else:
					aoe_healing_done = false
					$StayOpenTimer.stop()
					head_anims.play("healing", -1, 1.2)
				##
			##
		##
	else:
		if curr_head == Player.Heads.BLOW_HEAD:
			blowie.stop_emitting()
		##
		if curr_head == Player.Heads.COVEFE_HEAD:
			smoke.stop_emitting()
			covefe_splash.stop_emitting()
			head_coords.x = 1
			head_coords.y = 1
		##
		if curr_head == Player.Heads.FUCK_HEAD:
			head_anims.stop()
			head.rotation = 0
			speech_bubble.stop_emitting()
		##
		if $StayOpenTimer.is_stopped:
			head.frame_coords = head_coords
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

func _hire_worker(_area):
	print("hello?")
	revenue.buy_worker_setup()
	speech_bubble.stop_emitting()
	revenue.emit()
	head_anims.stop()
##

func _on_stay_open_timer_timeout():
	head.frame_coords.x = 1
	head.frame_coords.y = 2
	aoe_healing_done = false
##

func _on_spill_timer_timeout():
	spill = false
	covefe_splash.stop_emitting()
##
