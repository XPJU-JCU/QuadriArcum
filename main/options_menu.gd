extends Node

@export var colorRect = ColorRect
@onready var settPanel = $Sett
@export var saveChanges = Button
@export var discardChanges = Button

@export var fullScreenButton: Button
@export var fullScreenOn: CompressedTexture2D
@export var fullScreenOff: CompressedTexture2D

var dark = false

#func _ready():
#	$OptionPanel/VBoxContainer/Control2/HBoxContainer/Panel/SaveButton.button_down.connect(_on_button_button_down.bind(saveChanges))
#	$OptionPanel/VBoxContainer/Control2/HBoxContainer/Panel2/DiscardButton.button_down.connect(_on_button_button_down.bind(discardChanges))

func _input(event):
	if event.is_action_pressed("fullScreenToggle"):
		toggle_dark()

func toggle_dark():
	var tween = create_tween()
	var startColor = colorRect.color
	var endColor = startColor

	if dark:
		endColor.a = 0.0
		settPanel.hide()
		tween.tween_property(colorRect, "color", endColor, 0.1)
	else:
		endColor.a = 0.75
		tween.tween_property(colorRect, "color", endColor, 0.25)
		settPanel.show()
	dark = !dark



func _on_mute_b_button_toggled() -> void:
	print("mute")

func _on_volume_b_value_changed(value: float) -> void:
	print("vol")

#full screen
func _on_full_screen_b_button_down() -> void:
	var current_mode = DisplayServer.window_get_mode()
	
	if current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

#languages
func _on_language_b_button_down() -> void:
	print("Lang")
