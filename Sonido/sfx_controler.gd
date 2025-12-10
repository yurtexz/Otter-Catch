extends Node
@onready var playerAgua: AudioStreamPlayer = $Agua
@onready var playeRod: AudioStreamPlayer = $rod
@onready var caca: AudioStreamPlayer = $caca
@onready var recoger_pez: AudioStreamPlayer = $"Recoger pez"
@onready var recoger_dorado: AudioStreamPlayer = $"Recoger dorado"
@onready var cristal_roto: AudioStreamPlayer = $"cristal roto"
@onready var spawn_buzo: AudioStreamPlayer = $"spawn buzo"
@onready var perder: AudioStreamPlayer = $perder
@onready var corte: AudioStreamPlayer = $corte
@onready var win: AudioStreamPlayer = $win


var sfx_volume := 0.0

func _ready() -> void:
	load_settings()

func save_settings():
	var cfg := ConfigFile.new()
	
	if cfg.load("user://save_game.cfg") != OK:
		pass 
		
	cfg.set_value("audio", "sfx_volume", sfx_volume)
	cfg.save("user://save_game.cfg")

func set_sfx_volume(value: float):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	save_settings()
func load_settings():
	var config := ConfigFile.new()
	var err := config.load("user://save_game.cfg")

	if err != OK:
		print("AudioManager: No settings file found, using defaults.")
		
		sfx_volume = sfx_volume
		return
# Usamos los valores por defecto del script (50/75) si no se encuentran en el archivo.
	sfx_volume = config.get_value("audio", "sfx_volume", sfx_volume)
	set_sfx_volume(sfx_volume)

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
func cortar():
	corte.play()
func clap():
	win.play()
