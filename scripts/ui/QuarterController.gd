extends Control
class_name QuarterController

@export var QUOTA_GROWTH:float = 0.4

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

#############################################################

var round_results:Dictionary

var new_quota:int
var new_appreciation:int
var old_appreciation:int

func _ready():
	background.visible = false
	report.visible = false
	
	SignalBus.connect("round_over", _round_over)
##

func _round_over(results:Dictionary):
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
	
	var quota =  results["quota"]
	
	quota_number.text = "       $" + Utility.number_to_string_formatter(quota, ",")
	rev_number.text = "  $" + Utility.number_to_string_formatter(results["money"], ",")
	profit_number.text = "        $" + Utility.number_to_string_formatter(profit, ",")
	
	new_quota = _grow_quota(quota)
	
	old_appreciation = results["appreciation"]
	
	new_appreciation = old_appreciation + \
						clamp(int(((profit - quota) / float(quota)) * 100),\
								-BEING_UNDER_MAX, GOING_OVER_MAX)
	
	appreciation.value = new_appreciation
	
	####
	
	background.visible = true
	report.visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
##

func _on_confirm_pressed():
	report.visible = false
	mouse_filter = Control.MOUSE_FILTER_PASS
##

func _on_begin_next_quater_pressed():
	get_tree().paused = false
	background.visible = false
	var roundStart = Utility.startingInfo.duplicate()
	
	roundStart["quota"] = new_quota
	roundStart["appreciation"] = new_appreciation
	
	SignalBus.emit_signal("round_start", roundStart)
##

func _grow_quota(curr_quota:int) -> int:
	return curr_quota + ceil(curr_quota * QUOTA_GROWTH)
##
