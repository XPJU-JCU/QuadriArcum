extends Control

@export var button : Button
@export var textLabel : Label
@export var textureRect : TextureRect
@export var numberSlot : int
@export var audioSlot : AudioStreamPlayer

var menu: CanvasLayer
var game_resoure : GameMenuSettings

signal game_selected(game_launch_resource)


func _ready() -> void:
	# button.text = game_resoure.game_name
	textLabel.text = game_resoure.game_name
	# print(game_resoure.game_name)
	

func set_game_resoure(game_resoure, slot, callBack):
	menu = callBack
	self.game_resoure = game_resoure
	numberSlot = slot
	changeState()
	
func changeState():
	if numberSlot == MenuColor.activeSlot:
		textureRect.show()
	else:
		textureRect.hide()
	audioSlot.play(0)

func _on_button_pressed() -> void:	
	audioSlot.play()
	game_selected.emit(game_resoure)


func take_focus():
	$Button.grab_focus.call_deferred()
	menu.change_info(game_resoure)
	

func _on_button_focus_entered() -> void:
	MenuColor.activeSlot = numberSlot
	take_focus()
	changeState()

func _on_button_focus_exited() -> void:
	textureRect.hide()

func _on_button_mouse_entered() -> void:
	take_focus()

func _on_button_mouse_exited() -> void:
	pass
