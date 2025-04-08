extends RigidBody3D

class_name Player

@export var score: int = 0

@export var prefabs: Array[PackedScene] = []
var multiplyInt: int = 0

var input = .0
@export var horizontalSpeed = 25
@export var forwardSpeed = 15
@export var playerControl = true
var doOnce = true

@export var scoreLabel: Label
@export var scoreLayer: CanvasLayer

@export var endScoreLabel: Label
@export var endHightLabel: Label
@export var nameLabel: Label
@export var endLayer: CanvasLayer

@export var gameControl: Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	spawnRandomPrefab(-40)
	spawnRandomPrefab(-60)
	spawnRandomPrefab(-80)
	spawnRandomPrefab(-100)
	playerControl = not GlobalBox.firstLoad
	if not GlobalBox.firstLoad:
		nameLabel.text = "GAME OVER"
		endScoreLabel.show()
		endLayer.hide()

func _physics_process(delta):
	if playerControl:
		linear_velocity = Vector3(horizontalSpeed * -input, linear_velocity.y, -forwardSpeed)
		score = abs(round(position.z))
		scoreLabel.text = str(score)
		# print (score)
		if position.y < -5:
			playerControl = false
		if multiplyInt * 20 == roundi(position.z):
			multiplyInt = multiplyInt - 1
			spawnRandomPrefab(-1)
	else:
		if doOnce:
			doOnce = false
			scoreLayer.hide()
			endScoreLabel.text = "Current score: " + str(score)
			var getScore = gameControl.highScore
			# print(getScore)
			if score > getScore:
				getScore = score
				gameControl.saveHighScore(getScore)
				gameControl.highScore = getScore
			endHightLabel.text = "High score: " + str(getScore)
			endLayer.show()
			# print("END")

func _input(event):
	input = Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right")
	if Input.is_action_just_pressed("fullScreenToggle"):
		toggleFullscreen()
	if ((event is InputEventKey and event.pressed and not event.echo) or event is InputEventJoypadButton) and not playerControl: 
		GlobalBox.firstLoad = false
		get_tree().reload_current_scene()

func toggleFullscreen():
	var current_mode = DisplayServer.window_get_mode()
	
	if current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func spawnRandomPrefab(overwrite):
	if prefabs.is_empty():
		print("JAK BY TO MOHLO ASI TAK FUNGOVAT, KDYŽ TAM NIC NENÍ")
		return
	var randomIndex = randi() % prefabs.size()
	var newObject = prefabs[randomIndex].instantiate()
	call_deferred("add_sibling", newObject)
	call_deferred("setNewObjectTransform", newObject, overwrite, multiplyInt)
	var randomAngle = 180 * (randi() % 2)
	newObject.rotation_degrees.y = randomAngle

func setNewObjectTransform(newObject, setOverwrite, multiplySave):
	if setOverwrite == -1:
		newObject.global_transform.origin = Vector3(0, 0, multiplySave * 20 - 100)
		if not GlobalBox.firstLoad:
			var t = Timer.new()
			t.one_shot = true
			t.wait_time = forwardSpeed
			t.autostart = true
			newObject.add_child(t)
			t.connect("timeout", Callable(newObject, "queue_free"))
	else:
		newObject.global_transform.origin = Vector3(0, 0, setOverwrite)
		

func _on_body_entered(body):
	if body is Enemy and playerControl:
		playerControl = false
