extends Control
@onready var control: Control = $".."
@onready var line_edit = $VBoxContainer/LineEdit
@onready var container: VBoxContainer = $VBoxContainer
@onready var label: Label = $VBoxContainer/Label
signal nombre_ingresado(nombre)
var original_position : Vector2
@onready var panel_2: Panel = $"."

func _ready():
	await get_tree().process_frame
	original_position = container.position

	line_edit.focus_entered.connect(_on_focus_entered)
	line_edit.focus_exited.connect(_on_focus_exited)

func _on_focus_entered():
	# Mover el contenedor al centro de la pantalla
	container.position = Vector2(0,-100)
	print("Se movio a: "+str(container.position))

func _on_focus_exited():
	# Volver a su posición original
	container.position = original_position


func _on_button_pressed() -> void:
	if(line_edit.text.strip_edges()!= ""):
		var nombre = line_edit.text.strip_edges()
		for i in nombre:
			if(i == " "):
				label.text = "Tu nombre no puede tener espacios"
				return
		emit_signal("nombre_ingresado", nombre)
		control._conectar_servidor()
		panel_2.visible = false
	else:
		label.text = "No puedes tener un nombre vacio"
		
		
