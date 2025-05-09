extends CharacterBody2D

@export var speed = 1000
@export var rotation_speed = 7 
var rotation_direction = 0

signal player_died

@export var hp : int = Global.hp:
	set(newhp):
		hp = newhp
		if(hp < 1):
			$"../Main_music".stop()
			$"../Score/Game_over".visible = true
			if Engine.time_scale == 1:
				$"../Score/Game_over/BtnRestart".grab_focus.call_deferred()
			Engine.time_scale = 0
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			hp=1
			

@onready var projectile = preload("res://games/Rocket-shooter-minigame/Bullet.tscn")
@export var spawnpoint : Sprite2D

func _ready():
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_MAX)

func get_input():
	if (Engine.time_scale == 1):
		#if (global_position.distance_to(get_global_mouse_position()) > 50):	
		#	look_at(get_global_mouse_position())
		#velocity = transform.x * Input.get_axis("down", "up") * speed
			
		if Input.is_action_just_pressed("shoot"):
			$"../Shot".play()
			shoot()
		if Input.is_action_just_pressed("Pause"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://main/main.tscn")
	

func _physics_process(delta):	
	get_input()
	rotation += Input.get_axis("left", "right") * rotation_speed * delta
	if Input.is_action_pressed("up"):
		velocity = (velocity + Vector2.from_angle(rotation) * speed * delta).clamp(Vector2(-400, -400), Vector2(400,400))
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision : KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider() is StaticBody2D:
			velocity = Vector2.ZERO
			
	hp = Global.hp
	
func shoot():
	var instance = projectile.instantiate()
	instance.dir = spawnpoint.global_rotation 
	instance.spawnPos = spawnpoint.global_position
	instance.spawnRot = rotation
	get_tree().current_scene.add_child(instance)	

func checkEntry(body : Node2D):
	for i in body.get_groups():
		if (i == "Enemies"):
			hp-=1
			Global.hp -= 1
			$"../Death".play()
		if (i == "Shield_collectible"):
			hp+=1
			Global.hp += 1
			body.queue_free()
			$"../Shield".play()

func _on_area_2d_body_entered(body: Node2D):
	checkEntry(body)
	
			
func _on_area_2d_area_entered(area: Area2D):
	checkEntry(area)


func _on_btn_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://games/Rocket-shooter-minigame/main.tscn")
	Global.score -= Global.score
	Global.hp -= Global.hp
	Global.hp += 1


func _on_btn_menu_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://main/main.tscn")
	
