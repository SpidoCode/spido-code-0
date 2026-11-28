extends Control

const ESCENA_JUEGO := "res://escenas/principal.tscn"
const ESCENA_AUTH := "res://escenas/auth.tscn"

@onready var dialogo: AcceptDialog = $Dialogo
@onready var boton_cuenta: Button = $PanelPerfil/ContenedorPerfil/ButtonLogin
@onready var identidad: Label = $PanelPerfil/ContenedorPerfil/Identidad

func _ready() -> void:
	preload("res://scripts/primary_button.gd").apply(dialogo.get_ok_button())
	AuthService.session_changed.connect(_actualizar_perfil)
	AuthService.busy_changed.connect(_actualizar_perfil)
	_actualizar_perfil()
	$PanelMenu/ContenedorPrincipal/BotonJugar.grab_focus()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

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
	if AuthService.is_busy():
		return
	if AuthService.get_current_user().is_empty():
		get_tree().change_scene_to_file(ESCENA_AUTH)
		return
	var error := await AuthService.sign_out()
	if not error.is_empty() and is_inside_tree():
		dialogo.title = "Cerrar sesión"
		dialogo.dialog_text = error
		dialogo.popup_centered()

func _actualizar_perfil() -> void:
	var usuario := AuthService.get_current_user()
	identidad.visible = not usuario.is_empty()
	identidad.text = usuario.get("email", "")
	identidad.tooltip_text = identidad.text
	boton_cuenta.text = "Iniciar sesión" if usuario.is_empty() else "Cerrar sesión"
	boton_cuenta.disabled = AuthService.is_busy()

func _on_boton_configuracion_pressed() -> void:
	dialogo.title = "Configuración"
	dialogo.dialog_text = "Las opciones de configuración estarán disponibles próximamente."
	dialogo.popup_centered()

func _on_boton_salir_pressed() -> void:
	get_tree().quit()
