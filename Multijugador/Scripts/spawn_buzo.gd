
# Called when the node enters the scene tree for the first time.
extends Node2D

# Ruta a la escena del buzo
var BUZO_SCENE := preload("res://Multijugador/Escenas/Buzo.tscn")

func spawn_buzo():
	var buzo = BUZO_SCENE.instantiate()
	add_child(buzo)

	# OPCIONAL: posición inicial del buzo
	buzo.position = Vector2(0, 1150)

	return buzo
