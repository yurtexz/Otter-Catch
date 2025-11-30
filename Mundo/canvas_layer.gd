extends CanvasLayer  # o lo que tengas

const PauseMenuScene := preload("res://Assets/Menu de pausa/menu_pausa.tscn")

var pause_menu_instance: CanvasLayer = null

func _on_BotonPausa_pressed():
	if pause_menu_instance:
		return # ya está abierto, no creamos otro

	# Instanciar la escena del menú de pausa
	pause_menu_instance = PauseMenuScene.instantiate()
	# Agregarla a la escena actual
	get_tree().current_scene.add_child(pause_menu_instance)
	# Pausar el juego
	get_tree().paused = true
