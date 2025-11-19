extends CharacterBody2D
# otter.gd — Godot 4.x
# Movimiento entre hoyos usando "Holes" y altura exacta con "StandY"
# + Integración con caña (Rod) y verificación robusta para no bloquear el movimiento

# =======================
# CONFIGURACIÓN
# =======================
@export var move_time := 0.18
@export var hole_y := 160.0
@export_node_path("Node2D") var holes_path : NodePath
@export_node_path("Marker2D") var stand_y_path : NodePath

# Umbrales del gesto
const SWIPE_TIME_MAX := 0.60
const SWIPE_RATIO_MAX := 0.8
var SWIPE_MIN_X := 40.0
var SWIPE_MIN_Y := 40.0

# Estados (fallback si no usamos Rod.is_retracted())
enum RodState { RETRACTED, MOVING, AT_DEPTH }
var rod_state := RodState.RETRACTED
var vida = 3
# Interno
var hole_x := PackedFloat32Array()
var current_index := 0
var is_moving := false
var tween: Tween

# Swipe
var touch_start_pos := Vector2.ZERO
var touch_start_time := 0.0
var dragging := false

# Nodos
@onready var sprite: Sprite2D = $Sprite2D
@onready var rod: Node = $Rod   # <-- referencia a la caña

func _ready() -> void:
	# Mirar a la izquierda siempre
	#sprite.flip_h = true

	# Sensibilidad swipe según pantalla
	var vp := get_viewport_rect().size
	SWIPE_MIN_X = max(30.0, vp.x * 0.12)
	SWIPE_MIN_Y = max(30.0, vp.y * 0.10)

	_cache_holes()

	# Altura de pies (StandY si existe)
	if stand_y_path != NodePath():
		var stand := get_node(stand_y_path) as Marker2D
		if stand:
			hole_y = stand.global_position.y
	else:
		hole_y = global_position.y

	# Posición inicial (X del primer hoyo, Y ya definida)
	if hole_x.size() > 0:
		current_index = clamp(current_index, 0, hole_x.size() - 1)
		global_position = Vector2(hole_x[current_index], hole_y)

	# Conectar señal de la caña si existe
	if rod and rod.has_signal("movement_finished"):
		rod.movement_finished.connect(_on_rod_movement_finished)

func _cache_holes() -> void:
	hole_x.clear()
	if holes_path == NodePath():
		push_warning("Asigna 'holes_path' al nodo 'Holes' en el inspector.")
		return

	var holes := get_node(holes_path)
	for child in holes.get_children():
		if child is Marker2D:
			hole_x.append((child as Marker2D).global_position.x)
	hole_x.sort()
	if hole_x.is_empty():
		push_warning("No encontré Marker2D dentro de 'Holes'.")
	else:
		print(">>> hole_x cargado: ", hole_x)  # DEBUG

func _unhandled_input(event: InputEvent) -> void:
	# --- TOUCH (móvil) ---
	if event is InputEventScreenTouch:
		var t := event as InputEventScreenTouch
		if t.pressed:
			dragging = true
			touch_start_pos = t.position
			touch_start_time = Time.get_ticks_msec() / 1000.0
		else:
			if dragging:
				_evaluate_swipe(t.position)
			dragging = false
		return

	if event is InputEventScreenDrag:
		return

	# --- FALLBACK MOUSE (editor/PC) ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var m := event as InputEventMouseButton
		if m.pressed:
			dragging = true
			touch_start_pos = m.position
			touch_start_time = Time.get_ticks_msec() / 1000.0
		else:
			if dragging:
				_evaluate_swipe(m.position)
			dragging = false


func _evaluate_swipe(end_pos: Vector2) -> void:
	var dt := (Time.get_ticks_msec() / 1000.0) - touch_start_time
	var delta := end_pos - touch_start_pos
	if dt > SWIPE_TIME_MAX:
		return

	# Horizontal → moverse entre hoyos
	if abs(delta.x) >= SWIPE_MIN_X and abs(delta.y) <= abs(delta.x) * SWIPE_RATIO_MAX:
		_try_move_to_hole(current_index + (1 if delta.x > 0 else -1))
		return

	# Vertical → caña
	if abs(delta.y) >= SWIPE_MIN_Y and abs(delta.x) <= abs(delta.y) * SWIPE_RATIO_MAX:
		if delta.y > 0:
			_on_swipe_down()
		else:
			_on_swipe_up()

# ---------- Movimiento entre hoyos ----------
func _can_move_horizontally() -> bool:
	# Si el Rod expone is_retracted(), usamos ese estado real
	if rod and rod.has_method("is_retracted"):
		return rod.is_retracted()
	# Fallback al estado local
	return rod_state == RodState.RETRACTED

func _try_move_to_hole(next_idx: int) -> void:
	if not _can_move_horizontally():
		return
	if is_moving or hole_x.is_empty():
		return

	# si se intenta ir más allá de los extremos, no hacemos nada
	if next_idx < 0 or next_idx > hole_x.size() - 1:
		print(">>> intento salir de rango, next_idx=", next_idx)
		return

	current_index = next_idx

	var offset_x := -20.0  # izquierda del hoyo
	var base_x := hole_x[current_index]
	var target_x := base_x + offset_x

	print(">>> mover a índice ", current_index, 
		" base_x=", base_x, 
		" offset_x=", offset_x, 
		" target_x=", target_x)

	var target := Vector2(target_x, hole_y)
	_tween_to(target)

func _tween_to(target_pos: Vector2) -> void:
	is_moving = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_pos, move_time)
	tween.finished.connect(func ():
		is_moving = false
	)

# ---------- Caña ----------
func _on_swipe_down() -> void:
	if rod and rod.has_method("is_moving") and not rod.is_moving():
		if rod.has_method("lower_one_level"):
			rod.lower_one_level()
			rod_state = RodState.MOVING

func _on_swipe_up() -> void:
	if rod and rod.has_method("is_moving") and not rod.is_moving():
		if rod.has_method("raise_one_level"):
			rod.raise_one_level()
			rod_state = RodState.MOVING

func _on_rod_movement_finished(level: int) -> void:
	rod_state = RodState.RETRACTED if level == 0 else RodState.AT_DEPTH

# Compatibilidad (por si los llamas desde otro lado)
func _on_rod_at_depth() -> void:
	rod_state = RodState.AT_DEPTH

func _on_rod_retracted() -> void:
	rod_state = RodState.RETRACTED


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.name == "Pelotita"):
		vida -= 1
		if(vida <= 0):
			game_over()
func game_over():
	# Pausar todo el juego
	var game_over_screen = load("res://GameOver/Gameover.tscn").instantiate()
	get_tree().current_scene.add_child(game_over_screen)
	get_tree().paused = true
	
