extends Control

@onready var label = $TextBG/MarginContainer/Label

@onready var survive_all_quotas = $Jpegs/SurviveAllQuotas
@onready var fall_out = $Jpegs/FallOut
@onready var unionization = $Jpegs/Unionization
@onready var fired = $Jpegs/Fired

func _ready():
	SignalBus.connect("player_jumped_out_window", player_dies_end)
	SignalBus.connect("player_fired", player_fired_end)
	SignalBus.connect("player_survived", survive_end)
	SignalBus.connect("too_many_workers_quit", unionization_end)
	visible = false
##

func player_dies_end():
	visible = true
	label.text = "By some chance, you fell out the window; whether it was an accident, on purpose, " +\
				"or some other reason will not be investigated. In fact, before the coroner could " +\
				"pronounce you dead due to blunt force trauma, [Company] marched in and stapled " +\
				"'you're fired' to your corpse and your final performance review."
##

func player_fired_end():
	visible = true
	label.text = "Owing to your terrible management of the company's money, you've been " +\
				"summarily fired. You were asked to meet The Bosses on a boat, where you were " +\
				"never heard from again. Your family was not compensated. No one was investiged."
##

func unionization_end():
	visible = true
	label.text = "You decided to not fire workers when they were showing signs they were going to " +\
				"collectivize. This will cost the company greatly. You were arrested by the Bluetonnes " +\
				"and executed for allowing a UNION to come into existence. Now they'll have to fire " +\
				"everyone. Read your handbook on 'Why Unions Are Bad [for the company]'" +\
				"better next time.\nGod bless the US of A, you f*cking commie socialist."
##

func survive_end():
	visible = true
	label.text = "The Company congratulates you for meeting all quotas in the physical year! You've " +\
				"earned that $0.50 wage increase and $2 'Employee of the Month' frame... " +\
				"Yes, you might've been the reason the stock prices are now worth 180% more, but you " +\
				"weren't born with a silver spoon and on third base, so go f*ck yourself before we fire " +\
				"you. Be greatful you have a job."
##
