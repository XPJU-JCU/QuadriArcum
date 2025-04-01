extends Sprite2D


func _process(delta: float) -> void:
	if $"..".is_game_over:
		return
	
	var rect := get_region_rect()
	rect.position.x += 60 * delta
	set_region_rect(rect)
