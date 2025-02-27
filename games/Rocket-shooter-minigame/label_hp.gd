extends Label

func _ready() -> void:
	self.text = "Armor: " + str(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = "Armor: " + str(Global.hp)
