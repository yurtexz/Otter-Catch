extends CharacterBody2D

@onready var rope: Line2D = $Cuerda
@onready var anzuelo: Area2D = $Anzuelo

var rope_start = Vector2(160, -37)
var rope_end = Vector2(160, 50)
var lane_positions = [160, 650, 1000, 1530]
var current_lane = 0
var touch_startx = 0.0
var touch_endx = 0.0
var touch_starty = 0.0
var touch_endy = 0.0

func _ready():
	position.x = lane_positions[current_lane]
	position.y = 275
	update_rope()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		touch_startx = event.position.x
		touch_starty = event.position.y

	if event is InputEventMouseButton and not event.pressed:
		touch_endx = event.position.x
		touch_endy = event.position.y

		var deltax = touch_endx - touch_startx
		var deltay = touch_endy - touch_starty

		if deltax > 100:
			move_lane(1)
		elif deltax < -100:
			move_lane(-1)

		if deltay > 100:
			extend_rope(100)
		elif deltay < -100:
			extend_rope(-100)

func move_lane(direction: int):
	current_lane = clamp(current_lane + direction, 0, lane_positions.size() - 1)
	var target_x = lane_positions[current_lane]
	var tween = create_tween()
	tween.tween_property(self, "position:x", target_x, 0.2)

func extend_rope(amount: float):
	rope_end.y = clamp(rope_end.y + amount, 50, 600)
	update_rope()

func update_rope():
	rope.clear_points()
	rope.add_point(rope_start)
	rope.add_point(rope_end)

func _process(_delta):
	# Hace que la carnada siga la punta de la cuerda
	if rope.get_point_count() > 1:
		var end_point = rope.get_point_position(rope.get_point_count() - 1)
		anzuelo.position = rope.position + end_point
