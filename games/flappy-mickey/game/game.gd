extends Node

# Hlavní sript manažuje celou hru včetnš skóre, 

var score : int

@export var pipes_resource : PackedScene
@export var pipes_spawn_point : Marker2D
@export var score_label : Label
@export var timer : Timer
@export var pipes_speed : float 			# Základní rychlost trubek v pixelech
@export var pipes_speed_increment : float	# O kolik se truby zrychlují

var is_game_over = false

signal game_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false	# Spuštění hry byla by zapauzovaná


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("flap") and is_game_over:
		reset_game()
	# Když je is_game_over a zmáčkněš flap, zavolej reset_game()


# Spawnuje trubky po vypršení času na timeru
func _on_spawn_timer_timeout() -> void:
	if is_game_over:		#Pokud je is_game_over, vůbec zbytek neprováděj a returni se
		return
	
	var pipes = pipes_resource.instantiate()						# Do promněný pipes přidáme instancovanou trubku
	pipes.global_position = pipes_spawn_point.global_position		# Nastavíme trubce pozici na pozici spawn pointu trubek
	pipes.move_amount = pipes_speed									# Přiřadíme je jí rychlost z nastavenou v tomto skriptu
	pipes_speed += pipes_speed_increment							# Rychlosti trubky přidáme inkrement pro použití na další trubku
	timer.wait_time -= pipes_speed_increment / 1000					# Zkrátíme čas timeru o inkrement
	add_child(pipes)												# Přidáme trubku do hierarchie jako child tohoto objektu
	

# Volá se po clearnutí trubky
func _on_bird_pipe_cleared() -> void:
	$PipeClearedSound.play()
	score += 1							# Přidám bod
	score_label.text = str(score) 		# Aktualizuji text
	

# Resetuje hru
func reset_game() -> void:
	var flappy = preload("res://games/flappy-mickey/game/game.tscn").instantiate()
	get_parent().add_child(flappy)
	get_tree().paused = false
	self.queue_free()
	


# Volá se při dotknutí trubky
func _on_bird_pipe_touched() -> void:
	$GameOverSound.play()
	is_game_over = true
	get_tree().paused = true		# Pauzuje hru(jakoby, né úpně, není podstatný)
