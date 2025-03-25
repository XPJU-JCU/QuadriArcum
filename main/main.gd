extends Node


func _on_menu_game_selected(game_launch_resource: GameMenuSettings) -> void:
	$Menu.queue_free()
	load_game(game_launch_resource)
	

func _ready() -> void:
	Engine.time_scale = 1

func load_game(game_launch_resource: GameMenuSettings):
	var config = ConfigFile.new()
	var err = config.load(game_launch_resource.game_config)

	if err != OK:
		return
		
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			ProjectSettings.set_setting(section+"/"+key, config.get_value(section, key))
			match section:
				"input":
					InputMap.load_from_project_settings()
					
	
	var scene = game_launch_resource.launch_scene.instantiate()
	scene.game_exited.connect(on_game_exited)
	add_child(scene)


func on_game_exited():
	for child in get_children():
		child.queue_free()
	
	var scene = preload("res://menu/menu.tscn").instantiate()
	scene.game_selected.connect(_on_menu_game_selected)
	add_child(scene)
