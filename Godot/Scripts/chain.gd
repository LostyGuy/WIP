extends Sprite2D

signal pulling(height : float, maximum_height: float)
signal pulling_ended

@export var maximum_height := 200.0

var touchdown := false 
var height_start := 0.0
var height_end := 0.0  

@onready var chain_starting_height = position.y

var height := 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_touch"):
		touchdown = false
		position.y = chain_starting_height
		emit_signal("pulling_ended")
	if not touchdown:
		return
	
	if event is InputEventMouseMotion:
		height_end = event.position.y
		height = clamp(height_end - height_start, 0, maximum_height)
		position.y = chain_starting_height + height
		emit_signal("pulling", height, maximum_height)

func _on_pull_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("ui_touch"):
		touchdown = true
		height_start = event.position.y
