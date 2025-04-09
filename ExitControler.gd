extends Node

@onready var colorRect = $PopUpColorRect
@onready var mainPopUp = $PopUpPanel
@export var exitButton = Button
@export var closeButton = Button

@onready var targetPosition: Vector2 = Vector2(346, 187)

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
		slide_out_popup()
		tween.tween_property(colorRect, "color", endColor, 0.15)
		await get_tree().create_timer(0.15).timeout
		mainPopUp.hide()
		colorRect.hide()
	else:
		endColor.a = 0.75
		mainPopUp.show()
		colorRect.show()
		slide_in_popup()
		tween.tween_property(colorRect, "color", endColor, 0.25)
	dark = !dark

func _on_button_button_down(button):
	if button.name == "ExitButton":
		get_tree().quit()
	else:
		toggle_dark()

func slide_in_popup():
	mainPopUp.position = Vector2(1152, targetPosition.y)

	var tween = create_tween()
	tween.tween_property(mainPopUp, "position", targetPosition + Vector2(-40, 0), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(mainPopUp, "position", targetPosition, 0.05)

func slide_out_popup():
	var tween = create_tween()
	tween.tween_property(mainPopUp, "position", Vector2(1152, mainPopUp.position.y), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
