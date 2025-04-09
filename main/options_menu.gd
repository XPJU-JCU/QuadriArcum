extends Node

@export var colorRect = ColorRect
@onready var optionPanel = $OptionPanel
@export var saveChanges = Button
@export var discardChanges = Button

var dark = false

func _ready():
	$OptionPanel/VBoxContainer/Control2/HBoxContainer/Panel/SaveButton.button_down.connect(_on_button_button_down.bind(saveChanges))
	$OptionPanel/VBoxContainer/Control2/HBoxContainer/Panel2/DiscardButton.button_down.connect(_on_button_button_down.bind(discardChanges))

func _input(event):
	if event.is_action_pressed("fullScreenToggle"):
		toggle_dark()

func toggle_dark():
	var tween = create_tween()
	var startColor = colorRect.color
	var endColor = startColor

	if dark:
		endColor.a = 0.0
		optionPanel.hide()
		tween.tween_property(colorRect, "color", endColor, 0.1)
	else:
		endColor.a = 0.75
		tween.tween_property(colorRect, "color", endColor, 0.25)
		optionPanel.show()
	dark = !dark

func _on_button_button_down(button):
	if button.name == "SaveChanges":
		print("saved")
		#save all changes
	else:
		#discard all changes
		print("discarted")
