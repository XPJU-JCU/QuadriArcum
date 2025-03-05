extends Label

func _ready() -> void:
	self.text = str(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Global.hp > -1):
		self.text = str(Global.hp)
