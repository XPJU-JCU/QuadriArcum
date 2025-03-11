extends Area2D

#@onready var main = preload("res://games/hobbit_run/main.tscn")  # Adjust the path if needed
#@onready var main = get_tree().get_root().find_node("Main",  true, false)

func ring_phase(body):
	if body.name == "hobbit":
		self.queue_free()
		
		var main = get_parent()
		main.sauron_phase()  # Call the function from Main  
