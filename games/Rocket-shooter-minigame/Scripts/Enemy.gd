extends CharacterBody2D

@export var speed=3500
var target_pos
var player
var player_pos

func _ready() -> void:
	player = get_parent().get_parent().get_parent().get_node("player")


func _physics_process(delta):
	player_pos = player.position
	target_pos = (player_pos - position).normalized()
	velocity = target_pos * speed * delta
	look_at(player_pos)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	for i in body.get_groups():
		if (i == "Asteroids"):
			queue_free()
