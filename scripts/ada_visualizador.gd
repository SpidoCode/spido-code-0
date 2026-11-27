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

	# Ondas de sonido / espectro de audio de A.D.A. a lo ancho de la tarjeta
	var cant_barras = 25
	var margen_lateral = 8.0
	var espacio_util = ancho - (margen_lateral * 2.0)
	var paso_x = espacio_util / float(cant_barras - 1)
	var base_y = alto * 0.5
	var verde_brillante := Color(0.7608, 0.937, 0.775, 0.95)

	for indice in range(cant_barras):
		var factor_centro = sin(PI * float(indice) / float(cant_barras - 1))
		var oscilacion = abs(sin(tiempo * 5.0 + indice * 0.5) * cos(tiempo * 2.5 + indice * 0.25))
		var altura: float = 3.5 + (factor_centro * 0.35 + 0.65) * oscilacion * (alto * 0.42)
		var bx = margen_lateral + indice * paso_x
		draw_line(Vector2(bx, base_y - altura), Vector2(bx, base_y + altura), verde_brillante, 3.0, false)
