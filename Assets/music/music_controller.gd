extends Node2D

@onready var musica: AudioStreamPlayer = $AudioStreamPlayer

func bgm_play():
	musica.play()
