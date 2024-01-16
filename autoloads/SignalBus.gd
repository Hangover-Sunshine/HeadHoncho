extends Node

enum WhyDickheadLeft {
	KILLED,
	LEFT,
	ATTACKED
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
signal round_start
signal too_many_workers_quit
signal player_jumped_out_window

