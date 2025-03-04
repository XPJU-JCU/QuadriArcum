extends CharacterBody2D

@export var speed=3500
var target_pos
var player
var player_pos
@export var spawnpoint : Sprite2D
@onready var projectile = preload("res://games/Rocket-shooter-minigame/Bullet_enemy.tscn")


func _ready() -> void:
	player = get_parent().get_parent().get_parent().get_node("player")


func _physics_process(delta):
	player_pos = player.position
	target_pos = (player_pos - position).normalized()
	velocity = target_pos * speed * delta
	look_at(player_pos)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	for i in body.get_groups():
		if (i == "Asteroids"):
			queue_free()


func _on_shoot_cooldown_timeout() -> void:
	shoot()

func shoot():

	var instance = projectile.instantiate()
	instance.dir = spawnpoint.global_rotation 
	instance.spawnPos = spawnpoint.global_position
	instance.spawnRot = rotation
	get_tree().current_scene.add_child(instance)	
