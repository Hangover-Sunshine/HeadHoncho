extends Control
class_name QuarterController

@export var QUOTA_GROWTH:float = 0.4
@export var QUOTAS_TO_SURVIVE:int = 4

@export_group("Monetary Costs")
@export var WINDOW_REPAIR_COST:int = 400
@export var SETTLEMENT_FEES:int = 2000

@export_group("Reputation")
@export var GOING_OVER_MAX:int = 20
@export var BEING_UNDER_MAX:int = 50
@export var KILLING_TOO_MANY:int = 2

#############################################################
@onready var background = $Background
@onready var report = $Background/Report

@onready var quit_number = $Background/Report/TopReport/HBoxContainer/Number
@onready var insulted_number = $Background/Report/TopReport/HBoxContainer2/Number
@onready var supported_number = $Background/Report/TopReport/HBoxContainer3/Number
@onready var deaths_number = $Background/Report/TopReport/HBoxContainer4/Number
@onready var windows_number = $Background/Report/TopReport/HBoxContainer5/Number

@onready var quota_number = $Background/Report/QuotaStuff/Number
@onready var rev_number = $Background/Report/RevStuff/Number
@onready var profit_number = $Background/Report/ProfitStuff/Number

@onready var appreciation = $Background/Report/Appreciation/ProgressBar

@onready var audio_player = $AudioPlayer

#############################################################

var round_results:Dictionary

var new_quota:int
var new_appreciation:int
var old_appreciation:int

var quotas_survived:int = 0

var username:String = ""
var signed:bool = false

var names = [
	"John Hancock", "Dick Johnson", "Harry Bawls", "Ben Dover", "Mike Hawk", "Connie Lingus",
	"Willie Stroker", "Hugh Jass", "Candice Fittin", "Ivana Tinkle", "Joe Mama", "Jack Hoff",
	"Dixie Normous", "Eileen Dover", "Mona Lott"
]

func _ready():
	audio_player.stream = load("res://assets/sound/sfx/SFX_Head&Button.wav")
	
	background.visible = false
	report.visible = false
	
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	
	SignalBus.connect("round_over", _round_over)
##

func _round_over(results:Dictionary):
	$Background/Report/HBoxContainer/BossSignature.text = names[randi() % len(names)]
	signed = false
	# "money", "quota", "broken_windows", "dickheads_killed", "dickheads_satisfied",
	# "dickheads_removed", "employees_quit"
	
	quit_number.text = str(results["employees_quit"])
	insulted_number.text = str(results["dickheads_removed"])
	supported_number.text = str(results["dickheads_satisfied"])
	deaths_number.text = str(results["dickheads_killed"])
	windows_number.text = str(results["broken_windows"])
	
	var window_cost:int = ceil(results["broken_windows"] * WINDOW_REPAIR_COST)
	var settlements:int = ceil(results["dickheads_removed"] * SETTLEMENT_FEES)
	
	var profit:int = results["money"] - window_cost - settlements
	
	var quota = results["quota"]
	
	quota_number.text = "    $" + Utility.number_to_string_formatter(quota, ",")
	rev_number.text = "  $" + Utility.number_to_string_formatter(results["money"], ",")
	profit_number.text = "    $" + Utility.number_to_string_formatter(profit, ",")
	
	if profit > quota:
		new_quota = _grow_quota_faster(quota, profit - quota)
	else:
		new_quota = _grow_quota(quota)
	##
	
	old_appreciation = results["appreciation"]
	
	if profit < 0:
		new_appreciation = old_appreciation - BEING_UNDER_MAX
	else:
		var p = float(profit - quota) / float(quota) * 100
		new_appreciation = old_appreciation + clampi(p, -BEING_UNDER_MAX, GOING_OVER_MAX)
	##
	
	appreciation.value = new_appreciation
	
	####
	
	background.visible = true
	report.visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
##

func _input(event):
	if visible and signed == false and event.is_action_pressed("head_interaction"):
		$Background/Report/HBoxContainer/PlayerSignature.set("theme_override_font_sizes/font_size", randi_range(30, 80))
		
		audio_player.play()
		
		var chance = randi() % 100
		
		if len(username) > 0 and ((chance >= 42 and chance <= 45) or chance == 69):
			$Background/Report/HBoxContainer/PlayerSignature.text = username
		else:
			$Background/Report/HBoxContainer/PlayerSignature.text = "HEAD HONCHO"
		##
		
		signed = true
		
		$StartDelayTimer.start()
	##
##

func _on_confirm_pressed():
	report.visible = false
	get_tree().paused = false
	background.visible = false
	
	var roundStart = SignalBus.startingInfo.duplicate()
	
	roundStart["quota"] = new_quota
	roundStart["appreciation"] = new_appreciation
	
	quotas_survived += 1
	$Background/Report/HBoxContainer/PlayerSignature.text = ""
	
	if new_appreciation != 0 and quotas_survived < QUOTAS_TO_SURVIVE:
		SignalBus.emit_signal("round_start", roundStart)
	elif new_appreciation == 0:
		SignalBus.emit_signal("player_fired")
	elif quotas_survived == QUOTAS_TO_SURVIVE:
		SignalBus.emit_signal("player_survived")
	##
	
	mouse_filter = Control.MOUSE_FILTER_PASS
##

func _grow_quota_faster(curr_quota:int, num:int) -> int:
	return curr_quota + ceili(curr_quota * QUOTA_GROWTH) + ceili(num * 0.25)
##

func _grow_quota(curr_quota:int) -> int:
	return curr_quota + ceil(curr_quota * QUOTA_GROWTH)
##

func _on_start_delay_timer_timeout():
	_on_confirm_pressed()
##
