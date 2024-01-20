extends Node2D

@onready var effect_bar = $"../EffectBar"

var player

func _ready():
	player = get_parent()
	SignalBus.connect("tick_update", _tick_update_receiver)
##

func _tick_update_receiver():
	if player.use_head:
		if player.curr_head == Player.Heads.BLOW_HEAD:
			for person in player.dickheads_in_path:
				person.getting_blown(player.global_position)
			##
			
			if len(player.dickheads_in_path) == 0:
				for person in player.worker_in_path:
					person.decrease_temp(player.COOLDOWN_WORKER)
				##
			##
		##
		
		if player.curr_head == Player.Heads.COVEFE_HEAD:
			for person in player.dickheads_in_path:
				person.burning()
			##
			
			if len(player.dickheads_in_path) == 0:
				for person in player.worker_in_path:
					person.add_energy(player.ADD_ENERGY)
				##
			##
		##
		
		if player.curr_head == Player.Heads.FUCK_HEAD:
			for person in player.dickheads_in_path:
				person.bloviate()
			##
			
			if len(player.dickheads_in_path) == 0:
				for person in player.worker_in_path:
					person.destress(player.INDIV_DESTRESS)
				##
			##
			
			if len(player.dickheads_in_path) == 0 and len(player.worker_in_path) == 0:
				for seat in player.open_seats_nearby:
					seat.get_parent().hire_worker()
				##
			##
			
			if len(player.dickheads_in_path) == 0 and len(player.worker_in_path) == 0 and len(player.open_seats_nearby) == 0:
				player.cure_three()
			##
		##
	##
	
	$"../RaidwideHealComponent".check_for_reset()
		
	if $"../RaidwideHealComponent".get_level() == 0:
		effect_bar.visible = false
	##
##
