extends Node
@onready var musica: HSlider = $Panel/Musica
@onready var sonido: HSlider = $Panel/Sonido




func _ready() -> void:
	musica.value = MusicController.music_volume
	sonido.value = SfxControler.sfx_volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_musica_value_changed(value: float) -> void:
	MusicController.set_music_volume(value)


func _on_sonido_value_changed(value: float) -> void:
	SfxControler.set_sfx_volume(value)
