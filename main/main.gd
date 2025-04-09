extends Node

@export var menuColorList: Array[Color] = []

func _on_menu_game_selected(game_launch_resource: GameMenuSettings) -> void:
	$Menu.queue_free()
	load_game(game_launch_resource)
	

func _ready() -> void:
	Engine.time_scale = 1
	get_tree().paused = false
	if MenuColor.firstLoad:
		randomize()
		MenuColor.activeColor = menuColorList.pick_random()
		MenuColor.firstLoad = false
	get_child(0).colorChanger()
	
func load_game(game_launch_resource: GameMenuSettings):
	get_tree().set_physics_interpolation_enabled(false)
	Engine.physics_jitter_fix = 0.5
	
	if game_launch_resource.game_name == "Flappy Mickey" or game_launch_resource.game_name == "The Box":
		get_tree().set_physics_interpolation_enabled(true)
		Engine.physics_jitter_fix = 0
	
	if game_launch_resource.game_name == "The Box":
		get_tree().change_scene_to_packed(game_launch_resource.launch_scene)
					
	
	var scene = game_launch_resource.launch_scene.instantiate()
	scene.game_exited.connect(on_game_exited)
	add_child(scene)

func on_game_exited():
	for child in get_children():
		child.queue_free()
	
	var scene = preload("res://menu/menu.tscn").instantiate()
	scene.game_selected.connect(_on_menu_game_selected)
	add_child(scene)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fullScreenToggle"):
		var current_mode = DisplayServer.window_get_mode()
		if current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_button_button_down_close() -> void:
	pass # Replace with function body.
