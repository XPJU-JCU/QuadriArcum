extends RigidBody2D

var move_amount : float = 20


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	position.x -= move_amount * state.step
