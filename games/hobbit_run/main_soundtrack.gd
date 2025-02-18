extends AudioStreamPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var main_node = get_parent()
	if main_node.sauron_phase_active:
		pitch_scale = 0.9 
	else:
		pitch_scale = 1
