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

static func number_to_string_formatter(number : int, separator : String = "") -> String:    
	var in_str = str(number)   
	var out_chars = PackedStringArray()    
	var length = in_str.length()  
	for i in length:   
		var idx = i+1 # add digits from last to first  
		out_chars.append(in_str[length-idx]) # every 3 digits add a separator, unless we're at the end  
		if i < length-1 and idx % 3 == 0:
			out_chars.append(separator)
		##
	##
	# invert it so it's back in the right order       
	out_chars.reverse()
	# convert to single string and return 
	return "".join(out_chars)
##

func rand_rangei(min:int, max:int) -> int:
	if min == max:
		return min
	##
	
	if min > max:
		var t = min
		min = max
		max = t
	##
	
	return randi() % (max + 1 - min) + min
##
