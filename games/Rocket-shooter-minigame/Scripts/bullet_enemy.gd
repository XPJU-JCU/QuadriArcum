extends CharacterBody2D

@export var SPEED = 400
const Target = preload("res://games/Rocket-shooter-minigame/player.tscn")
var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos 
	global_rotation = spawnRot

func _physics_process(delta):
	velocity = Vector2(cos(dir),sin(dir)) * SPEED
	move_and_slide()
	
	for i in get_slide_collision_count():
		if (i == get_slide_collision_count()-1):
			Global.hp -= 1
			print(str(Global.hp))
		

func _on_timer_timeout() -> void:
	queue_free()
