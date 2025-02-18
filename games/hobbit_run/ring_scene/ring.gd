extends Area2D

func ring_phase(body):
	if body.name == "hobbit":
		self.queue_free()
	
		var main = get_node("/root/Main")  # Adjust the path if needed
		main.sauron_phase()  # Call the function from Main
