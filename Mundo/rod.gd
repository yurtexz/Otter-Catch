extends Node2D
# Rod.gd — Cuerda + Carnada (Godot 4.x)

signal movement_finished(level: int)

@export var level_lengths := PackedFloat32Array([0.0, 120.0, 190.0,270.0]) # largos por nivel (px)
@export var move_time := 0.25


@onready var origin: Marker2D = $Origin
@onready var line: Line2D = $Line
@onready var bait: Node2D = $Bait
var fish_hooked: Area2D = null


var level := 0            # 0 = retraída, 1 = media, 2 = profunda
var rope_len := 0.0
var tween: Tween

func _ready() -> void:
	# Asegurar que la cuerda se vea
	line.width = max(2.0, line.width)
	if line.default_color == Color(1,1,1,1): # si está blanco puro y tu fondo es claro, ponlo oscuro
		line.default_color = Color8(40, 25, 10)
	line.z_index = max(8, line.z_index)
	bait.z_index = max(10, bait.z_index)

	rope_len = level_lengths[0]
	_redraw()

func _process(_dt: float) -> void:
	_redraw()

func _redraw() -> void:
	var start := origin.global_position
	var end := start + Vector2(0, rope_len)

	line.clear_points()
	line.add_point(to_local(start))
	line.add_point(to_local(end))

	bait.global_position = end

func lower_one_level() -> void:
	if level < level_lengths.size() - 1:
		_set_level(level + 1)

func raise_one_level() -> void:
	if level > 0:
		_set_level(level - 1)

func _set_level(new_level: int) -> void:
	level = clamp(new_level, 0, level_lengths.size() - 1)
	var target := level_lengths[level]
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rope_len", target, move_time)
	tween.finished.connect(func():
		emit_signal("movement_finished", level)
	)

func is_moving() -> bool:
	return tween != null and tween.is_running()

func is_retracted() -> bool:
	return level == 0 and not is_moving()
