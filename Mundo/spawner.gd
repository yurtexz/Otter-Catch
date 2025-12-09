extends Node2D
# Spawner de peces y cerveza en lanes aleatorios

@export var fish_scene: PackedScene
@export var beer_scene: PackedScene              # NUEVO: escena de cerveza
@export var spawn_interval := 1.3
@export var beer_chance: float = 0.2            # 50% prob. de que sea cerveza
@export_node_path("Node2D") var lanes_path: NodePath   # arrastra aquí el nodo Lanes

var lanes_y := PackedFloat32Array()
var cont := 0
var speed_range := 100
var GOLDEN_CHANCE := 0.20  # 20% dorado
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
	if lanes_y.is_empty():
		return

	# 1) Elegir lane aleatorio
	var lane_index := randi() % lanes_y.size()
	var lane_y := lanes_y[lane_index]

	# 2) Tamaño de pantalla
	var vp_size: Vector2 = get_viewport().get_visible_rect().size

	# 3) De qué lado sale (si quieres siempre por la izquierda, deja from_left = true)
	var from_left := randf() < 0.5
	from_left = true

	var start_x := -40.0 if from_left else vp_size.x + 40.0

	# 4) Elegir si spawnea pez o cerveza
	var use_beer := beer_scene != null and randf() < beer_chance
	var scene_to_spawn: PackedScene = beer_scene if use_beer else fish_scene

	if scene_to_spawn == null:
		return

	var obj := scene_to_spawn.instantiate() as Area2D
	obj.global_position = Vector2(start_x, lane_y)

	# Velocidad (pez con escalado, cerveza a velocidad base)
	if not use_beer:
		cont += 1
		if cont % 5 == 0:
			speed_range += 20
		if "speed" in obj:
			obj.speed = speed_range
	else:
		# Cerveza puede ir un poco más rápida o igual
		if "speed" in obj:
			obj.speed = speed_range + 30
	if not use_beer:
		if lane_index == 2:  # SOLO lane 3
			if randf() < GOLDEN_CHANCE:
				if obj.has_method("make_golden"):
					obj.make_golden()
	# Dirección según lado

	if obj.has_method("set_move_from_left"):
		obj.set_move_from_left(from_left)

	add_child(obj)

	timer.start()
