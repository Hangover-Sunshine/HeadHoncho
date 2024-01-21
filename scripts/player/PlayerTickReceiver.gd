extends Node2D

@onready var effect_bar = $"../EffectBar"
@onready var character_skeleton = $"../CharacterSkeleton"

@onready var blowie:AbilityTickProcessor = $Blowie
@onready var covefe = $Covefe
@onready var moneybags = $Moneybags

var player
var curr_head:Player.Heads
var max_ticks:int

var curr_tick_array:Array = []
var prev_tick_array:Array = []

func _ready():
	player = get_parent()
	SignalBus.connect("tick_update", _tick_update_receiver)
##

func _blow_head_process():
	if blowie.get_is_active() == false:
		max_ticks = blowie.get_new_max()
	##
	
	if prev_tick_array != curr_tick_array:
		blowie.reset_tick_count()
	##
	
	var result = blowie.tick()
	
	# send the update to the creature
	for thing in curr_tick_array:
		thing.update_effect_bar(blowie.get_tick_count(), max_ticks)
	##
	
	if result == false:
		return
	##
	
	blowie.reset_tick_count()
	
	# Notify it's time to apply the effect
	for thing in curr_tick_array:
		thing.apply_blowie_effect()
	##
##

func _coffee_head_process():
	if covefe.get_is_active() == false:
		max_ticks = covefe.get_new_max()
	##
	
	if prev_tick_array != curr_tick_array:
		covefe.reset_tick_count()
	##
	
	var result = covefe.tick()
	
	# send the update to the creature
	for thing in curr_tick_array:
		thing.update_effect_bar(covefe.get_tick_count(), max_ticks)
	##
	
	if result == false:
		return
	##
	
	get_parent().audio_player.stream = get_parent().sounds["coffee_worker"]
	get_parent().audio_player.play()
	
	covefe.reset_tick_count()
	character_skeleton.spill = true
	
	# Notify it's time to apply the effect
	for thing in curr_tick_array:
		thing.apply_covefe_effect()
	##
##

func _moneybags_head_process():
	if moneybags.get_is_active() == false or len(curr_tick_array) != len(prev_tick_array):
		max_ticks = moneybags.get_new_max()
	##
	
	if prev_tick_array != curr_tick_array:
		moneybags.reset_tick_count()
	##
	
	var result = moneybags.tick()
	
	# send the update to the creature
	if len(curr_tick_array) > 0:
		for thing in curr_tick_array:
			thing.update_effect_bar(moneybags.get_tick_count(), max_ticks)
		##
		if get_parent().audio_player.playing == false:
			get_parent().audio_player.stream = get_parent().sounds["convo"]
			get_parent().audio_player.play()
		##
	else:
		if effect_bar.visible == false:
			effect_bar.visible = true
		##
		effect_bar.value = clampi((moneybags.get_tick_count() / float(max_ticks)) * 100, 0, 100)
	##
	
	if result == false:
		character_skeleton.aoe_healing_done = false
		character_skeleton.spawned_particles = false
		return
	##
	
	moneybags.reset_tick_count()
	
	# Notify it's time to apply the effect
	if len(curr_tick_array) > 0:
		for thing in curr_tick_array:
			thing.apply_moneybags_effect()
		##
	else:
		character_skeleton.aoe_healing_done = true
		SignalBus.emit_signal("aoe_heal", player.GROUP_DESTRESS)
	##
##

func _tick_update_receiver():
	if player.use_head:
		curr_tick_array = player.get_list_to_iterate(curr_head)
		
		if curr_tick_array != prev_tick_array:
			# If curr_tick_array > 0, then we saw someone
			# If effect_bar is visible, we didn't see someone last tick
			# >>> Turn it off
			if len(curr_tick_array) > 0 and effect_bar.visible:
				effect_bar.visible = false
				effect_bar.value = 0
			##
			
			for thing in prev_tick_array:
				thing.hide_effect_bar()
			##
			
			for thing in curr_tick_array:
				thing.show_effect_bar()
			##
		##
		
		if curr_head == Player.Heads.BLOW_HEAD:
			if get_parent().audio_player.playing == false:
				get_parent().audio_player.stream = get_parent().sounds["ac"]
				get_parent().audio_player.play()
			##
			_blow_head_process()
		##
		
		if curr_head == Player.Heads.COVEFE_HEAD:
			_coffee_head_process()
		##
		
		if curr_head == Player.Heads.FUCK_HEAD:
			_moneybags_head_process()
		##
		
		prev_tick_array = curr_tick_array
	else:
		if blowie.get_is_active():
			if get_parent().audio_player.playing:
				get_parent().audio_player.stop()
			##
			blowie.factory_reset()
		##
		
		if covefe.get_is_active():
			covefe.factory_reset()
		##
		
		if moneybags.get_is_active():
			if get_parent().audio_player.playing:
				get_parent().audio_player.stop()
			##
			moneybags.factory_reset()
			character_skeleton.aoe_healing_done = false
		##
		
		if effect_bar.visible:
			effect_bar.visible = false
			effect_bar.value = 0
		##
		
		for thing in curr_tick_array:
			thing.hide_effect_bar()
		##
		
		curr_tick_array = []
		prev_tick_array = []
	##
##

func set_head(new_head):
	curr_head = new_head
##
