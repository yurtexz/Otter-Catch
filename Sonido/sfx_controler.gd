extends Node
@onready var playerAgua: AudioStreamPlayer = $Agua
@onready var playeRod: AudioStreamPlayer = $rod
@onready var caca: AudioStreamPlayer = $caca
@onready var recoger_pez: AudioStreamPlayer = $"Recoger pez"
@onready var recoger_dorado: AudioStreamPlayer = $"Recoger dorado"
@onready var cristal_roto: AudioStreamPlayer = $"cristal roto"
@onready var spawn_buzo: AudioStreamPlayer = $"spawn buzo"
@onready var perder: AudioStreamPlayer = $perder


var sfx_volume := 0.0
func _ready() -> void:
	pass


func set_sfx_volume(value: float):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
func splash():
	playerAgua.play()

func canas():
	playeRod.play()
func sonarCaca():
	caca.play()
func pezcar():
	recoger_pez.play()
func pezcardorado():
	recoger_dorado.play()
func sonarCristal():
	cristal_roto.play()
func sonarBuzo():
	spawn_buzo.play()
func perdiste():
	perder.play()
