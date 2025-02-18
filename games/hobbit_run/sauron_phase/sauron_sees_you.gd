extends Node2D

func _process(delta):
	var sprites = [$"ParallaxBackground/the rest", $ParallaxBackground/eye]

	for sprite in sprites:
		sprite.play("default")
