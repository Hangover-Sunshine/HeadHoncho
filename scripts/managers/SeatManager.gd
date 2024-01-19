extends Marker2D

@export var HIRE_WINDUP:Vector2i = Vector2i(6, 8)

###################################################################

@onready var effect_bar = $EffectBar

var can_show:bool = true
var should_show:bool = false

func _ready():
	effect_bar.visible = false
	SignalBus.connect("tick_update", _tick_update)
##

func _tick_update():
	if can_show:
		$HireBarComponent.check_for_reset()
		
		if $HireBarComponent.get_level() == 0:
			effect_bar.visible = false
		##
	##
##

func hire_worker():
	if $HireBarComponent.get_level() == 0:
		$HireBarComponent.generate_new_max(4, 4)
		effect_bar.visible = true
		effect_bar.value = 0
	##
	
	var result:int = $HireBarComponent.tick()
	
	effect_bar.value = clampi((result / float(4)) * 100, 0, 100)
	
	if result >= 4:
		SignalBus.emit_signal("hire_worker", self)
	##
##

func show_icon():
	if can_show:
		$Icon.visible = true
		$HireHB/CollisionShape2D.disabled = false
	##
	should_show = true
##

func hide_icon():
	if can_show:
		$Icon.visible = false
		$HireHB/CollisionShape2D.disabled = true
	##
	should_show = false
##

func player_can_interact(flag):
	can_show = flag
	effect_bar.visible = flag
	$HireHB/CollisionShape2D.disabled = !flag
	if flag == false:
		$Icon.visible = false
	elif flag == true and should_show == true:
		$Icon.visible = true
	##
##
