extends Node2D

var in_game:bool = false

var paused:bool = false

func _ready():
	in_game = true
	SignalBus.connect("round_start", _round_start)
	SignalBus.connect("round_over", _round_over)
	$UILayer/QuarterReview.visible = false
##

func _round_start(_data):
	in_game = true
##

func _round_over(_data):
	in_game = false
	$UILayer/QuarterReview.visible = true
##

func _process(delta):
	if Input.is_action_just_pressed("pause") and in_game:
		get_tree().paused = !get_tree().paused
		$UILayer/PauseUI.visible = !$UILayer/PauseUI.visible
		$UILayer/PauseUI.paused = true
		$UILayer/PauseUI.pause_pressed()
	##
##

func unpause():
	$UILayer/PauseUI.visible = false
	$UILayer/PauseUI.paused = false
	get_tree().paused = false
##
