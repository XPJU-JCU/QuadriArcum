extends CharacterBody2D

@export var SPEED = 400
const Enemy = preload("res://games/Rocket-shooter-minigame/Enemies/Monster.tscn")

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
		get_last_slide_collision().get_collider().queue_free()
		queue_free()
		if (i == get_slide_collision_count()-1):
			Global.score += 1
		
func _on_timer_timeout() -> void:
	queue_free()
