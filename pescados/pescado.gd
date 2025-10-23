extends Node2D

@export var speed: float = 100.0
@export var direction: Vector2 = Vector2.LEFT
@export var skins: Array[Texture2D] = []
@onready var sprite = $Sprite2D



func set_random_skin():
	if skins.size() > 0:
		sprite.texture = skins[randi() % skins.size()]
	else:
		print("Pez sin texturas asignadas")

func _process(delta):
	position += direction * speed * delta

	if position.x < -1000 or position.x > 1050:
		queue_free()
