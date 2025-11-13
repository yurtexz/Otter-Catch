extends Node2D
# Spawner TEST — solo para comprobar que el pez aparece

@export var fish_scene: PackedScene
@export var spawn_interval := 1.5
@export_node_path("Node2D") var lanes_path: NodePath

@onready var timer: Timer = $Timer


func _ready() -> void:
	randomize()
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	print("Spawner TEST _ready, fish_scene =", fish_scene)
	timer.start()


func _on_timer_timeout() -> void:
	if fish_scene == null:
		print("Spawner TEST: fish_scene es null.")
		return

	var vp_size: Vector2 = get_viewport().get_visible_rect().size

	# Pez en el centro de la pantalla
	var pos := Vector2(vp_size.x * 0.5, vp_size.y * 0.5)
	print("Spawner TEST: creando pez en ", pos)

	var fish := fish_scene.instantiate() as Area2D
	fish.global_position = pos

	(fish as Node2D).z_index = 10

	add_child(fish)

	timer.start()
