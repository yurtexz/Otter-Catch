extends CanvasLayer

@onready var panel := $Panel

func _ready():
	$Panel/Continuar.pressed.connect(_on_reanudar_pressed)
	$Panel/MenuPrin.pressed.connect(_on_menu_prin_pressed)



func _on_reanudar_pressed():
	get_tree().paused = false
	queue_free()  # cerrar menú


func _on_menu_prin_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
