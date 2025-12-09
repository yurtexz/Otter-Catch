extends Area2D
@export var speed := 90.0
@export var direction := 1     # 1 = derecha, -1 = izquierda
@export var constant_y := 650  # posición Y fija
@onready var screen_size := get_viewport_rect().size
@onready var sprite_an := $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y= 1150
	position.x = 0
	sprite_an.play()
	return

func _process(delta: float) -> void:
	position.x += direction * speed * delta
	#Si sale fuera de la pantalla, se elimina
	if position.x > screen_size.x + 960:
		queue_free()

			
