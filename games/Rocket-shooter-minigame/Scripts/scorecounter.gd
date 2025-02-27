extends Label

func _ready() -> void:
	self.text = "Score: " + str(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = "Score: " + str(Global.score)
	
