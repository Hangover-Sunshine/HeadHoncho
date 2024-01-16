extends Node

func choose(list, n=1) -> Array:
	if n == 0:
		return []
	##
	
	var choices = []
	
	for i in range(n):
		var choice = randi() % len(list)
		choices.append(list[choice])
	##
	
	return choices
##

func choose_no_replace(list, n=1) -> Array:
	if n == 0:
		return []
	##
	
	if len(list) <= n:
		return list
	##
	
	var choices = []
	var local = list.duplicate()
	
	for i in range(n):
		var choice = randi() % len(list)
		choices.append(list[choice])
		local.remove_at(local.find(choice))
	##
	
	return choices
##
