extends Area2D

@export var velocidad = 250.0

func _process(delta):
	position.y += velocidad * delta
	if position.y > 350:  # Donde se rompe la pelotita 
		queue_free()
