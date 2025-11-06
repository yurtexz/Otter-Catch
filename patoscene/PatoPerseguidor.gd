extends CharacterBody2D

@export var speed: float = 750
@onready var player: CharacterBody2D = $"../Nutria"  
@export var pelotita_scene: PackedScene               

var target_x: float
var lane_positions = [160, 650, 1000, 1530]
var is_moving: bool = false
var is_waiting: bool = false

@onready var anim_sprite = $AnimatedSprite2D
@onready var drop_timer = $DropTimer  

func _ready():
	randomize()
	anim_sprite.play("fly")
	target_x = lane_positions.pick_random()
	is_moving = true

func _process(delta):
	if player == null:
		return

	var player_x = player.position.x
	var nearest_lane = get_nearest_lane(player_x)

	# Si el jugador cambió de carril y el pato no está esperando, moverse enseguida
	# Pero podriamos hacer que siempre lo siga, pero eso sería demasiado complicado creo yo
	if not is_waiting and abs(nearest_lane - target_x) > 5:
		target_x = nearest_lane
		is_moving = true

	if is_moving:
		move_towards_lane(delta)

func move_towards_lane(delta):
	var direction = sign(target_x - position.x)
	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

	anim_sprite.flip_h = velocity.x < 0

	if abs(target_x - position.x) < 10:
		position.x = target_x
		velocity.x = 0
		is_moving = false
		start_attack_wait()

func start_attack_wait():
	is_waiting = true
	var random_time = randf_range(5.0, 9.0)
	drop_timer.wait_time = random_time
	drop_timer.start()

func _on_drop_timer_timeout() -> void:
	if pelotita_scene:
		var pelotita = pelotita_scene.instantiate()
		pelotita.position = position + Vector2(0, 50) 
		get_parent().add_child(pelotita)

	# Después del ataque, puede volver a seguir al jugador, pero podria cambiarse para que siempre siga
	is_waiting = false

func get_nearest_lane(x_pos: float) -> float:
	var nearest = lane_positions[0]
	var min_diff = abs(nearest - x_pos)
	for lane in lane_positions:
		var diff = abs(lane - x_pos)
		if diff < min_diff:
			min_diff = diff
			nearest = lane
	return nearest
