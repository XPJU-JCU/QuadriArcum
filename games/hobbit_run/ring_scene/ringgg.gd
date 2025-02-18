extends AudioStreamPlayer2D

func pitch_shifting():
	pitch_scale = randf_range(0.7, 1)
	play() 
