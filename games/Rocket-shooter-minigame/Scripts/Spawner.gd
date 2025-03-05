extends Node2D

@onready var enemy = preload("res://games/Rocket-shooter-minigame/Enemies/Monster.tscn")
@onready var enemy2 = preload("res://games/Rocket-shooter-minigame/Enemies/Asteroid.tscn")
@onready var enemy3 = preload("res://games/Rocket-shooter-minigame/Enemies/EnemyUFO.tscn")
@onready var shield = preload("res://games/Rocket-shooter-minigame/Pickups/Shield.tscn")
@export var pathAster : Path2D

var turn = 0

var pos : Vector2
var pointsArray : Array

@export var timer : Timer
@export var timerA : Timer

func _ready() -> void:
	pointsArray = pathAster.curve.get_baked_points()
	

func _on_arteroids_timeout() -> void:
	var chosen = (randi() % pointsArray.size()-1) - 0
	pos = pointsArray[chosen]
	var ene = enemy2.instantiate()
	ene.position = pos
	add_child(ene)

func _on_monsters_timeout() -> void:
	var ene
	var chosen = (randi() % pointsArray.size()-1) - 0
	pos = pointsArray[chosen]
	if (turn == 0):
		ene = enemy.instantiate()
		turn = 1
	else: 
		ene = enemy3.instantiate()
		turn = 0
	ene.position = pos
	add_child(ene)
	timer.wait_time *= 0.998
	#print(str(timer.wait_time))
	timer.start()

func _on_pickups_timeout() -> void:
	var pos = Vector2((randi() % 1000 - 500),(randi() % 570 - 300))
	var ene = shield.instantiate()
	ene.position = pos
	add_child(ene)
