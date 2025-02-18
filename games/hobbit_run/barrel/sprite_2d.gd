extends Sprite2D

const normal = preload("res://barrel/3.png")
const sauron = preload("res://barrel/sauron_barrel_better.png")

func sauron_sprite(b : bool):
	if b:
		texture = sauron
		print("It should happen")
		
	else:
		texture = sauron
		print("Idkman")
