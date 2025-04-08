extends Node

var firstLoad = true

func  _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Back_to_main") and not firstLoad:
		Input.mouse_mode = 0
		firstLoad = true
		get_tree().change_scene_to_file("res://main/main.tscn")
