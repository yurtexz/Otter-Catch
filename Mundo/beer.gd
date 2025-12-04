extends Area2D

@export var speed := 80.0

var direction: Vector2 = Vector2.ZERO
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

func set_move_from_left(from_left: bool) -> void:
	# Si viene desde la izquierda, va a la derecha; si no, al revés
	direction = Vector2.RIGHT if from_left else Vector2.LEFT
	if sprite:
		sprite.flip_h = not from_left

func _process(delta: float) -> void:
	position += direction * speed * delta

	var vp := get_viewport_rect().size
	if global_position.x < -100.0 or global_position.x > vp.x + 100.0:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	# Solo reaccionar si chocó con la carnada de la caña
	if area.name == "Bait":
		var rod = area.get_parent()  # Rod es el padre de Bait
		if rod:
			var otter = rod.get_parent()  # Otter es el padre de Rod
			if otter:
				# Si la nutria tiene la variable vida, la reducimos
				if "vida" in otter:
					otter.take_hit()

		# Destruir la cerveza después del impacto
		queue_free()
