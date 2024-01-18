extends Control
class_name QuarterController

@export var QUOTA_GROWTH:float = 0.4

@export_group("Monetary Costs")
@export var WINDOW_REPAIR_COST:int = 400
@export var SETTLEMENT_FEES:int = 2000

@export_group("Reputation")
@export var GOING_OVER_MAX:int = 25
@export var BEING_UNDER_MAX:int = 100
@export var KILLING_TOO_MANY:int = 2

#############################################################

@onready var report = $MarginContainer/Background/Report
@onready var employee_stuff = $MarginContainer/Background/EmployeeStuff

@onready var pleebs = $MarginContainer/Background/Report/TopReport/Pleebs
@onready var insulted = $MarginContainer/Background/Report/TopReport/Insulted
@onready var supported = $MarginContainer/Background/Report/TopReport/Supported
@onready var deaths = $MarginContainer/Background/Report/TopReport/Deaths
@onready var windows = $MarginContainer/Background/Report/TopReport/Windows

@onready var quota_number = $MarginContainer/Background/Report/QuotaStuff/Number
@onready var rev_number = $MarginContainer/Background/Report/RevStuff/Number
@onready var profit_number = $MarginContainer/Background/Report/ProfitStuff/Number

#############################################################

var round_results:Dictionary

func _ready():
	report.visible = false
	employee_stuff.visible = false
	
	SignalBus.connect("round_over", _round_over)
##

func _round_over(results:Dictionary):
	# "money", "quota", "broken_windows", "dickheads_killed", "dickheads_satisfied",
	# "dickheads_removed", "employees_quit"
	
	var window_cost:int = ceil(results["broken_windows"] * WINDOW_REPAIR_COST)
	var settlements:int = ceil(results["dickheads_removed"] * SETTLEMENT_FEES)
	
	var profit:int = results["money"] - window_cost - settlements
	
	quota_number.text = "$" + Utility.number_to_string_formatter(results["quota"], ",")
	rev_number.text = "$" + Utility.number_to_string_formatter(results["money"], ",")
	profit_number.text = "$" + Utility.number_to_string_formatter(profit, ",")
	
	####
	
	report.visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
##

func _on_confirm_pressed():
	report.visible = false
	employee_stuff.visible = true
	mouse_filter = Control.MOUSE_FILTER_PASS
##

func _on_begin_next_quater_pressed():
	employee_stuff.visible = false
	SignalBus.emit_signal("round_start")
##

func _grow_quota(curr_quota:int) -> int:
	return curr_quota + ceil(curr_quota * QUOTA_GROWTH)
##
