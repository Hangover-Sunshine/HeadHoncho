extends CharacterBody2D
class_name Dickhead

signal dickhead_removed(pr_impact:float, worker_id:int)
signal go_to_elevator(dickhead:Dickhead)
signal needs_new_burning_point(dickhead:Dickhead)
signal awaiting_leaving(dickhead:Dickhead)
signal not_awaiting_anymore(dickhead:Dickhead)

@export var MovementSpeed:float = 5.0
@export var RunSpeed:float = 10.0

@onready var navigation_agent = $NavigationAgent2D
@onready var state_machine = $StateMachine

var selected_worker:int = -1
var leaving_opinion:int = 0

var _is_walking:bool = false
var _leaving:bool = false
var _stop_pathing:bool = false
var _is_burning:bool = false

func _ready():
	$ArtBoss.be_happy()
	$ArtBoss.go_idle()
	$StateMachine/WalkState.nav_agent = navigation_agent
	$StateMachine/RunState.nav_agent = navigation_agent
	$StateMachine/RunState.manager = self
	$StateMachine/LeaveState.manager = self
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
##

func set_goal_position(pos, is_leaving:bool = false):
	if state_machine.CurrState is not WalkState:
		state_machine.change_state($StateMachine/WalkState)
	##
	state_machine.CurrState.is_leaving = is_leaving
	state_machine.CurrState.set_navigation_target(pos)
##

func run_burn(pos):
	if state_machine.CurrState != $StateMachine/RunState:
		$ArtBoss.go_run()
		$ArtBoss.be_onfire()
		state_machine.change_state($StateMachine/RunState)
	##
	navigation_agent.target_position = pos
##

func stop_doing_stuff():
	state_machine.change_state($StateMachine/DoNothingState)
##

func is_doing_nothing():
	return state_machine.CurrState == $StateMachine/DoNothingState
##

func revert():
	if state_machine.PrevState != state_machine.CurrState:
		state_machine.change_state(state_machine.PrevState)
	##
##

func _physics_process(delta):
	state_machine.physics_process_state(delta)
	
	if state_machine.CurrState is WalkState or state_machine.CurrState is RunState:
		_on_velocity_computed(state_machine.CurrState.velocity)
	##
##

func _on_velocity_computed(safe_vel:Vector2):
	velocity = safe_vel
	move_and_slide()
	
	if velocity.length_squared() > 0 and _is_walking == false:
		$ArtBoss.go_walk()
		_is_walking = true
	elif velocity.length_squared() == 0 and _is_walking:
		_is_walking = false
		$ArtBoss.go_idle()
	##
##

func _on_stress_area_body_entered(body):
	body.affected_by_dickhead()
	body.worker_quits.connect(_worker_quits)
##

func _worker_quits(_worker:Worker):
	selected_worker = -1
	state_machine.change_state($StateMachine/WalkState)
	$ArtBoss.be_meh()
	go_to_elevator.emit(self)
	state_machine.CurrState.is_leaving = true
##

func stop_burning():
	$ArtBoss.stop_fire()
	$ArtBoss.be_meh()
	$ArtBoss.go_idle()
	state_machine.change_state($StateMachine/DoNothingState)
	go_to_elevator.emit(self)
##
