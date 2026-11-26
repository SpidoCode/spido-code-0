extends Control

const ESCENA_JUEGO := "res://escenas/principal.tscn"
const ESCENA_AUTH := "res://escenas/auth.tscn"

@onready var dialogo: AcceptDialog = $Dialogo

func _ready() -> void:
	$PanelMenu/ContenedorPrincipal/BotonJugar.grab_focus()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11 or (event.keycode == KEY_ENTER and event.alt_pressed):
			var cur_mode = DisplayServer.window_get_mode()
			if cur_mode == DisplayServer.WINDOW_MODE_MAXIMIZED or cur_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			get_viewport().set_input_as_handled()

func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file(ESCENA_JUEGO)

func _on_boton_login_pressed() -> void:
	get_tree().change_scene_to_file(ESCENA_AUTH)

func _on_boton_configuracion_pressed() -> void:
	dialogo.title = "Configuración"
	dialogo.dialog_text = "Las opciones de configuración estarán disponibles próximamente."
	dialogo.popup_centered()

func _on_boton_salir_pressed() -> void:
	get_tree().quit()
