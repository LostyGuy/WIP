extends Node2D

@onready var rating_label: Label = $Rating_label


enum States {NONE, SLOW, AVERAGE, FAST, SPILL}

@export var slow := 0.30
@export var average := 0.80
@export var fast := 0.90
@export var speed_modifier := 4

var rating := 1.0
var percantage := 1.0
var speed: States = States.NONE
@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	#Only debug purposes
	rating_label.text = "Rating: " + str(round(rating*10000)/100) + "%"

func _process(delta: float) -> void:
	
	#Changing the percantage based on the force of the pull
	match speed:
		States.NONE: return
		States.SLOW: percantage -= slow/speed_modifier * delta
		States.AVERAGE: percantage -= average/speed_modifier * delta
		States.FAST: percantage -= fast/speed_modifier * delta
		States.SPILL: 
			percantage -= fast/speed_modifier * delta
			rating -= 0.1 * delta
	percantage = clamp(percantage, 0, 1)
	progress_bar.value = percantage
	#Only debug purposes
	rating_label.text = "Rating: " + str(round(rating*10000)/100) + "%"

func _on_chain_pulling(height: float, maximum_height: float) -> void:
	#Assesing the speed of pouring
	var height_percantage : float = height/maximum_height
	if height_percantage == 0.0:
		speed = States.NONE
	elif height_percantage <= slow:
		speed = States.SLOW
	elif height_percantage <= average:
		speed = States.AVERAGE
	elif height_percantage <= fast:
		speed = States.FAST
	else:
		speed = States.SPILL


func _on_chain_pulling_ended() -> void:
	speed = States.NONE
