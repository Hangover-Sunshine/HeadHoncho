extends Node

enum WhyDickheadLeft {
	KILLED,
	LEFT,
	ATTACKED
}

var roundResults:Dictionary = {
	"money":0,
	"quota":0,
	"broken_windows":0,
	"dickheads_killed":0,
	"dickheads_satisfied":0,
	"dickheads_removed":0,
	"employees_quit":0,
	"appreciation":0
}

var startingInfo:Dictionary = {
	"appreciation":0,
	"new_quota":0,
	"money":0
}

# WORKER SIGNALS
signal give_player_money(money:int)
signal worker_quit(worker:Worker)
signal worker_asleep
signal worker_awake

# DICKHEAD SIGNALS
signal dickhead_died
signal dickhead_removed
signal dickhead_left
signal dickhead_gone(means:WhyDickheadLeft, worker:Worker, dickhead:Dickhead)
signal dickhead_saw_asleep_employee

# ENIVRONMENT SIGNALS
signal tick_update
signal round_start(starting:Dictionary)
signal round_over(results:Dictionary)
signal too_many_workers_quit
signal player_jumped_out_window
