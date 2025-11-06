extends Control

## MainMenu - Menú principal del juego
## Gestiona la navegación entre menú y juego

# Ruta de la escena del juego
const GAME_SCENE = "res://Mundo/node_2d.tscn"

# Referencias a los botones

@onready var main_buttons: VBoxContainer = $MainButtons

@onready var options: Panel = $Options

@onready var start_button = $MainButtons/Button
@onready var settings_button = $MainButtons/Button2
@onready var exit_button = $MainButtons/Button3

func _ready():
	# Conectar señales de los botones
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	# Esconder panel de settings 
	main_buttons.visible = true
	options.visible = false

func _on_start_pressed():
	"""Inicia el juego"""
	print("Iniciando juego...")
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_settings_pressed():
	"""Abre configuración (por implementar)"""
	print("Abriendo settings...")
	main_buttons.visible = false
	options.visible = true
	
	# TODO: Abrir pantalla de configuración

func _on_exit_pressed():
	"""Cierra el juego"""
	print("Cerrando juego...")
	get_tree().quit()


func _on_back_settings_pressed() -> void:
	_ready()
