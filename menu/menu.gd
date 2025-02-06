extends CanvasLayer

@export var game_menu_settings_dir : String
@export var menu_game_item : PackedScene
@export var hbox : HBoxContainer

signal game_selected(game_launch_resource)

func _ready() -> void:
	load_menu_games()
	

func load_menu_games():
	var dir = DirAccess.open(game_menu_settings_dir)
	
	var was_focus_given = false
	for file in dir.get_files():
		var new_game_resource = load(game_menu_settings_dir+file)
		var scene = menu_game_item.instantiate()
		scene.set_game_resoure(new_game_resource)
		scene.game_selected.connect(on_game_selected)
		if was_focus_given == false:
			scene.take_focus()
			was_focus_given = true
		hbox.add_child(scene)
		
		
func on_game_selected(game_launch_resource):
	game_selected.emit(game_launch_resource)
