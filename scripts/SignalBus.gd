extends Node

# WORKER SIGNALS
signal give_player_money(money:int)
signal worker_quit
signal worker_asleep
signal worker_awake

# DICKHEAD SIGNALS
signal player_attacked_dickhead
signal dickhead_died
signal dickhead_removed
signal dickhead_left
signal dickhead_saw_asleep_employee

# ENIVRONMENT SIGNALS
signal tick_update
