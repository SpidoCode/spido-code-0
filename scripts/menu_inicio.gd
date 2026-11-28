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
	var menu := preload("res://scripts/menu_configuracion.gd").new()
	$PanelMenu.hide()
	$PanelPerfil.hide()
	add_child(menu)
	menu.tree_exited.connect(func():
		if not is_inside_tree():
			return
		$PanelMenu.show()
		$PanelPerfil.show()
		$PanelMenu/ContenedorPrincipal/BotonConfiguracion.grab_focus()
	)

func _on_boton_salir_pressed() -> void:
	get_tree().quit()
