extends CharacterBody2D
class_name Dickhead

signal dickhead_removed(pr_impact:float, worker_id:int)
signal go_to_elevator(dickhead:Dickhead)

@export var MovementSpeed:float = 5.0

@onready var navigation_agent = $NavigationAgent2D
@onready var stress_collider = $StressArea/CollisionShape2D

var _is_walking:bool = false
var _leaving:bool = false

func _ready():
	$ArtBoss.be_happy()
	$ArtBoss.go_idle()
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
##

func set_goal_position(pos):
	$NavigationAgent2D.target_position = pos
##

func _physics_process(_delta):
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	##
	if navigation_agent.is_navigation_finished():
		if _is_walking and !_leaving:
			stress_collider.disabled = false
			_is_walking = false
			$ArtBoss.go_idle()
		##
		if _is_walking and _leaving:
			_is_walking = false
			$ArtBoss.go_idle()
		##
		return
	##
	
	_on_velocity_computed(
		global_position.direction_to(navigation_agent.get_next_path_position()) * MovementSpeed
	)
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
	$ArtBoss.be_meh()
	go_to_elevator.emit(self)
	_leaving = true
	stress_collider.disabled = true
##
