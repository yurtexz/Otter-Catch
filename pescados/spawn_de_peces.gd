extends Node2D

@export var fish_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var fish_skins: Array[Texture2D] = []
var spawn_timer: Timer
func _ready():
	spawn_fish()
	# Spawnea cada cierto tiempo
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.timeout.connect(spawn_fish)
	spawn_timer.start()

func spawn_fish():
	var fish = fish_scene.instantiate()
	add_child(fish)
	var min_y = 100
	var max_y = 400

	# Posición fija en X, aleatoria en Y
	var spawn_x_positions := [-999.0, 999.0] # por ejemplo, fuera del borde izquierdo
	var spawn_y = randf_range(min_y, max_y)
	
	var spawn_x = spawn_x_positions[randi() % spawn_x_positions.size()]
	fish.position = Vector2(spawn_x, spawn_y)
	if spawn_x < 0:
		fish.direction = Vector2.RIGHT
		fish.get_node("Sprite2D").flip_h = false

	else:
		fish.direction = Vector2.LEFT
		fish.get_node("Sprite2D").flip_h = true
	fish.speed = randf_range(80, 150)
	fish.skins = fish_skins
	fish.set_random_skin()
