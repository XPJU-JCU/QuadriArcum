extends Node

@export var enemy: PackedScene
@export var materialList: Array[StandardMaterial3D] = []
@export var spawnInterval = 2.0
@export var minScale = 1
@export var maxScale = 10
@export var player: RigidBody3D
@export var highScore = 0

func _ready():
	loadHighScore()

func _on_timer_timeout() -> void:
	
	var obstacle = enemy.instantiate()
	var randomScale = Vector3(
		randf_range(minScale, maxScale),
		randf_range(minScale, maxScale),
		randf_range(minScale, maxScale)
		)
	var randomPos = randf_range(-7.5, 7.5)
	call_deferred("add_child", obstacle)
	call_deferred("setNewObjectTransform", obstacle, randomPos, randomScale)
	
func setNewObjectTransform(newObject, pos, size):
	newObject.global_transform.origin = Vector3(pos, 15, player.position.z - 100)
	
	var collisionShapeNode = newObject.get_node_or_null("CollisionShape3D")
	if collisionShapeNode:
		var originalShape = collisionShapeNode.shape
		
		var newShape = originalShape.duplicate(true)
		newShape.size = size
		collisionShapeNode.shape = newShape
		
		var meshInstance = newObject.get_node_or_null("MeshInstance3D")
		meshInstance.scale = size
		meshInstance.material_override = materialList[randi() % materialList.size()]
		
		var t = Timer.new()
		t.one_shot = true
		t.wait_time = 15
		t.autostart = true
		newObject.add_child(t)
		t.connect("timeout", Callable(newObject, "queue_free"))
		
func loadHighScore():
	var file = FileAccess.open("user://highscore.save", FileAccess.READ)
	if file != null:
		highScore = file.get_var()
		file.close()
	else:
		highScore = 0

func saveHighScore(newScore):
	if newScore > highScore:
		highScore = newScore
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	if file != null:
		file.store_var(highScore)
		file.close()
