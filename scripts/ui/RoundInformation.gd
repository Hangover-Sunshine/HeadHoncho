extends HBoxContainer

func set_quota(amount:int):
	$QuotaNumber.text = "$" + str(amount)
##

func set_revenue(amount:int):
	$RevenueNumber.text = "$" + str(amount)
##

func set_workers_quit(amount:int):
	$WQNumber.text = str(amount)
##
