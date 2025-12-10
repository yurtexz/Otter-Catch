extends CanvasLayer

func _ready():
	return


func _on_menu_pressed():
	# cargar la escena de menú
	get_tree().paused = false
	Network.apagar()
	ScoreManager.score = 0
	get_tree().change_scene_to_file("res://Multijugador/Escenas/Multijugador.tscn")
