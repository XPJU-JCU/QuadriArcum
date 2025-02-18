extends AudioStreamPlayer2D


func _process(delta: float) -> void:
	var main_node = get_parent().get_parent()  
	if main_node.sauron_phase_active:
		pitch_scale = 0.85
