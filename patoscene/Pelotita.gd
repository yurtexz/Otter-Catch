extends Area2D

@export var velocidad = 250.0

func _process(delta):
	position.y += velocidad * delta
	if position.y > 500:  # Donde se rompe la pelotita 
		queue_free()
