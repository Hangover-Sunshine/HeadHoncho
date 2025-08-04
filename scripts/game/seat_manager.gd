extends Node

var seats:Array[Seat] = []

func _ready():
	%WorkerRepository.worker_quit.connect(_worker_quit)
	
	# Get all the seats.
	for child in get_children():
		seats.push_back(child)
	##
##

func _worker_quit(seatID:int):
	seats[seatID].enable_seat()
##

func get_standing_position(seatID:int):
	return seats[seatID].get_standing_pos()
##

func enable_seat(seatID:int):
	seats[seatID].enable_seat()
##

func disable_seat(seatID:int):
	seats[seatID].disable_seat()
##

func get_seat_id(seat:Seat):
	return seats.find(seat)
##

func is_seat_available(seat:Seat):
	return is_seat_available_id(seats.find(seat))
##

func is_seat_available_id(seatId:int):
	return seats[seatId].IsOpen
##
