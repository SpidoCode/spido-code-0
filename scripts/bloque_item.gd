class_name BloqueItem
extends PanelContainer

signal solicitado_eliminar(bloque: BloqueItem)
signal parametro_cambiado(bloque: BloqueItem, nuevo_valor: int)
signal solicitado_anadir(bloque: BloqueItem)

enum TipoForma {
	FORMA_INICIO = 0,
	FORMA_ESTANDAR = 1
}

# Paleta de colores consistente con la temática del juego
const COLORES_CATEGORIA = {
	"evento": {
		"borde": Color(0.631373, 0.85098, 0.65098, 1.0),      # Verde claro luminoso (Tema)
		"fondo": Color(0.14, 0.22, 0.18, 0.98),              # Fondo menta oscuro
		"prefijo": Color(0.631373, 0.85098, 0.65098, 1.0)
	},
	"movimiento": {
		"borde": Color(0.545098, 0.796078, 0.568627, 1.0),   # Verde primario Spido (Tema)
		"fondo": Color(0.12, 0.17, 0.15, 0.98),              # Fondo verde suave
		"prefijo": Color(0.545098, 0.796078, 0.568627, 1.0)
	},
	"giro": {
		"borde": Color(0.631373, 0.85098, 0.65098, 1.0),      # Verde claro luminoso (Tema)
		"fondo": Color(0.13, 0.19, 0.17, 0.98),              # Fondo menta sutil
		"prefijo": Color(0.631373, 0.85098, 0.65098, 1.0)
	},
	"accion": {
		"borde": Color(0.435294, 0.686275, 0.470588, 1.0),   # Verde medio / esmeralda (Tema)
		"fondo": Color(0.11, 0.16, 0.14, 0.98),              # Fondo esmeralda oscuro
		"prefijo": Color(0.435294, 0.686275, 0.470588, 1.0)
	},
	"control": {
		"borde": Color(0.48, 0.55, 0.65, 1.0),               # Gris claro / pizarra azulada (Tema)
		"fondo": Color(0.16, 0.19, 0.24, 0.98),              # Fondo gris pizarra
		"prefijo": Color(0.60, 0.68, 0.78, 1.0)
	}
}

@export var id_comando: String = "AVANZAR"
@export var titulo: String = "Avanzar"
@export var prefijo: String = "[AVZ]"
@export var categoria: String = "movimiento"
@export var tipo_forma: TipoForma = TipoForma.FORMA_ESTANDAR
@export var color_borde: Color = Color(0.545098, 0.796078, 0.568627, 1.0)
@export var color_fondo: Color = Color(0.12, 0.17, 0.15, 0.98)
@export var es_de_paleta: bool = false
@export var es_eliminable: bool = true
@export var parametro_valor: int = 1

var label_prefijo: Label
var label_titulo: Label
var box_parametro: HBoxContainer
var btn_menos: Button
var label_valor: Label
var btn_mas: Button
var btn_eliminar: Button

var estado_hover: bool = false
var es_ejecutando: bool = false
var tiene_error: bool = false

func _ready() -> void:
	custom_minimum_size = Vector2(190, 34 if tipo_forma == TipoForma.FORMA_ESTANDAR else 38)
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Estilo transparente en el PanelContainer base para permitir dibujo personalizado
	var style_empty = StyleBoxEmpty.new()
	style_empty.content_margin_left = 20
	style_empty.content_margin_top = 6 if tipo_forma == TipoForma.FORMA_INICIO else 3
	style_empty.content_margin_right = 6
	style_empty.content_margin_bottom = 3
	add_theme_stylebox_override("panel", style_empty)

	_vincular_nodos()
	_configurar_colores_categoria()
	actualizar_vista()

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	if is_instance_valid(btn_eliminar):
		btn_eliminar.visible = (not es_de_paleta) and es_eliminable
		if not btn_eliminar.pressed.is_connected(_on_btn_eliminar_pressed):
			btn_eliminar.pressed.connect(_on_btn_eliminar_pressed)

	if is_instance_valid(btn_menos):
		if not btn_menos.pressed.is_connected(_on_btn_menos_pressed):
			btn_menos.pressed.connect(_on_btn_menos_pressed)
	if is_instance_valid(btn_mas):
		if not btn_mas.pressed.is_connected(_on_btn_mas_pressed):
			btn_mas.pressed.connect(_on_btn_mas_pressed)

func _vincular_nodos() -> void:
	label_prefijo = get_node_or_null("Margin/HBox/Prefijo") if has_node("Margin/HBox/Prefijo") else get_node_or_null("HBox/Prefijo")
	label_titulo = get_node_or_null("Margin/HBox/Titulo") if has_node("Margin/HBox/Titulo") else get_node_or_null("HBox/Titulo")
	box_parametro = get_node_or_null("Margin/HBox/BoxParametro") if has_node("Margin/HBox/BoxParametro") else get_node_or_null("HBox/BoxParametro")
	btn_menos = get_node_or_null("Margin/HBox/BoxParametro/BtnMenos") if has_node("Margin/HBox/BoxParametro/BtnMenos") else get_node_or_null("HBox/BoxParametro/BtnMenos")
	label_valor = get_node_or_null("Margin/HBox/BoxParametro/LabelValor") if has_node("Margin/HBox/BoxParametro/LabelValor") else get_node_or_null("HBox/BoxParametro/LabelValor")
	btn_mas = get_node_or_null("Margin/HBox/BoxParametro/BtnMas") if has_node("Margin/HBox/BoxParametro/BtnMas") else get_node_or_null("HBox/BoxParametro/BtnMas")
	btn_eliminar = get_node_or_null("Margin/HBox/BtnEliminar") if has_node("Margin/HBox/BtnEliminar") else get_node_or_null("HBox/BtnEliminar")

func configurar(p_id: String, p_titulo: String, p_prefijo: String, p_color_borde: Color = Color.WHITE, p_paleta: bool = false, p_parametro: int = 1, p_cat: String = "") -> void:
	id_comando = p_id
	titulo = p_titulo
	prefijo = p_prefijo
	es_de_paleta = p_paleta
	parametro_valor = p_parametro

	if p_cat.is_empty():
		if p_id == "INICIO":
			categoria = "evento"
		elif p_id.begins_with("AVANZAR") or p_id == "RETROCEDER":
			categoria = "movimiento"
		elif p_id.begins_with("GIRAR") or p_id == "GIRO_180":
			categoria = "giro"
		elif p_id == "BUCLE":
			categoria = "control"
		else:
			categoria = "accion"
	else:
		categoria = p_cat

	if p_id == "INICIO":
		tipo_forma = TipoForma.FORMA_INICIO
		es_eliminable = false
	else:
		tipo_forma = TipoForma.FORMA_ESTANDAR
		es_eliminable = true

	_configurar_colores_categoria()
	if p_color_borde != Color.WHITE:
		color_borde = p_color_borde

	_vincular_nodos()
	actualizar_vista()
	queue_redraw()

func _configurar_colores_categoria() -> void:
	if COLORES_CATEGORIA.has(categoria):
		var info = COLORES_CATEGORIA[categoria]
		color_borde = info["borde"]
		color_fondo = info["fondo"]

func actualizar_vista() -> void:
	if is_instance_valid(label_prefijo):
		label_prefijo.text = prefijo
		label_prefijo.modulate = color_borde
	if is_instance_valid(label_titulo):
		label_titulo.text = titulo
	if is_instance_valid(btn_eliminar):
		btn_eliminar.visible = (not es_de_paleta) and es_eliminable

	var admite_parametro = (id_comando == "AVANZAR")
	if is_instance_valid(box_parametro):
		box_parametro.visible = admite_parametro
		if admite_parametro and is_instance_valid(label_valor):
			label_valor.text = str(parametro_valor)

	queue_redraw()

func _on_btn_menos_pressed() -> void:
	if parametro_valor > 1:
		parametro_valor -= 1
		actualizar_vista()
		parametro_cambiado.emit(self, parametro_valor)

func _on_btn_mas_pressed() -> void:
	if parametro_valor < 8:
		parametro_valor += 1
		actualizar_vista()
		parametro_cambiado.emit(self, parametro_valor)

func _on_mouse_entered() -> void:
	estado_hover = true
	queue_redraw()

func _on_mouse_exited() -> void:
	estado_hover = false
	queue_redraw()

func resaltar_ejecucion(activo: bool) -> void:
	es_ejecutando = activo
	if activo:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.02, 1.02), 0.08)
	else:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ONE, 0.08)
	queue_redraw()

func resaltar_error(activo: bool) -> void:
	tiene_error = activo
	queue_redraw()

func _draw() -> void:
	var w = size.x
	var h = size.y
	var tab_x = 16.0
	var tab_w = 20.0
	var tab_d = 4.0
	var r = 5.0

	var pts: Array[Vector2] = []
	if tipo_forma == TipoForma.FORMA_INICIO:
		# Hat Block estilo Scratch: arco curvado superior suave y compacto
		pts.append(Vector2(0, 11))
		pts.append(Vector2(6, 5))
		pts.append(Vector2(16, 2))
		pts.append(Vector2(36, 0))
		pts.append(Vector2(65, 0))
		pts.append(Vector2(95, 2))
		pts.append(Vector2(115, 6))
		pts.append(Vector2(130, 10))
		pts.append(Vector2(w - r, 10))
		pts.append(Vector2(w, 10 + r))
	else:
		# Bloque Estándar: Muesca superior (凹) para encastrar con el bloque anterior
		pts.append(Vector2(0, r))
		pts.append(Vector2(r, 0))
		pts.append(Vector2(tab_x, 0))
		pts.append(Vector2(tab_x + 2.5, tab_d))
		pts.append(Vector2(tab_x + tab_w - 2.5, tab_d))
		pts.append(Vector2(tab_x + tab_w, 0))
		pts.append(Vector2(w - r, 0))
		pts.append(Vector2(w, r))

	# Lado derecho
	pts.append(Vector2(w, h - r))
	pts.append(Vector2(w - r, h))

	# Borde inferior: Lengüeta de encastre hacia abajo (凸)
	pts.append(Vector2(tab_x + tab_w, h))
	pts.append(Vector2(tab_x + tab_w - 2.5, h + tab_d))
	pts.append(Vector2(tab_x + 2.5, h + tab_d))
	pts.append(Vector2(tab_x, h))
	pts.append(Vector2(r, h))
	pts.append(Vector2(0, h - r))

	var packed_pts = PackedVector2Array(pts)

	# 1. Sombra exterior
	var shadow_offset = Vector2(0, 2)
	var shadow_pts = PackedVector2Array()
	for p in packed_pts:
		shadow_pts.append(p + shadow_offset)
	draw_colored_polygon(shadow_pts, Color(0.06, 0.08, 0.12, 0.5))

	# 2. Relleno principal
	var color_bg = color_fondo
	if es_ejecutando:
		color_bg = color_bg.lightened(0.18)
	elif tiene_error:
		color_bg = Color(0.28, 0.16, 0.18, 0.98)
	elif estado_hover:
		color_bg = color_bg.lightened(0.07)
	draw_colored_polygon(packed_pts, color_bg)

	# 3. Contorno de puzzle
	var color_b = color_borde
	var border_w = 1.8
	if es_ejecutando:
		color_b = Color(0.92, 1.0, 0.88, 1.0) # Brillo neón de ejecución
		border_w = 2.4
	elif tiene_error:
		color_b = Color(0.92, 0.42, 0.42, 1.0)
		border_w = 2.4

	var outline = PackedVector2Array(packed_pts)
	outline.append(packed_pts[0])
	draw_polyline(outline, color_b, border_w, true)

	# 4. Acento decorativo sutil en la lengüeta
	var tab_line = PackedVector2Array([
		Vector2(tab_x + 2.5, h + tab_d - 1.0),
		Vector2(tab_x + tab_w - 2.5, h + tab_d - 1.0)
	])
	draw_polyline(tab_line, color_b.lightened(0.2), 1.2)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if tipo_forma == TipoForma.FORMA_INICIO:
		return null # El bloque de inicio no se arrastra fuera del tope

	var preview = PanelContainer.new()
	var st = StyleBoxFlat.new()
	st.bg_color = color_fondo
	st.border_color = color_borde
	st.border_width_left = 3
	st.border_width_top = 2
	st.border_width_right = 2
	st.border_width_bottom = 2
	st.set_corner_radius_all(8)
	st.set_content_margin_all(6)
	preview.add_theme_stylebox_override("panel", st)
	preview.custom_minimum_size = custom_minimum_size

	var hbox = HBoxContainer.new()
	var l_pref = Label.new()
	l_pref.text = prefijo
	l_pref.modulate = color_borde
	var l_tit = Label.new()
	if id_comando == "AVANZAR":
		l_tit.text = "%s (%d)" % [titulo, parametro_valor]
	else:
		l_tit.text = titulo
	l_tit.modulate = Color(0.956863, 0.964706, 0.94902, 1.0)
	hbox.add_child(l_pref)
	hbox.add_child(l_tit)
	preview.add_child(hbox)

	set_drag_preview(preview)

	return {
		"tipo": "bloque_codigo",
		"id_comando": id_comando,
		"titulo": titulo,
		"prefijo": prefijo,
		"categoria": categoria,
		"color_borde": color_borde,
		"parametro_valor": parametro_valor,
		"nodo_origen": self,
		"es_de_paleta": es_de_paleta
	}

func _gui_input(event: InputEvent) -> void:
	if es_de_paleta and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		solicitado_anadir.emit(self)

func _on_btn_eliminar_pressed() -> void:
	if es_eliminable:
		solicitado_eliminar.emit(self)
