extends Control

func set_quota(amount:int):
	$PlayerInformation/QuotaNumber.text = "$" + str(amount)
##

func set_revenue(amount:int):
	$PlayerInformation/RevenueNumber.text = "$" + str(amount)
##

func set_workers_quit(amount:int):
	$PlayerInformation/WQNumber.text = str(amount)
##
