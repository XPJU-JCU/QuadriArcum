extends Area2D

#Script kterej pouze odstraňuje trubky ze hry, když hitnou areu za viditelným levlem

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
