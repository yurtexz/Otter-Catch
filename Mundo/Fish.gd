extends Area2D

@export var speed := 80.0

var direction: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	# Por si el spawner no llamó a set_move_from_left, por defecto va a la derecha
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT


func set_move_from_left(from_left: bool) -> void:
	# Si aparece desde la izquierda, se mueve a la derecha.
	# Si aparece desde la derecha, se mueve a la izquierda.
	direction = Vector2.RIGHT if from_left else Vector2.LEFT

	# Voltear sprite para que mire en el sentido de avance
	if sprite:
		sprite.flip_h = not from_left  # ajusta si tu sprite está al revés


func _process(delta: float) -> void:
	# Mover según la dirección
	position += direction * speed * delta

	# Si sale de la pantalla, destruir
	var vp := get_viewport_rect().size
	if global_position.x < -100.0 or global_position.x > vp.x + 100.0:
		queue_free()
