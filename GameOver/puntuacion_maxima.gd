extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	if ScoreManager.score > ScoreManager.high_score:
		ScoreManager.high_score = ScoreManager.score
		ScoreManager.save_score() 
	$".".text = "Mejor puntaje-# " + str(ScoreManager.high_score)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
