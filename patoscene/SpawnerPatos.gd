extends Node
#ESTE era para que aparecieran al azar, pero no se si sea util a fin de cuentas, creo que complicaria
#el código y podrían haber errores
@export var pato_estatico_scene: PackedScene
@export var pato_perseguidor_scene: PackedScene
@export var pelotita_scene: PackedScene

var posiciones_posibles = [
	100,250,350
]

var pato_estatico: Node2D
var pato_perseguidor: Node2D

func _process(_delta):
	if not pato_estatico or not is_instance_valid(pato_estatico):
		pato_estatico = pato_estatico_scene.instantiate()
		add_child(pato_estatico)
		pato_estatico.lane_positions = posiciones_posibles
		pato_estatico.pelotita_scene = pelotita_scene
	
	if not pato_perseguidor or not is_instance_valid(pato_perseguidor):
		pato_perseguidor = pato_perseguidor_scene.instantiate()
		add_child(pato_perseguidor)
		pato_perseguidor.pelotita_scene = pelotita_scene
