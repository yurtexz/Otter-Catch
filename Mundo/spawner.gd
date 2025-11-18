extends Node2D
# Spawner de peces en lanes aleatorios

@export var fish_scene: PackedScene
@export var spawn_interval := 3.0
#@export var speed_range := Vector2(60.0, 110.0)
@export_node_path("Node2D") var lanes_path: NodePath   # arrastra aquí el nodo Lanes

var lanes_y := PackedFloat32Array()
var cont = 0
var speed_range = 60

@onready var timer: Timer = $Timer


func _ready() -> void:
	randomize()
	_cache_lanes()

	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _cache_lanes() -> void:
	lanes_y.clear()

	if lanes_path == NodePath():
		push_warning("Asigna 'lanes_path' al nodo 'Lanes' en el inspector.")
		return

	var lanes := get_node(lanes_path)
	for c in lanes.get_children():
		if c is Marker2D:
			lanes_y.append((c as Marker2D).global_position.y)

	lanes_y.sort()

	if lanes_y.is_empty():
		push_warning("No encontré Marker2D dentro de 'Lanes'.")
	else:
		print("Lanes Y:", lanes_y)


func _on_timer_timeout() -> void:
	if fish_scene == null or lanes_y.is_empty():
		return

	# 1) Elegir lane aleatorio
	var lane_index := randi() % lanes_y.size()
	var lane_y := lanes_y[lane_index]

	# 2) Tamaño de pantalla
	var vp_size: Vector2 = get_viewport().get_visible_rect().size

	# 3) De qué lado sale el pez
	var from_left := randf() < 0.5
	# Si quieres SIEMPRE a la derecha, descomenta la siguiente línea:
	from_left = true

	var start_x := -40.0 if from_left else vp_size.x + 40.0

	# 4) Crear pez
	var fish := fish_scene.instantiate() as Area2D
	fish.global_position = Vector2(start_x, lane_y)
	cont = cont + 1
	print(cont)

	# Velocidad aleatoria
	if cont % 5 == 0:
		speed_range = speed_range + 20
		fish.speed = speed_range
		print (fish.speed)
	else:
		fish.speed = speed_range
		print(fish.speed)
	
	#if "speed" in fish:
		#fish.speed = randf_range(speed_range.x, speed_range.y)

	# Informar desde qué lado se mueve
	if fish.has_method("set_move_from_left"):
		fish.set_move_from_left(from_left)

	add_child(fish)

	# Reiniciar timer
	timer.start()
