class_name LienzoCodigo
extends PanelContainer

signal algoritmo_modificado

@export var escena_bloque: PackedScene

@onready var contenedor_bloques: VBoxContainer = $Scroll/ContenedorBloques
@onready var label_vacio: Label = $Scroll/ContenedorBloques/LabelVacio

var bloque_inicio: BloqueItem

func _ready() -> void:
	custom_minimum_size = Vector2(250, 200)
	asegurar_bloque_inicio()
	_actualizar_estado_vacio()

func asegurar_bloque_inicio() -> void:
	if not is_instance_valid(contenedor_bloques):
		contenedor_bloques = get_node_or_null("Scroll/ContenedorBloques")
	if not is_instance_valid(contenedor_bloques):
		return

	# Verificar si ya existe el bloque de inicio
	for h in contenedor_bloques.get_children():
		if h is BloqueItem and h.id_comando == "INICIO":
			bloque_inicio = h
			return

	# Crear el Bloque de Inicio (Hat Block estilo Scratch)
	if escena_bloque:
		bloque_inicio = escena_bloque.instantiate() as BloqueItem
	else:
		bloque_inicio = BloqueItem.new()

	bloque_inicio.configurar(
		"INICIO",
		"Al Presionar Ejecutar",
		"[INICIO]",
		Color(0.631373, 0.85098, 0.65098, 1.0),
		false,
		1,
		"evento"
	)

	contenedor_bloques.add_child(bloque_inicio)
	contenedor_bloques.move_child(bloque_inicio, 0)

func resaltar_inicio(activo: bool) -> void:
	if is_instance_valid(bloque_inicio):
		bloque_inicio.resaltar_ejecucion(activo)

func obtener_bloque_inicio() -> BloqueItem:
	return bloque_inicio

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.get("tipo") == "bloque_codigo"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if not _can_drop_data(at_position, data):
		return

	# Asegurar que siempre se coloque debajo del bloque de inicio (índice >= 1)
	var idx_destino = max(1, _calcular_indice_insercion(at_position.y))

	if data.get("es_de_paleta", false):
		var nuevo_bloque: BloqueItem
		if escena_bloque:
			nuevo_bloque = escena_bloque.instantiate() as BloqueItem
		else:
			nuevo_bloque = BloqueItem.new()

		var id_cmd = data.get("id_comando", "AVANZAR")
		var tit = data.get("titulo", "Comando")
		var pref = data.get("prefijo", "[CMD]")
		var cat = data.get("categoria", "")
		var color_b = data.get("color_borde", Color(0.545, 0.796, 0.569))
		var param = data.get("parametro_valor", 1)

		nuevo_bloque.configurar(id_cmd, tit, pref, color_b, false, param, cat)
		nuevo_bloque.solicitado_eliminar.connect(_on_bloque_solicitado_eliminar)
		nuevo_bloque.parametro_cambiado.connect(func(_b, _v): algoritmo_modificado.emit())

		contenedor_bloques.add_child(nuevo_bloque)
		contenedor_bloques.move_child(nuevo_bloque, idx_destino)
	else:
		var nodo_origen = data.get("nodo_origen")
		if is_instance_valid(nodo_origen) and nodo_origen.get_parent() == contenedor_bloques:
			if nodo_origen.id_comando != "INICIO":
				contenedor_bloques.move_child(nodo_origen, idx_destino)

	_actualizar_estado_vacio()
	algoritmo_modificado.emit()

func agregar_comando(id_cmd: String, param: int = 1, p_tit: String = "", p_pref: String = "", p_cat: String = "", p_color: Color = Color.WHITE) -> void:
	if not is_instance_valid(contenedor_bloques):
		contenedor_bloques = get_node_or_null("Scroll/ContenedorBloques")
	if not is_instance_valid(contenedor_bloques):
		return
	var nuevo_bloque: BloqueItem
	if escena_bloque:
		nuevo_bloque = escena_bloque.instantiate() as BloqueItem
	else:
		nuevo_bloque = BloqueItem.new()

	var tit = p_tit if not p_tit.is_empty() else id_cmd.capitalize()
	var pref = p_pref if not p_pref.is_empty() else "[%s]" % id_cmd.substr(0, 3)
	nuevo_bloque.configurar(id_cmd, tit, pref, p_color, false, param, p_cat)
	nuevo_bloque.solicitado_eliminar.connect(_on_bloque_solicitado_eliminar)
	nuevo_bloque.parametro_cambiado.connect(func(_b, _v): algoritmo_modificado.emit())

	contenedor_bloques.add_child(nuevo_bloque)
	_actualizar_estado_vacio()
	algoritmo_modificado.emit()

func _calcular_indice_insercion(pos_y: float) -> int:
	var hijos = contenedor_bloques.get_children()
	var indice = 1 # Siempre debajo del bloque de inicio
	for i in range(1, hijos.size()):
		var h = hijos[i]
		if h is BloqueItem and h.visible and h.id_comando != "INICIO":
			var center_y = h.global_position.y + (h.size.y * 0.5) - contenedor_bloques.global_position.y
			if pos_y > center_y:
				indice = i + 1
	return indice

func obtener_secuencia_comandos() -> Array[BloqueItem]:
	var lista: Array[BloqueItem] = []
	if not is_instance_valid(contenedor_bloques):
		contenedor_bloques = get_node_or_null("Scroll/ContenedorBloques")
	if not is_instance_valid(contenedor_bloques):
		return lista
	for h in contenedor_bloques.get_children():
		if h is BloqueItem and h.visible and h.id_comando != "INICIO" and not h.is_queued_for_deletion():
			lista.append(h)
	return lista

func limpiar() -> void:
	limpiar_todo()

func limpiar_todo() -> void:
	if not is_instance_valid(contenedor_bloques):
		contenedor_bloques = get_node_or_null("Scroll/ContenedorBloques")
	if not is_instance_valid(contenedor_bloques):
		return
	for h in contenedor_bloques.get_children():
		if h is BloqueItem and h.id_comando != "INICIO":
			h.queue_free()
	_actualizar_estado_vacio()
	algoritmo_modificado.emit()

func duplicar_secuencia() -> bool:
	var originales = obtener_secuencia_comandos()
	if originales.is_empty():
		return false
	var copias: Array[BloqueItem] = []
	for original in originales:
		var copia := escena_bloque.instantiate() as BloqueItem
		copia.configurar(
			original.id_comando,
			original.titulo,
			original.prefijo,
			original.color_borde,
			false,
			original.parametro_valor,
			original.categoria
		)
		copia.solicitado_eliminar.connect(_on_bloque_solicitado_eliminar)
		copias.append(copia)
	for copia in copias:
		contenedor_bloques.add_child(copia)
	_actualizar_estado_vacio()
	algoritmo_modificado.emit()
	return true

func _on_bloque_solicitado_eliminar(bloque: BloqueItem) -> void:
	if bloque.id_comando == "INICIO":
		return
	bloque.queue_free()
	await get_tree().process_frame
	_actualizar_estado_vacio()
	algoritmo_modificado.emit()

func _actualizar_estado_vacio() -> void:
	var hay_comandos = false
	for h in contenedor_bloques.get_children():
		if h is BloqueItem and not h.is_queued_for_deletion() and h.id_comando != "INICIO":
			hay_comandos = true
			break
	if label_vacio:
		label_vacio.visible = not hay_comandos
