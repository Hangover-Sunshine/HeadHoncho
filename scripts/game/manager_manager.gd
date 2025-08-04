extends Node
class_name ManagerController

signal elevator_called

@export var OfficePathingArea:NavigationRegion2D
@export var LeaveVator:Node2D

# All current managers in the scene
var managers:Array = []
# Pot to leave
var waiting_to_leave:Array[Manager]

func manager_created(manager, worker:int, pester_position:Vector2):
	self.add_child(manager)
	manager.connect("awaiting_leaving", add_manager)
	manager.connect("not_awaiting_anymore", remove_manager)
	manager.connect("needs_new_burning_point", _generate_new_point)
	manager.go_to_elevator.connect(exit_level)
	manager.selected_worker = worker
	manager.set_goal_position(pester_position)
	managers.append(manager)
##

func exit_level(manager:Manager):
	manager.set_goal_position(LeaveVator.get_elevator_wait_pos(), true)
##

func get_random_position(old_pos:Vector2):
	var new_pos = NavigationServer2D.region_get_random_point(
					OfficePathingArea.get_rid(),
					1,
					false
	)
	
	var rand = randi() % 100
	var distances = [
		$"../FallingArea/Marker2D".global_position.distance_to(old_pos),
		$"../FallingArea/Marker2D2".global_position.distance_to(old_pos),
		$"../FallingArea/Marker2D3".global_position.distance_to(old_pos)
	]
	
	var shortest_dist = distances.min()
	var sdi = distances.find(shortest_dist)
	
	if shortest_dist < 250 and rand > 20:
		match sdi:
			0:
				new_pos = $"../FallingArea/Marker2D".global_position
			1:
				new_pos = $"../FallingArea/Marker2D2".global_position
			2:
				new_pos = $"../FallingArea/Marker2D3".global_position
			##
		##
	else:
		sdi = -1
		while old_pos.distance_to(new_pos) < 10:
			new_pos = NavigationServer2D.region_get_random_point(
						OfficePathingArea.get_rid(),
						1,
						false
			)
		##
	##
	
	return [new_pos, sdi]
##

func add_manager(manager:Manager):
	waiting_to_leave.push_back(manager)
	elevator_called.emit()
##

func remove_manager(manager:Manager):
	var id = waiting_to_leave.find(manager)
	waiting_to_leave.remove_at(id)
##

func managers_leave():
	var ids_to_clean:Array[int] = []
	
	var then = Time.get_ticks_usec()
	
	while then - Time.get_ticks_usec() < 0.18 and len(waiting_to_leave) > 0:
		var rand_amnt = randi_range(1, 2) if len(waiting_to_leave) > 2 else 1
		
		for i in range(rand_amnt):
			var picked = waiting_to_leave.pick_random()
			
			managers.remove_at(managers.find(picked))
			waiting_to_leave.remove_at(waiting_to_leave.find(picked))
			picked.queue_free()
		##
		
		await get_tree().create_timer(0.08).timeout
	##
##

func _generate_new_point(manager:Manager):
	var new_pos = get_random_position(manager.global_position)
	manager.run_burn(new_pos[0], new_pos[1] >= 0)
##
