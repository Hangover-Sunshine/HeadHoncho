extends Node2D

@onready var circles = $Circles
@onready var circles_2 = $Circles2
@onready var circles_3 = $Circles3
@onready var circles_4 = $Circles4
@onready var right_bubble = $RightBubble
@onready var right_bubble_2 = $RightBubble2
@onready var left_bubble = $LeftBubble
@onready var left_bubble_2 = $LeftBubble2

func _ready():
	circles.emitting = false
	circles_2.visible = false
	circles_3.emitting = false
	circles_4.emitting = false
	right_bubble.emitting = false
	right_bubble_2.emitting = false
	left_bubble.emitting = false
	left_bubble_2.emitting = false
##

func is_emitting():
	return circles.emitting
##

func emit():
	circles.emitting = true
	circles_2.visible = true
	circles_3.emitting = true
	circles_4.emitting = true
	right_bubble.emitting = true
	right_bubble_2.emitting = true
	left_bubble.emitting = true
	left_bubble_2.emitting = true
##

func stop_emitting():
	circles.emitting = false
	circles_2.visible = false
	circles_3.emitting = false
	circles_4.emitting = false
	right_bubble.emitting = false
	right_bubble_2.emitting = false
	left_bubble.emitting = false
	left_bubble_2.emitting = false
##
