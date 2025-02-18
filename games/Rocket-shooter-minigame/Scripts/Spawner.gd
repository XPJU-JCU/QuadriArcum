extends Node2D

@onready var enemy = preload("res://games/Rocket-shooter-minigame/Enemies/Monster.tscn")
@onready var enemy2 = preload("res://games/Rocket-shooter-minigame/Enemies/Asteroid.tscn")
@onready var shield = preload("res://games/Rocket-shooter-minigame/Pickups/Shield.tscn")
@export var pathAster : Path2D

var pos : Vector2
var pointsArray : Array

func _ready() -> void:
	pointsArray = pathAster.curve.get_baked_points()
	

func _on_arteroids_timeout() -> void:
	var chosen = (randi() % pointsArray.size()-1) - 0
	pos = pointsArray[chosen]
	var ene = enemy2.instantiate()
	ene.position = pos
	add_child(ene)
	print(pos)

func _on_monsters_timeout() -> void:
	var chosen = (randi() % pointsArray.size()-1) - 0
	pos = pointsArray[chosen]
	var ene = enemy.instantiate()
	ene.position = pos
	add_child(ene)

func _on_pickups_timeout() -> void:
	var pos = Vector2((randi() % 1000 - 500),(randi() % 570 - 300))
	var ene = shield.instantiate()
	ene.position = pos
	add_child(ene)
	print(pos)
