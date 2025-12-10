extends Control

## MainMenu - Menú principal del juego
## Gestiona la navegación entre menú y juego

# Ruta de la escena del juego
const GAME_SCENE = "res://Mundo/thegame.tscn"


# Referencias a los botones
@onready var start_button = $VBoxContainer/Button
@onready var settings_button = $VBoxContainer/Button2
@onready var exit_button = $VBoxContainer/Button3
@onready var multiplayer_button = $VBoxContainer/Button4

func _ready():
	# Conectar señales de los botones
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	multiplayer_button.pressed.connect(_on_multyplayer_pressed)

func _on_start_pressed():
	"""Inicia el juego"""
	print("Iniciando juego...")
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Assets/Settings/Settings.tscn")

func _on_exit_pressed():
	print("Cerrando juego...")

	# Desactiva señales/timers que sigan llamando lógica
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	get_tree().quit()

func _on_multyplayer_pressed():
	"""Abre el  lobby multijugador"""
	get_tree().change_scene_to_file("res://Multijugador/Escenas/Multijugador.tscn")
