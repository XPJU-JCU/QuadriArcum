extends AudioStreamPlayer2D

func pitch_shifting():
	pitch_scale = randf_range(1.0, 1.9)
	play() 
