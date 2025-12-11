extends Node
var music_volume := 0
var sfx_volume := 0
var score: int = 0
var high_score: int = 0

func _ready():
	load_score()

func save_score():
	var cfg := ConfigFile.new()

	if cfg.load("user://save_game.cfg") != OK:
		pass 
		
	cfg.set_value("game", "high_score", high_score)
	cfg.save("user://save_game.cfg")
	
func load_score():
	var cfg := ConfigFile.new()
	if cfg.load("user://save_game.cfg") == OK:
		high_score = cfg.get_value("game", "high_score", 0)
