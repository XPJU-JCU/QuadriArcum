extends MarginContainer

@export var button : Button

var game_resoure : GameMenuSettings

signal game_selected(game_launch_resource)

static var a = 1

func _ready() -> void:
	button.text = str(a)
	a+=1
	button.icon = game_resoure.game_icon
	
	

func set_game_resoure(game_resoure):
	self.game_resoure = game_resoure


func _on_button_pressed() -> void:	
	game_selected.emit(game_resoure)


func take_focus():
	$VBoxContainer/MarginContainer2/Button.grab_focus.call_deferred()
