extends CanvasLayer

func _ready():
	return

func _on_retry_pressed():
	# recargar la escena actual
	get_tree().paused = false
	ScoreManager.score = 0
	get_tree().change_scene_to_file("res://Mundo/thegame.tscn")


func _on_menu_pressed():
	# cargar la escena de menú
	get_tree().paused = false
	ScoreManager.score = 0
	get_tree().change_scene_to_file("res://main_menu.tscn")
