extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer


# Pre-carga tus canciones
var music_menu := preload("res://Sonido/Musica/mainmenusong.mp3")
var music_nivel := preload("res://Sonido/Musica/der otter.mp3")
var music_volume := 0.0


func _ready():
	add_child(player)
	# Detectar cambio de escena
	get_tree().tree_changed.connect(_on_scene_changed)
func _process(delta: float) -> void:
	if not player.playing:
		player.play()
func set_music_volume(value: float):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_scene_changed(data = null):

	var tree = get_tree()
	if not is_instance_valid(tree):
		return
	var scene = tree.current_scene
	if not is_instance_valid(scene):
		return
	var path := str(scene.scene_file_path)


	if "main_menu" in path.to_lower():
		_play_music(music_menu)

	elif "thegame" in path.to_lower():
		_play_music(music_nivel)
	elif "juegomultiplayer" in path.to_lower():
		_play_music(music_nivel)
	else:
		_play_music(music_menu)
func _play_music(stream: AudioStream):
	# Si ya está sonando esta música, no la cambies
	if player.stream == stream:
		return

	player.stream = stream
	player.play()
