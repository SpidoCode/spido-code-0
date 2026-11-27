class_name ADAVisualizador
extends Control

var tiempo: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	tiempo += delta
	queue_redraw()

func _draw() -> void:
	var ancho = size.x
	var alto = size.y
	if ancho < 10 or alto < 10:
		return

	# 1. Avatar Holográfico de A.D.A. (Orbe con aros concéntricos giratorios, sin rayos externos)
	var centro := Vector2(ancho * 0.5, alto * 0.42)
	var pulso: float = sin(tiempo * 2.4) * 0.5 + 0.5
	var verde_brillante := Color(0.7608, 0.937, 0.775, 0.95)
	var verde_borde := Color(0.3745, 0.5937, 0.4192, 0.85)
	var verde_suave := Color(0.3745, 0.5937, 0.4192, 0.22)
	var verde_texto := Color(0.8651, 1.0, 0.8664, 0.95)

	# Orbe y aros concéntricos
	draw_circle(centro, 24.0 + pulso * 2.0, verde_suave)
	draw_arc(centro, 28.0, tiempo, tiempo + 4.5, 36, verde_borde, 2.0, false)
	draw_arc(centro, 33.0, -tiempo * 0.7, -tiempo * 0.7 + 3.4, 36, Color(0.3745, 0.5937, 0.4192, 0.55), 2.0, false)
	draw_circle(centro, 10.0 + pulso * 1.5, verde_texto)
	draw_circle(centro, 4.0, Color.WHITE)

	# 2. Ondas de sonido / barras de ecualizador abajo
	var base_y: float = alto - 18.0
	var cant_barras = 11
	var paso_x = 5.4
	var ancho_total = (cant_barras - 1) * paso_x
	var inicio_x = centro.x - (ancho_total * 0.5)

	for indice in range(cant_barras):
		var altura: float = 3.5 + abs(sin(tiempo * 5.0 + indice * 0.8)) * 12.0
		var x: float = inicio_x + indice * paso_x
		draw_line(Vector2(x, base_y - altura), Vector2(x, base_y + altura), verde_brillante, 2.0, false)
