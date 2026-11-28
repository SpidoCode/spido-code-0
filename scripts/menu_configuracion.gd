extends CanvasLayer

const Picker = preload("res://scripts/display_mode_picker.gd")
const PrimaryButton = preload("res://scripts/primary_button.gd")
const ThemeGlobal = preload("res://assets/tema_global.tres")


func _ready() -> void:
	layer = 100
	var fondo := ColorRect.new()
	fondo.color = Color(0, 0, 0, 0.7)
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(fondo)

	var centro := CenterContainer.new()
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(centro)

	var panel := PanelContainer.new()
	panel.theme = ThemeGlobal
	panel.custom_minimum_size = Vector2(500, 0)
	centro.add_child(panel)

	var contenido := VBoxContainer.new()
	contenido.add_theme_constant_override("separation", 16)
	panel.add_child(contenido)

	var titulo := Label.new()
	titulo.text = "CONFIGURACIÓN"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 26)
	contenido.add_child(titulo)

	var pantalla := Picker.new()
	contenido.add_child(pantalla)

	var cerrar := PrimaryButton.new()
	cerrar.text = "CERRAR"
	cerrar.pressed.connect(queue_free)
	contenido.add_child(cerrar)
	pantalla.selector.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
