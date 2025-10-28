extends CharacterBody2D

@onready var rope: Line2D = $Cuerda
var rope_start = Vector2(160,-37)
var rope_end = Vector2(160,50)
var lane_positions = [160, 650, 1000, 1530]
var current_lane = 0
var touch_startx = Vector2.ZERO
var touch_endx = Vector2.ZERO
var touch_starty = Vector2.ZERO
var touch_endy = Vector2.ZERO

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
	current_lane = clamp(current_lane + direction,0,lane_positions.size() -1)
	var target_x =lane_positions[current_lane]
	
	var tween = create_tween()
	tween.tween_property(self,"position:x",target_x,0.2)
func extend_rope(amount: float):
	rope_end.y = clamp(rope_end.y+ amount,50,600)
	update_rope()
	
func update_rope() -> void:
	rope.clear_points()
	rope.add_point(rope_start)
	rope.add_point(rope_end)
	var target_y = rope_end
	var tweenRope = create_tween()
	tweenRope.tween_property(rope,"position:y",target_y,0.2)
