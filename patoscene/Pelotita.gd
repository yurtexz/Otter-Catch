extends RigidBody2D

@export var velocidad = 250.0

func _process(delta):
	position.y += velocidad * delta
	if position.y > 350:  # Donde se rompe la pelotita 
		queue_free()

func _on_body_entered(body):
	if body and body.is_in_group("player"):   
		body.recibir_dano(1)
		queue_free()
