extends Node2D

signal game_exited


func _on_player_player_died() -> void:
	game_exited.emit()
