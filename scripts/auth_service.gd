extends Node

signal session_changed
signal busy_changed

const AUTH_URL := "https://ulivinilxszdyazignbi.supabase.co/auth/v1"
const PUBLIC_KEY := "sb_publishable_Nk8m4AZRU1ffH6gJCF45pw_KI-H6-LK"
const CONNECTION_ERROR := "No se pudo conectar. Revisa tu conexión e inténtalo de nuevo."

var _access_token := ""
var _refresh_token := ""
var _user: Dictionary = {}
var _busy := false
var _expires_at := 0.0
var _refresh_at := 0.0


func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 1.0
	add_child(timer)
	timer.timeout.connect(_check_session)
	timer.start()


func is_busy() -> bool:
	return _busy


func get_current_user() -> Dictionary:
	if Time.get_unix_time_from_system() >= _expires_at:
		return {}
	return _user.duplicate()


func sign_in(email: String, password: String) -> String:
	if _busy or not _refresh_token.is_empty():
		return "Ya hay una sesión o solicitud activa."
	_set_busy(true)
	var response := await _post("/token?grant_type=password", {"email": email, "password": password})
	var message := ""
	if response.status == 200:
		if not _accept_session(response.data):
			message = "El servidor devolvió una sesión inválida."
	elif response.status == 0:
		message = CONNECTION_ERROR
	elif response.status == 429:
		message = "Demasiados intentos. Espera un momento."
	elif response.data.get("error_code") == "email_not_confirmed":
		message = "Confirma tu correo antes de iniciar sesión."
	elif response.data.get("error_code") == "invalid_credentials" or response.status == 401:
		message = "El correo o la contraseña son incorrectos."
	else:
		message = "No se pudo iniciar sesión. Inténtalo de nuevo."
	_set_busy(false)
	return message


func sign_out() -> String:
	if _busy or _access_token.is_empty():
		return ""
	_set_busy(true)
	var token := _access_token
	_clear_session()
	var response := await _post("/logout?scope=local", {}, token)
	_set_busy(false)
	if response.status not in [200, 204, 401, 403, 404]:
		return "Saliste del juego. No se pudo confirmar el cierre de la sesión con el servidor."
	return ""


func _check_session() -> void:
	if _busy or _refresh_token.is_empty():
		return
	var now := Time.get_unix_time_from_system()
	if now >= _expires_at:
		_clear_session()
	elif now >= _refresh_at:
		await _refresh_session()


func _refresh_session() -> void:
	_set_busy(true)
	var response := await _post("/token?grant_type=refresh_token", {"refresh_token": _refresh_token})
	if response.status == 200:
		if not _accept_session(response.data):
			_clear_session()
	elif response.status in [0, 429] or response.status >= 500:
		var now := Time.get_unix_time_from_system()
		_refresh_at = now + 5.0
		if now >= _expires_at:
			_clear_session()
	else:
		_clear_session()
	_set_busy(false)


func _accept_session(data: Dictionary) -> bool:
	var access: Variant = data.get("access_token")
	var refresh: Variant = data.get("refresh_token")
	var user: Variant = data.get("user")
	var lifetime: Variant = data.get("expires_in")
	if not access is String or access.is_empty() or not refresh is String or refresh.is_empty():
		return false
	if not (lifetime is float or lifetime is int) or not is_finite(float(lifetime)) or lifetime <= 0:
		return false
	if not user is Dictionary:
		return false
	var id: Variant = user.get("id")
	var email: Variant = user.get("email")
	if not id is String or id.is_empty() or not email is String or email.is_empty():
		return false
	if not _user.is_empty() and id != _user.id:
		return false
	_access_token = access
	_refresh_token = refresh
	_user = {"id": id, "email": email}
	var now := Time.get_unix_time_from_system()
	_expires_at = now + float(lifetime)
	_refresh_at = _expires_at - minf(60.0, float(lifetime) / 2.0)
	session_changed.emit()
	return true


func _clear_session() -> void:
	_access_token = ""
	_refresh_token = ""
	_user = {}
	_expires_at = 0.0
	_refresh_at = 0.0
	session_changed.emit()


func _set_busy(value: bool) -> void:
	_busy = value
	busy_changed.emit()


func _post(path: String, payload: Dictionary, bearer := "") -> Dictionary:
	var request := HTTPRequest.new()
	request.timeout = 12.0
	request.max_redirects = 0
	request.body_size_limit = 65536
	add_child(request)
	var headers := PackedStringArray(["apikey: " + PUBLIC_KEY, "Content-Type: application/json"])
	if not bearer.is_empty():
		headers.append("Authorization: Bearer " + bearer)
	if request.request(AUTH_URL + path, headers, HTTPClient.METHOD_POST, JSON.stringify(payload)) != OK:
		request.queue_free()
		return {"status": 0, "data": {}}
	var result: Array = await request.request_completed
	request.queue_free()
	if result[0] != HTTPRequest.RESULT_SUCCESS:
		return {"status": 0, "data": {}}
	var data: Variant = JSON.parse_string(result[3].get_string_from_utf8())
	return {"status": result[1], "data": data if data is Dictionary else {}}
