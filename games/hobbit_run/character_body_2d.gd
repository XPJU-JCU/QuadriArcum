extends CharacterBody2D

const GRAVITY : int = 4200 
const JUMP_SPEED : int = -1800 

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("ui_accept"):
		velocity.y = JUMP_SPEED
		#$jump-sound-14839.play()
		
		move_and_slide()
