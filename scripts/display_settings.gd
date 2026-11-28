extends Node

const CONFIG_PATH := "user://display_settings.cfg"
const DEFAULT_MODE := DisplayServer.WINDOW_MODE_MAXIMIZED

var _ultimo_modo_ventana: DisplayServer.WindowMode = DEFAULT_MODE


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var config := ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		var ultimo: Variant = config.get_value("pantalla", "ultimo_modo_ventana", DEFAULT_MODE)
		if _es_modo_ventana(ultimo):
			_ultimo_modo_ventana = ultimo
		var modo: Variant = config.get_value("pantalla", "modo", DEFAULT_MODE)
		if _es_modo_ventana(modo) or (modo is int and modo == DisplayServer.WINDOW_MODE_FULLSCREEN):
			if _es_modo_ventana(modo):
				_ultimo_modo_ventana = modo
			DisplayServer.window_set_mode(modo)
			return
	DisplayServer.window_set_mode(DEFAULT_MODE)


func modo_activo() -> DisplayServer.WindowMode:
	return DisplayServer.window_get_mode()


func aplicar(modo: DisplayServer.WindowMode) -> Error:
	var anterior := modo_activo()
	if _es_modo_ventana(anterior):
		_ultimo_modo_ventana = anterior
	if _es_modo_ventana(modo):
		_ultimo_modo_ventana = modo
	elif modo != DisplayServer.WINDOW_MODE_FULLSCREEN:
		return ERR_INVALID_PARAMETER

	DisplayServer.window_set_mode(modo)
	var config := ConfigFile.new()
	config.set_value("pantalla", "modo", modo)
	config.set_value("pantalla", "ultimo_modo_ventana", _ultimo_modo_ventana)
	return config.save(CONFIG_PATH)


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return
	var atajo: bool = event.keycode == KEY_F11 or (
		event.keycode == KEY_ENTER and event.alt_pressed and not event.ctrl_pressed
		and not event.shift_pressed and not event.meta_pressed
	)
	if not atajo:
		return

	get_viewport().set_input_as_handled()
	if event.echo:
		return
	var destino: DisplayServer.WindowMode = _ultimo_modo_ventana if modo_activo() == DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN
	if aplicar(destino) != OK:
		push_warning("No se pudo guardar la preferencia de pantalla.")


func _es_modo_ventana(modo: Variant) -> bool:
	return modo is int and modo in [DisplayServer.WINDOW_MODE_WINDOWED, DisplayServer.WINDOW_MODE_MAXIMIZED]
