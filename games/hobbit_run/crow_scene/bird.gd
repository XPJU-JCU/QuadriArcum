extends Area2D

func _ready():
	$VisibleOnScreenNotifier2D.screen_entered.connect(kra)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= (delta * 150) #bývalo :2, ale to se nedalo :D :D get_parent().speed * delta 
	
	#sauron phase
	var main_node = get_parent() 
	if main_node.sauron_phase_active:
		$AnimatedSprite2D.play("sauron_flying")
	else:
		$AnimatedSprite2D.play("flying")
	
func kra():
	$kra.play()
