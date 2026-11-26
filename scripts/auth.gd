extends Control

const ESCENA_MENU := "res://escenas/menu_inicio.tscn"
const URL_REGISTRO := "https://www.spidocode.com/registro"
const URL_RECUPERACION := "https://www.spidocode.com/recuperar-contrasena"

@onready var email_input: LineEdit = $Panel/Contenedor/Email
@onready var password_input: LineEdit = $Panel/Contenedor/Password
@onready var mensaje: Label = $Panel/Contenedor/Mensaje
@onready var iniciar_sesion: Button = $Panel/Contenedor/IniciarSesion
@onready var volver: Button = $Panel/Contenedor/Volver
@onready var registrarse: Button = $Panel/Contenedor/Registrarse
@onready var recuperar: Button = $Panel/Contenedor/RecuperarPassword

func _ready() -> void:
	email_input.grab_focus()
	var panel := $Panel
	panel.modulate.a = 0.0
	panel.position.y += 12.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.25)
	tween.tween_property(panel, "position:y", panel.position.y - 12.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_iniciar_sesion_pressed() -> void:
	if iniciar_sesion.disabled or AuthService.is_busy() or not _validar_campos():
		return
	_set_loading(true)
	mensaje.text = "Iniciando sesión…"
	var password := password_input.text
	password_input.clear()
	var error := await AuthService.sign_in(email_input.text.strip_edges(), password)
	_set_loading(false)
	mensaje.text = error
	if error.is_empty():
		_on_volver_pressed()

func _on_registrarse_pressed() -> void:
	_abrir_flujo_web(URL_REGISTRO)

func _on_recuperar_password_pressed() -> void:
	_abrir_flujo_web(URL_RECUPERACION)

func _abrir_flujo_web(url: String) -> void:
	if OS.shell_open(url) != OK:
		mensaje.text = "No se pudo abrir el navegador. Visita " + url

func _set_loading(loading: bool) -> void:
	iniciar_sesion.disabled = loading
	volver.disabled = loading
	registrarse.disabled = loading
	recuperar.disabled = loading
	email_input.editable = not loading
	password_input.editable = not loading

func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file(ESCENA_MENU)

func _validar_campos() -> bool:
	var email := email_input.text.strip_edges()
	if email.is_empty():
		mensaje.text = "Escribe tu correo electrónico."
		return false
	var separator := email.find("@")
	if separator <= 0 or separator == email.length() - 1 or email.count("@") != 1 or " " in email:
		mensaje.text = "Escribe un correo electrónico válido."
		return false
	if password_input.text.is_empty():
		mensaje.text = "Escribe tu contraseña."
		return false
	return true
