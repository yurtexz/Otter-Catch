extends Area2D

@export var speed := 90.0
var is_golden := false
var direction: Vector2 = Vector2.ZERO
var hooked := false
var target_bait: Area2D = null
@onready var sprite: Sprite2D = $Sprite2D



func _ready() -> void:
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT
		if is_golden:
			sprite.self_modulate = Color(1.0, 0.85, 0.0) # dorado

func set_move_from_left(from_left: bool) -> void:
	# Si aparece desde la izquierda, se mueve a la derecha.
	# Si aparece desde la derecha, se mueve a la izquierda.
	direction = Vector2.RIGHT if from_left else Vector2.LEFT

	# Voltear sprite para que mire en el sentido de avance
	if sprite:
		sprite.flip_h = not from_left  # ajusta si tu sprite está al revés


func _process(delta: float) -> void:
	# Por si el spawner no llamó a set_move_from_left, por defecto va a la derecha
	if hooked and target_bait:
		rotation = deg_to_rad(-90)  # o 90 según cómo esté tu sprite
		global_position = target_bait.global_position 
		if global_position.y <= 500.0:
			var rod = target_bait.get_parent()
			if rod and "fish_hooked" in rod:
				rod.fish_hooked = null
				if rod.has_method("notify_fish_caught"):
					rod.notify_fish_caught()
				queue_free()
	else:
		position += direction * speed * delta

	# Si sale de la pantalla, destruir
	var vp := get_viewport_rect().size
	if global_position.x < -100.0 or global_position.x > vp.x + 100.0:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Bait":
		var rod = area.get_parent()  # la caña
		if rod and "fish_hooked" in rod:
			if rod.fish_hooked == null:
				print("El pez se enganchó")
				rod.fish_hooked = self
				hooked = true
				target_bait = area
				if(is_golden):
					rod.dorado_en = true
					print("DORADOOOOOOOO")
				else:
					rod.dorado_en = false

func make_golden():
	is_golden = true
