extends Node2D



func _ready() -> void:
	$AnimationPlayer.play("fade in")
	await get_tree().create_timer(4.0).timeout
	
	$AnimationPlayer.play("fade out")
	await get_tree().create_timer(3.0).timeout

	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
