extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1800
const DUCK_GRAVITY : int = 6000 

var sprite : AnimatedSprite2D
var wears_ring : bool

func _physics_process(delta):
	if wears_ring:
		sprite = $SauronSprite
		$SauronSprite.visible = true
		$AnimatedSprite2D.visible = false
	else:
		sprite = $AnimatedSprite2D
		$SauronSprite.visible = false
		$AnimatedSprite2D.visible = true
		
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if not get_parent().game_running:
			sprite.play("still")
		else: 
			#$normalColision2.disabled = false
			if Input.is_action_pressed("ui_accept"):
				$jump_sound.pitch_shifting()
				velocity.y = JUMP_SPEED
			else: 
				sprite.play("run")
				$run_sound.pitch_shifting()
	else:
		if Input.is_action_pressed("ui_accept"):
			sprite.play("jump")  # Holding space continues jump animation
		else:
			velocity.y += DUCK_GRAVITY * delta  # Increase gravity when space is released
			sprite.play("jump")  # Play fall animation
	
	move_and_slide()
