extends CharacterBody2D

@export var speed: float = 200
@export var pelotita_scene: PackedScene

var lane_positions = [100, 200, 300]
var target_x: float
var is_moving: bool = false
var is_waiting: bool = false

@onready var timer = $Timer
@onready var anim_sprite = $AnimatedSprite2D
@onready var drop_timer = $DropTimer

func _ready():
	randomize()
	anim_sprite.play("fly")
	
	timer.timeout.connect(_on_timer_timeout)
	drop_timer.timeout.connect(_on_drop_timer_timeout)
	
	target_x = choose(lane_positions)
	is_moving = true
	position.y = 200

func _process(delta):
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
		start_wait()

func start_wait():
	is_waiting = true
	
	var random_time = randf_range(5.0, 9.0)
	drop_timer.wait_time = random_time
	timer.wait_time = 10.0
	
	drop_timer.start()
	timer.start()

func _on_drop_timer_timeout():
	# Lanza la pelotita sin afectar al movimiento, esto podria ser editado (?)
	if pelotita_scene:
		var pelotita = pelotita_scene.instantiate()
		pelotita.position = position + Vector2(0, 50)
		get_parent().add_child(pelotita)

func _on_timer_timeout():
	#limite 10 segundos, podemos ajustarlo para la dificultad
	is_waiting = false
	var new_x = choose(lane_positions)
	while abs(new_x - target_x) < 5:
		new_x = choose(lane_positions)
	target_x = new_x
	is_moving = true

func choose(array):
	array.shuffle()
	return array.front()
