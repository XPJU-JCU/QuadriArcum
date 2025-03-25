extends Camera3D

#
# =========== PARAMETRY KAMERY ===========
#
@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 2.5, -7.5)

#  "pružnost" a "tlumení" pro PŘESUN (jak v původním kódu)
@export var spring_strength: Vector3 = Vector3(1, 1, 1)
@export var damping: Vector3 = Vector3(1, 1, 1)

#  "pružnost" a "tlumení" pro ROTACI
@export var rotation_spring_strength: Vector3 = Vector3(5, 5, 5)
@export var rotation_damping: Vector3 = Vector3(5, 5, 5)

# Interně uchováváme rychlost na každé ose pro POSUN
var velocity: Vector3 = Vector3.ZERO
# A nově i rotační rychlost na každé ose (v Euler úhlech)
var rotation_velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not target:
		return
	
	#
	# =========== 1) POSUN KAMERY  ===========
	#
	# Cílová (desired) pozice kamery
	var desired_position = target.global_transform.origin + offset
	
	# Odchylka od aktuální pozice
	var displacement = desired_position - global_transform.origin
	
	# "Zrychlení" (pružinový efekt) pro jednotlivé osy
	var acceleration = Vector3(
		displacement.x * spring_strength.x,
		displacement.y * spring_strength.y,
		displacement.z * spring_strength.z
	)
	
	# Aktualizujeme rychlost
	velocity += acceleration * delta
	
	# Aplikujeme tlumení
	velocity.x *= 1.0 - damping.x * delta
	velocity.y *= 1.0 - damping.y * delta
	velocity.z *= 1.0 - damping.z * delta
	
	# Posuneme kameru
	var new_transform = global_transform
	new_transform.origin += velocity * delta
	
	#
	# =========== 2) ROTACE KAMERY  ===========
	#
	# Spočítáme, kam se *ideálně* dívat – třeba do pozice targetu:
	var to_target = target.global_transform.origin - new_transform.origin
	# (Pokud chcete přesně "look_at" target, tak nemusíte brát ohled na offset.)
	
	# Získáme "desired" a "current" rotaci v Euler úhlech.
	# - desired je rotace, kterou by kamera měla mít, aby mířila přesně na target.
	# - current je aktuální rotace kamery.
	#
	# Pomocí Basis.looking_at vytvoříme Basis z orientace směrem k to_target:
	var desired_basis = Basis().looking_at(to_target.normalized(), Vector3.UP)
	var desired_euler = desired_basis.get_euler()  # Euler XYZ
	var current_euler = new_transform.basis.get_euler()
	
	# Rozdíl rotací
	var rotation_diff = desired_euler - current_euler
	
	# Pružinové "zrychlení" rotační rychlosti
	var rotation_accel = Vector3(
		rotation_diff.x * rotation_spring_strength.x,
		rotation_diff.y * rotation_spring_strength.y,
		rotation_diff.z * rotation_spring_strength.z
	)
	
	# Aktualizujeme rotační rychlost a tlumíme
	rotation_velocity += rotation_accel * delta
	
	rotation_velocity.x *= 1.0 - rotation_damping.x * delta
	rotation_velocity.y *= 1.0 - rotation_damping.y * delta
	rotation_velocity.z *= 1.0 - rotation_damping.z * delta
	
	# Nová rotace
	var new_euler = current_euler + rotation_velocity * delta
	new_transform.basis = Basis().from_euler(new_euler)
	
	#
	# =========== 3) ULOŽENÍ NOVÉHO TRANSFORMU  ===========
	#
	global_transform = new_transform
