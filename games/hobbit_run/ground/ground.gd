extends Sprite2D


const normal = preload("res://games/hobbit_run/ground/ground (2).png")
const sauron = preload("res://games/hobbit_run/ground/sauron_ground.png")

func _process(delta):
	var main_node = get_parent()
	if main_node.sauron_phase_active:
		texture = sauron
	else:
		texture = normal
 
