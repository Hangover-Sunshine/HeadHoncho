extends Marker2D

@export var HIRE_WINDUP:Vector2i = Vector2i(6, 8)

###################################################################

@onready var effect_bar = $EffectBar

var can_show:bool = true
var should_show:bool = false

func _ready():
	effect_bar.visible = false
##

func show_effect_bar():
	effect_bar.visible = true
##

func hide_effect_bar():
	effect_bar.value = 0
	effect_bar.visible = false
##

func update_effect_bar(curr_val:int, max_val:int):
	effect_bar.value = clampi((curr_val / float(max_val)) * 100, 0, 100)
##

func apply_moneybags_effect():
	SignalBus.emit_signal("hire_worker", self)
##

func show_icon():
	if can_show:
		$HireMe.visible = true
		$HireMe/AnimationPlayer.play("Hover")
		$HireHB/CollisionShape2D.disabled = false
	##
	should_show = true
##

func hide_icon():
	if can_show:
		$HireMe.visible = false
		$HireMe/AnimationPlayer.stop()
		$HireHB/CollisionShape2D.disabled = true
	##
	should_show = false
##

func player_can_interact(flag):
	can_show = flag
	if flag == true and should_show == true:
		$HireMe.visible = true
		$HireMe/AnimationPlayer.play("Hover")
		effect_bar.visible = true
		$HireHB/CollisionShape2D.disabled = false
	elif flag == false:
		$HireMe.visible = false
		$HireMe/AnimationPlayer.stop()
		effect_bar.visible = false
		$HireHB/CollisionShape2D.disabled = true
	##
##
