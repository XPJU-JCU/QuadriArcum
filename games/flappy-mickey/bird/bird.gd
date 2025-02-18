extends RigidBody2D

# Script pro ptačisko

@export var flap_force : float = 100 	# Síla která je aplikována fyzickému tělesu pro flap(skok jakoby)
@export var sprite : Sprite2D

signal pipe_cleared
signal pipe_touched


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flap"):		# Když jsem práve zmáčknou mnou definovaný input flap
		if linear_velocity.y > 0:					# Když pták padá, nastavím jeho vertikální rychlost na 0,
			linear_velocity.y = 0					# 	aby měl hráč lepší kontrolu nad ovládáním ptáka
		apply_impulse(Vector2(0, -flap_force))		# Aplikuji flap_force na sebe(což je pták, který je fyzický těleso)
													# 	Nemusíme aplikovat deltu, jelikož se akce nevykonává periodicky, ale přesně v moment když stisknem tlačítko
	
	sprite.rotation_degrees = clamp(linear_velocity.y/10, -70, 70)	# Otáčím sprite v závislosti na vertikální rychlosti a zároveň omezuji výseč rotace, ať se to netočí jako káča


func _on_body_entered(body: Node) -> void:
	if body.get_collision_layer() == 4:
		pipe_touched.emit()
	# Když se pták dotkne tělesa v kolizní vrstvě 4(vrstva pro trubky),
	#	tak vyšle signál pipe_touched
