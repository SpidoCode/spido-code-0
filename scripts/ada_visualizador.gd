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

	# 1. Avatar Holográfico de A.D.A. (Orbe con pulsos concéntricos y rayos)
	var centro := Vector2(ancho * 0.5, alto * 0.42)
	var pulso: float = sin(tiempo * 2.4) * 0.5 + 0.5
	var verde_brillante := Color(0.7608, 0.937, 0.775, 0.95)
	var verde_borde := Color(0.3745, 0.5937, 0.4192, 0.85)
	var verde_suave := Color(0.3745, 0.5937, 0.4192, 0.22)
	var verde_texto := Color(0.8651, 1.0, 0.8664, 0.95)

	# Orbe y aros concéntricos
	draw_circle(centro, 34.0 + pulso * 3.0, verde_suave)
	draw_arc(centro, 40.0, tiempo, tiempo + 4.5, 42, verde_borde, 2.0, false)
	draw_arc(centro, 49.0, -tiempo * 0.7, -tiempo * 0.7 + 3.4, 42, Color(0.3745, 0.5937, 0.4192, 0.55), 2.0, false)
	draw_circle(centro, 12.0 + pulso * 2.0, verde_texto)
	draw_circle(centro, 5.0, Color.WHITE)

	# 8 Rayos/Ticks giratorios alrededor del orbe
	for indice in range(8):
		var angulo: float = TAU * float(indice) / 8.0 + tiempo * 0.15
		var inicio := centro + Vector2.from_angle(angulo) * 53.0
		var final := centro + Vector2.from_angle(angulo) * 61.0
		draw_line(inicio, final, verde_brillante, 2.0, false)

	# 2. Ondas de sonido / barras de ecualizador abajo
	var base_y: float = alto - 18.0
	var cant_barras = 11
	var paso_x = 7.5
	var ancho_total = (cant_barras - 1) * paso_x
	var inicio_x = centro.x - (ancho_total * 0.5)

	for indice in range(cant_barras):
		var altura: float = 4.0 + abs(sin(tiempo * 5.0 + indice * 0.8)) * 13.0
		var x: float = inicio_x + indice * paso_x
		draw_line(Vector2(x, base_y - altura), Vector2(x, base_y + altura), verde_brillante, 2.0, false)
