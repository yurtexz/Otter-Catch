extends Area2D
# Fish.gd — pez que nada en horizontal y se destruye al salir

@export var speed: float = 80.0

var direction: Vector2 = Vector2.LEFT

@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")


func _ready() -> void:
	if sprite == null:
		push_warning("Fish.gd: no encontré hijo 'Sprite2D'.")
	else:
		# Color normal
		sprite.self_modulate = Color(1, 1, 1)


func _process(delta: float) -> void:
	# Movimiento horizontal
	position += direction * speed * delta

	# Si sale de la pantalla por los lados, se destruye
	var vp_size: Vector2 = get_viewport().get_visible_rect().size
	if global_position.x < -100.0 or global_position.x > vp_size.x + 100.0:
		queue_free()


# El spawner llama a esto para decidir desde qué lado viene
func set_move_from_left(from_left: bool) -> void:
	# Si aparece desde la izquierda, se mueve hacia la derecha
	direction = Vector2.RIGHT if from_left else Vector2.LEFT

	# Voltear sprite según dirección (ajusta si se ve al revés)
	if sprite:
		sprite.flip_h = not from_left
