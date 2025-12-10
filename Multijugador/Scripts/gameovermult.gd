extends CanvasLayer

func _ready():
	Network.mensaje_recibido.connect(_on_recive)
	return


func _on_menu_pressed():
	# cargar la escena de menú
	get_tree().paused = false
	Network.apagar()
	ScoreManager.score = 0
	get_tree().change_scene_to_file("res://Multijugador/Escenas/Multijugador.tscn")

func _on_recive(msg: String):
	var data = JSON.parse_string(msg)
	var evento : String = data.get("event", "")
	if evento == "game-ended": print("perdiiiiii :(")
