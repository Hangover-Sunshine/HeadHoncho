extends Node2D
class_name Worker

@export var startingTemp:int = 50
@export var startingTiredness:int = 50
@export var startingStress:int = 0

@export var defaultTirednessDecrease:int = 1
@export var defaultTempIncrease:int = 1
@export var maxStressToQuit:int = 10
@export var tiredShieldTickMax:int = 5
@export var ticksUntilStressIncrease:int = 6

@export var defaultMoney:int = 500

# 0 -- 1 -- 2
var workLifeBalance:float = 1.0

var currTemp:int
var currTiredness:int
var currStress:int

var twoTicksPassed:bool = false

var tiredShield:bool = false
var ticksSinceShieldStarted:int = 0
var ticksSinceOverstressed:int = 0

func _ready():
	currTemp = startingTemp
	currTiredness = startingTiredness
	currStress = startingStress
	
	get_parent().connect("tick_update", tick_update_receiver)
##

func _input(event):
	if event.is_action_pressed("head_interaction"):
		currTiredness += 20
		tiredShield = true
		ticksSinceShieldStarted = 0
		
		if currTiredness > 100:
			currTiredness = 100
		##
		
		workLifeBalance = currTiredness / 100.0 * 2
	##
##

func calculate_work_life_balance() -> float:
	var result:float = 0
	
	
	
	return result
##

func tick_update_receiver():
	if tiredShield == false and currTiredness > 0:
		currTiredness -= defaultTirednessDecrease
		workLifeBalance = calculate_work_life_balance()
	##
	
	if workLifeBalance > 1.5:
		ticksSinceOverstressed += 1
		
		if ticksSinceOverstressed >= ticksUntilStressIncrease:
			ticksSinceOverstressed = 0
			currStress += 1
		##
	##
	
	print("curr tired:", currTiredness)
	print("curr stress:", currStress)
	print("new wlb:", workLifeBalance)
	
	# give the player money
	if twoTicksPassed:
		SignalBus.emit_signal("give_player_money", floor(defaultMoney * workLifeBalance))
	##
	
	twoTicksPassed = !twoTicksPassed
	
	if ticksSinceShieldStarted == tiredShieldTickMax:
		ticksSinceShieldStarted = 0
		tiredShield = false
	##
	
	if tiredShield:
		ticksSinceShieldStarted += 1
	##
	
	print("---")
##

