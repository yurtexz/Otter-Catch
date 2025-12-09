extends Node2D
@onready var buzo: Area2D = $Buzo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Network.mensaje_recibido.connect(_on_recive)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_recive(msg: String):
	print("lol")
	
	var data = JSON.parse_string(msg)
	var evento : String = data.get("event", "")
	if evento == "receive-game-data":
		var data_interna = data.get("data", {})
		var payload = data_interna.get("payload", {})
		var tipo = payload.get("type", "")
		if tipo == "attack":
			print("EL PEPEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
			var spawner = $Mundo/SpawnBuzo
			spawner.spawn_buzo()
		
