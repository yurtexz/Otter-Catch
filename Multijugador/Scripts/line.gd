extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_line_collision()

func _update_line_collision():
	var p0 = get_point_position(0)
	var p1 = get_point_position(1)

	var world_p0 = to_global(p0)
	var world_p1 = to_global(p1)

	var area := $"../AreaCuerda"
	var shape := area.get_node("CollisionShape2D").shape as RectangleShape2D

	var length = p0.distance_to(p1)

	shape.size = Vector2(length, 8)

	# mover el Area2D al centro, pero en coordenadas globales
	area.global_position = (world_p0 + world_p1) / 2

	# rotarlo en global
	area.global_rotation = world_p0.angle_to_point(world_p1)


func _on_AreaCuerda(area: Area2D) -> void:
		var rod = get_parent()
		rod._set_level(0)
		if(rod.fish_hooked):
			rod.fish_hooked.queue_free()
		var jugador = rod.get_parent()
		jugador.take_hit()
		SfxControler.cortar()
		
