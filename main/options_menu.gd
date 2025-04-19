extends Node

@onready var settPanel = $Sett
@onready var muteButton = $Sett/SettingsChoose/HBoxContainer/Options/MainPanel/Right/MuteB
@onready var volumeSlider = $Sett/SettingsChoose/HBoxContainer/Options/MainPanel/Right/VolumeB
@onready var language = $Sett/SettingsChoose/HBoxContainer/Options/MainPanel/Right/LanguageB

@export 	var audio_index = AudioServer.get_bus_index("Master")
@export var master_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

@export var is_muted : bool

func _ready():
	#we start with english
	language.select(0)
	
	#muted button needs to be already checked, if muted 
	is_muted = AudioServer.is_bus_mute(audio_index)
	if is_muted:
		muteButton.set_pressed(true)
	
	#slider update
	var linear = db_to_linear(master_volume) * 100
	volumeSlider.set_value_no_signal(linear) #linear

#volume change
func _on_volume_b_value_changed(value: float) -> void:
	var linear_volume = value / 100.0
	var db = linear_to_db(linear_volume)
	AudioServer.set_bus_volume_db(audio_index, db)

#mute
func _on_mute_b_button_down() -> void:
	is_muted = AudioServer.is_bus_mute(audio_index)
	AudioServer.set_bus_mute(audio_index, !is_muted)

#full screen - doesnt work, why tho?
func _on_full_screen_b_button_down() -> void:
	var current_mode = DisplayServer.window_get_mode()
	
	if current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

#languages
func _on_language_b_item_selected(index: int) -> void:
	var selected = language.get_item_text(index)
	if (selected != "English"):
		$Sett/SettingsChoose/English/EnglishOption.play()
		language.select(0)
