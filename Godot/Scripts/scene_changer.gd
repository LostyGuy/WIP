extends Node

@export var next_scene : PackedScene

func _change_scene():
	get_tree().change_scene_to_packed(next_scene)
