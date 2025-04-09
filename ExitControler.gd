extends Node

@export var colorRect = ColorRect
@onready var mainPopUp = $PopUpPanel
@export var exitButton = Button
@export var closeButton = Button

var dark = false

func _ready():
	exitButton.button_down.connect(_on_button_button_down.bind(exitButton))
	closeButton.button_down.connect(_on_button_button_down.bind(closeButton))

func _input(event):
	if event.is_action_pressed("Back_to_main"):
		toggle_dark()

func toggle_dark():
	var tween = create_tween()
	var startColor = colorRect.color
	var endColor = startColor

	if dark:
		endColor.a = 0.0
		mainPopUp.hide()
		tween.tween_property(colorRect, "color", endColor, 0.1)
	else:
		endColor.a = 0.75
		tween.tween_property(colorRect, "color", endColor, 0.25)
		mainPopUp.show()
	dark = !dark

func _on_button_button_down(button):
	if button.name == "ExitButton":
		get_tree().quit()
	else:
		toggle_dark()
