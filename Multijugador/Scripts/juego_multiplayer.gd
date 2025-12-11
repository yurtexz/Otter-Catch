extends Node2D
@onready var buzo: Area2D = $Buzo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Network.mensaje_recibido.connect(_on_recive)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_recive(msg: String):

	var data = JSON.parse_string(msg)
	var evento : String = data.get("event", "")
	print(evento)
	if evento == "close-match":
		print("🏆 [MATCH] ¡Oponente se desconecto! Victoria")
		var payloadwin := {"VICTORY":"game-ended"}
		Network.send_game_data(payloadwin)
		SfxControler.clap()
		var game_over_screen = load("res://Multijugador/Escenas/GameoverMult.tscn").instantiate()
		var label = game_over_screen.get_node("CanvasLayer/Label")
		label.text = "VICTORIA"
		get_tree().current_scene.add_child(game_over_screen)
		get_tree().paused = true
	if evento == "receive-game-data":
		var data_interna = data.get("data", {})
		var payload = data_interna.get("payload", {})
		var tipo = payload.get("type", "")
		if tipo == "attack":
			var spawner = $Mundo/SpawnBuzo
			spawner.spawn_buzo()
		if tipo == "defeat":
			print("🏆 [MATCH] ¡Oponente se rindió! Victoria")
			var payloadwin := {"VICTORY":"game-ended"}
			SfxControler.clap()
			Network.send_game_data(payloadwin)
			var game_over_screen = load("res://Multijugador/Escenas/GameoverMult.tscn").instantiate()
			var label = game_over_screen.get_node("CanvasLayer/Label")
			label.text = "VICTORIA"
			get_tree().current_scene.add_child(game_over_screen)
			get_tree().paused = true
			


func _on_salir_pressed() -> void:
	# (1) Declarar derrota ANTES de salir
	Network.send_game_data({
		"type": "defeat"
	})

	# Esperar pequeño delay para asegurar que el server lo recibe
	await get_tree().create_timer(0.1).timeout

	# (2) Enviar quit-match
	print("📤 Enviando quit-match…")
	Network.ws.send_text(JSON.stringify({
		"event": "quit-match"
	}))

	# (3) Limpiar datos locales
	var manager = get_node_or_null("/root/Multiplayer")
	if manager:
		manager.match_id = ""
		manager.match_status = "WAITING_PLAYERS"
		manager.jugadores_del_match.clear()

	# (4) Cerrar WebSocket
	print("🔌 Cerrando WebSocket…")
	Network.apagar()

	await get_tree().create_timer(0.2).timeout

	# (5) Volver al menú
	print("🏠 Menú principal")
	get_tree().change_scene_to_file("res://main_menu.tscn")
