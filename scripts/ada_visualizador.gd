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

	# Ondas de sonido / barras de ecualizador de A.D.A.
	var cant_barras = 15
	var separacion = 5.0
	var ancho_barra = 4.0
	var ancho_total = cant_barras * ancho_barra + (cant_barras - 1) * separacion
	var inicio_x = (ancho - ancho_total) * 0.5
	var base_y = alto * 0.5
	var verde_brillante := Color(0.7608, 0.937, 0.775, 0.95)

	for indice in range(cant_barras):
		var altura: float = 3.5 + abs(sin(tiempo * 5.0 + indice * 0.6)) * (alto * 0.38)
		var bx = inicio_x + indice * (ancho_barra + separacion)
		draw_line(Vector2(bx, base_y - altura), Vector2(bx, base_y + altura), verde_brillante, 2.5, false)
