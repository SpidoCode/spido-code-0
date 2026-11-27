class_name ADAVisualizador
extends Control

@export var color_primario: Color = Color(0.35, 0.95, 0.65, 0.9)
@export var color_secundario: Color = Color(0.2, 0.6, 0.45, 0.4)

var alturas_barras: Array[float] = [0.2, 0.5, 0.8, 0.4, 0.9, 0.6, 0.3, 0.7, 0.5, 0.8, 0.3, 0.6]

func _process(delta: float) -> void:
	var t = Time.get_ticks_msec() * 0.005
	for i in range(alturas_barras.size()):
		var target = 0.2 + 0.7 * abs(sin(t + i * 0.8))
		alturas_barras[i] = lerp(alturas_barras[i], target, clamp(delta * 12.0, 0.0, 1.0))

	queue_redraw()

func _draw() -> void:
	var ancho = size.x
	var alto = size.y
	if ancho < 10 or alto < 10:
		return

	# Barras de frecuencia de audio ecualizador centradas horizontalmente
	var cant_barras = alturas_barras.size()
	var separacion = 4.0
	var margen_lateral = 12.0
	var espacio_util = max(20.0, ancho - (margen_lateral * 2.0))
	var ancho_barra = max(4.0, (espacio_util - (cant_barras - 1) * separacion) / cant_barras)
	var ancho_total = cant_barras * ancho_barra + (cant_barras - 1) * separacion
	var inicio_x = max(margen_lateral, (ancho - ancho_total) * 0.5)
	var base_y = alto * 0.5

	for i in range(cant_barras):
		var bx = inicio_x + i * (ancho_barra + separacion)
		var h = alturas_barras[i] * (alto * 0.4)
		var rect_barra = Rect2(bx, base_y - h, ancho_barra, max(4.0, h * 2.0))
		var col_b = color_primario
		col_b.a = 0.45 + (alturas_barras[i] * 0.55)
		draw_rect(rect_barra, col_b, true)
