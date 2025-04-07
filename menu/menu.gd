extends CanvasLayer

@export var game_menu_settings_dir : String
@export var menu_game_item : PackedScene
@export var newGameItem : PackedScene
@export var hbox : HBoxContainer
@export var vbox : VBoxContainer
@export var mainColor : ColorRect
@export var textureColor : TextureRect
@export var nameLabel : Label
@export var nameLabelDisable : Label

@export var colorPicture: bool
@export var pictureColor: TextureRect

@export var infoName: Label
@export var infoImage: TextureRect
@export var infoDescription: Label

@export var fullScreenButton: Button
@export var fullScreenOn: CompressedTexture2D
@export var fullScreenOff: CompressedTexture2D

signal game_selected(game_launch_resource)

func _ready() -> void:
	load_menu_games()
	#colorChanger()

func colorChanger():
	var colorAlfa = MenuColor.activeColor
	var colorBeta = MenuColor.activeColor
	colorAlfa.a = 0.6
	colorBeta.a = 0.8
	mainColor.color = colorAlfa
	textureColor.modulate = colorBeta
	if colorPicture:
		pictureColor.self_modulate = colorAlfa

func change_info(data):
	infoName.text = data.game_name
	infoImage.texture = data.game_icon
	infoDescription.text = data.game_description

func load_menu_games():
	var dir = DirAccess.open(game_menu_settings_dir)
	
	var files = dir.get_files()
	
	# var was_focus_given = false
	#for file in files:
	#	var new_game_resource = load(game_menu_settings_dir+file)
	#	var scene = menu_game_item.instantiate()
	#	var scene = newGameItem.instantiate()
	#	scene.set_game_resoure(new_game_resource)
	#	var focusFirst = file == files[0]
	#	scene.set_game_resoure(new_game_resource, focusFirst)
	#	scene.game_selected.connect(on_game_selected)
	#	if focusFirst:
	#	scene.take_focus()
	#	 if was_focus_given == false:
	#	scene.take_focus()
	#	was_focus_given = true
	#	hbox.add_child(scene)
	#	vbox.add_child(scene)
		
	for i in files.size():
		var new_game_resource = load(game_menu_settings_dir+files[i])
		var scene = newGameItem.instantiate()
		scene.set_game_resoure(new_game_resource, i, self)
		scene.game_selected.connect(on_game_selected)
		if i == MenuColor.activeSlot:
			scene.take_focus()
		vbox.add_child(scene)
		
func on_game_selected(game_launch_resource):
	game_selected.emit(game_launch_resource)

func _on_timer_timeout() -> void:
	var randomChoose = randi_range(0, 9)
	if randomChoose == 0:
		nameLabel.hide()
		nameLabelDisable.show()
	else:
		nameLabel.show()
		nameLabelDisable.hide()

func _on_button_button_down() -> void:
	var current_mode = DisplayServer.window_get_mode()
	
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullScreenButton.icon = fullScreenOn
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullScreenButton.icon = fullScreenOff
