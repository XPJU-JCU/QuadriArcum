extends Area2D

const normal = preload("res://games/hobbit_run/stump/stump.png")
const sauron = preload("res://games/hobbit_run/stump/stump_sauron_better.png")

func _process(delta):
	var main_node = get_parent()
	if main_node.sauron_phase_active:
		$Sprite2D.texture = sauron
	else:
		$Sprite2D.texture = normal
