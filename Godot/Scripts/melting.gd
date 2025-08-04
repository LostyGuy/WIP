extends Node2D
@export var oreType : Ore
@onready var scene_changer: Node = $SceneChanger

@onready var finish_button: Button = $FinishButton
@onready var timer: Timer = $Timer
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var melting_timer: Timer = $MeltingTimer
@onready var rating_label: Label = $Rating_label

var is_running := true
var rating := 1.0

func _ready() -> void:
	melting_timer.wait_time = oreType.melting_timer
	melting_timer.start()
	Engine.time_scale = 1
	texture_progress_bar.value = 0.0
	finish_button.hide()

func _process(delta: float) -> void:
	if not is_running:
		return
	var current_percentage = 1 - melting_timer.time_left/melting_timer.wait_time
	if current_percentage > 0.90:
		rating = clamp(rating - delta/10, 0, 1) 
		
	if current_percentage > 0.75 and not finish_button.is_visible_in_tree():
		finish_button.show()
		
	texture_progress_bar.value = current_percentage
	 
	rating_label.text = "Rating: " + str(round(rating*10000)/100) + "%"

func _on_speed_up_button_pressed() -> void:
	Engine.time_scale = clamp(Engine.time_scale * oreType.modifier_acceleration, oreType.min_modifier, oreType.max_modifier)
	timer.start()

func _on_finish_button_pressed() -> void:
	is_running = false
	melting_timer.stop()
	scene_changer._change_scene()
	

func _on_timer_timeout() -> void:
	if Engine.time_scale != oreType.min_modifier:
		Engine.time_scale = clamp(Engine.time_scale / oreType.modifier_acceleration, oreType.min_modifier, oreType.max_modifier)
		timer.start()
