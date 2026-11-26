class_name MaquinaCinta
extends Node3D

signal pieza_ingresada(tipo: String)
signal pieza_procesada(tipo: String)
signal pieza_retirada(tipo: String)

@export var celda_entrada: Vector2i = Vector2i(0, -2)
@export var celda_salida: Vector2i = Vector2i(2, -2)
@export var tiempo_procesamiento: float = 1.0
@export var capacidad_almacenamiento_maxima: int = 8

var productos_almacenados: int = 0
var piezas_en_transito: int = 0
var producto_salida_tipo: String = "COMPONENTE_PROCESADO"

var base_malla: MeshInstance3D
var cinta_malla: MeshInstance3D
var cabezal_central: MeshInstance3D
var tolva_in: MeshInstance3D
var bandeja_out: MeshInstance3D
var luz_in: OmniLight3D
var luz_out: OmniLight3D
var etiqueta_in: Label3D
var etiqueta_out: Label3D
var pieza_en_cinta_preview: MeshInstance3D

func _ready() -> void:
	_construir_visuales()
	_actualizar_estado_visual()

func _construir_visuales() -> void:
	# 1. Base / Chasis de la Máquina de Cinta
	# Conecta desde X=-1 hasta X=1 (longitud total aprox 4.5 metros)
	var pos_centro = Vector3(
		(celda_entrada.x + celda_salida.x) * 0.5 * 2.0,
		0,
		celda_entrada.y * 2.0
	)
	position = pos_centro

	base_malla = MeshInstance3D.new()
	base_malla.name = "ChasisCinta"
	var box = BoxMesh.new()
	var largo_x = abs(celda_salida.x - celda_entrada.x) * 2.0 + 1.6
	box.size = Vector3(largo_x, 0.55, 1.3)
	base_malla.mesh = box
	var mat_c = StandardMaterial3D.new()
	mat_c.albedo_color = Color(0.16, 0.20, 0.25, 1.0)
	mat_c.metallic = 0.8
	mat_c.roughness = 0.35
	base_malla.material_override = mat_c
	base_malla.position = Vector3(0, 0.28, 0)
	add_child(base_malla)

	# 2. Cinta Transportadora
	cinta_malla = MeshInstance3D.new()
	cinta_malla.name = "SuperficieCinta"
	var m_cinta = BoxMesh.new()
	m_cinta.size = Vector3(largo_x - 0.2, 0.08, 0.85)
	cinta_malla.mesh = m_cinta
	var mat_cinta = StandardMaterial3D.new()
	mat_cinta.albedo_color = Color(0.08, 0.10, 0.12, 1.0)
	mat_cinta.roughness = 0.7
	mat_cinta.metallic = 0.2
	cinta_malla.material_override = mat_cinta
	cinta_malla.position = Vector3(0, 0.58, 0)
	add_child(cinta_malla)

	# 3. Cabezal de Procesamiento Central (Cúpula industrial con láser de trabajo)
	cabezal_central = MeshInstance3D.new()
	cabezal_central.name = "CabezalProcesador"
	var m_cab = BoxMesh.new()
	m_cab.size = Vector3(1.1, 0.9, 1.35)
	cabezal_central.mesh = m_cab
	var mat_cab = StandardMaterial3D.new()
	mat_cab.albedo_color = Color(0.22, 0.27, 0.33, 1.0)
	mat_cab.metallic = 0.7
	cabezal_central.material_override = mat_cab
	cabezal_central.position = Vector3(0, 0.9, 0)
	add_child(cabezal_central)

	# Visor holográfico central
	var visor_proc = MeshInstance3D.new()
	var m_v = BoxMesh.new()
	m_v.size = Vector3(0.7, 0.35, 0.05)
	visor_proc.mesh = m_v
	var mat_v = StandardMaterial3D.new()
	mat_v.albedo_color = Color(0.2, 0.8, 1.0, 1.0)
	mat_v.emission_enabled = true
	mat_v.emission = Color(0.2, 0.85, 1.0, 1.0)
	mat_v.emission_energy_multiplier = 1.5
	visor_proc.material_override = mat_v
	visor_proc.position = Vector3(0, 0.92, 0.69)
	add_child(visor_proc)

	# 4. Extremo de Entrada (Marker Local: izquierda -X)
	var offset_in_x = (celda_entrada.x * 2.0) - pos_centro.x
	tolva_in = MeshInstance3D.new()
	tolva_in.name = "TolvaEntrada"
	var m_tin = CylinderMesh.new()
	m_tin.top_radius = 0.36
	m_tin.bottom_radius = 0.25
	m_tin.height = 0.22
	tolva_in.mesh = m_tin
	var mat_in = StandardMaterial3D.new()
	mat_in.albedo_color = Color(0.95, 0.65, 0.15, 1.0)
	mat_in.emission_enabled = true
	mat_in.emission = Color(0.9, 0.6, 0.1, 1.0)
	mat_in.emission_energy_multiplier = 0.9
	tolva_in.material_override = mat_in
	tolva_in.position = Vector3(offset_in_x, 0.68, 0)
	add_child(tolva_in)

	luz_in = OmniLight3D.new()
	luz_in.light_color = Color(1.0, 0.7, 0.2)
	luz_in.light_energy = 1.2
	luz_in.omni_range = 2.5
	luz_in.position = Vector3(offset_in_x, 1.2, 0)
	add_child(luz_in)

	etiqueta_in = Label3D.new()
	etiqueta_in.text = "CINTA AUTOMÁTICA\n[ ENTRADA ]"
	etiqueta_in.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	etiqueta_in.no_depth_test = true
	etiqueta_in.font_size = 20
	etiqueta_in.outline_size = 5
	etiqueta_in.outline_modulate = Color(0.05, 0.08, 0.12, 0.9)
	etiqueta_in.modulate = Color(0.95, 0.75, 0.2, 1.0)
	etiqueta_in.position = Vector3(offset_in_x, 1.6, 0)
	etiqueta_in.visible = false
	add_child(etiqueta_in)

	# 5. Extremo de Salida (Marker Local: derecha +X)
	var offset_out_x = (celda_salida.x * 2.0) - pos_centro.x
	bandeja_out = MeshInstance3D.new()
	bandeja_out.name = "BandejaSalida"
	var m_bout = BoxMesh.new()
	m_bout.size = Vector3(0.65, 0.12, 0.65)
	bandeja_out.mesh = m_bout
	var mat_bout = StandardMaterial3D.new()
	mat_bout.albedo_color = Color(0.2, 0.85, 0.5, 1.0)
	mat_bout.metallic = 0.8
	bandeja_out.material_override = mat_bout
	bandeja_out.position = Vector3(offset_out_x, 0.65, 0)
	add_child(bandeja_out)

	luz_out = OmniLight3D.new()
	luz_out.light_color = Color(0.2, 0.9, 0.6)
	luz_out.light_energy = 1.5
	luz_out.omni_range = 2.5
	luz_out.position = Vector3(offset_out_x, 1.2, 0)
	add_child(luz_out)

	etiqueta_out = Label3D.new()
	etiqueta_out.text = "CINTA AUTOMÁTICA\n[ SALIDA ]"
	etiqueta_out.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	etiqueta_out.no_depth_test = true
	etiqueta_out.font_size = 20
	etiqueta_out.outline_size = 5
	etiqueta_out.outline_modulate = Color(0.05, 0.08, 0.12, 0.9)
	etiqueta_out.modulate = Color(0.2, 0.95, 0.6, 1.0)
	etiqueta_out.position = Vector3(offset_out_x, 1.6, 0)
	etiqueta_out.visible = false
	add_child(etiqueta_out)

	# 6. Pieza de previsualización en la salida
	pieza_en_cinta_preview = MeshInstance3D.new()
	var m_prev = CylinderMesh.new()
	m_prev.top_radius = 0.22
	m_prev.bottom_radius = 0.22
	m_prev.height = 0.28
	pieza_en_cinta_preview.mesh = m_prev
	var mat_prev = StandardMaterial3D.new()
	mat_prev.albedo_color = Color(0.25, 0.95, 0.85, 1.0)
	mat_prev.emission_enabled = true
	mat_prev.emission = Color(0.25, 0.95, 0.85, 1.0)
	mat_prev.emission_energy_multiplier = 1.8
	pieza_en_cinta_preview.material_override = mat_prev
	pieza_en_cinta_preview.position = Vector3(offset_out_x, 0.86, 0)
	add_child(pieza_en_cinta_preview)
	pieza_en_cinta_preview.visible = false

func es_celda_de_interaccion(celda: Vector2i) -> bool:
	return celda == celda_entrada or celda == celda_salida

func es_celda_solida(celda: Vector2i) -> bool:
	# La máquina ocupa desde entrada.x hasta salida.x en Z=celda_entrada.y
	var min_x = mini(celda_entrada.x, celda_salida.x)
	var max_x = maxi(celda_entrada.x, celda_salida.x)
	return celda.y == celda_entrada.y and celda.x >= min_x and celda.x <= max_x

func puede_recibir_en_entrada(_tipo_pieza: String) -> bool:
	return (productos_almacenados + piezas_en_transito) < capacidad_almacenamiento_maxima

func recibir_en_entrada(tipo_pieza: String) -> bool:
	if not puede_recibir_en_entrada(tipo_pieza):
		return false

	piezas_en_transito += 1
	pieza_ingresada.emit(tipo_pieza)
	_animar_ingreso_entrada()

	# Proceso de transporte continuo en segundo plano a lo largo de la cinta
	_procesar_transporte_cinta(tipo_pieza)
	return true

func _animar_ingreso_entrada() -> void:
	if luz_in:
		var tw = create_tween()
		tw.tween_property(luz_in, "light_energy", 3.0, 0.15)
		tw.tween_property(luz_in, "light_energy", 1.2, 0.25)

func _procesar_transporte_cinta(_tipo_pieza: String) -> void:
	var offset_in_x = (celda_entrada.x * 2.0) - position.x
	var offset_out_x = (celda_salida.x * 2.0) - position.x

	# Ítem temporal viajando físicamente por la cinta
	var pieza_viajera = MeshInstance3D.new()
	var box_m = BoxMesh.new()
	box_m.size = Vector3(0.3, 0.3, 0.3)
	pieza_viajera.mesh = box_m
	var mat_v = StandardMaterial3D.new()
	mat_v.albedo_color = Color(0.9, 0.7, 0.2, 1.0)
	mat_v.emission_enabled = true
	mat_v.emission = Color(0.9, 0.65, 0.1, 1.0)
	mat_v.emission_energy_multiplier = 1.0
	pieza_viajera.material_override = mat_v
	pieza_viajera.position = Vector3(offset_in_x, 0.72, 0)
	add_child(pieza_viajera)

	var tw = create_tween()
	tw.tween_property(pieza_viajera, "position:x", offset_out_x, tiempo_procesamiento).set_trans(Tween.TRANS_LINEAR)
	tw.finished.connect(func():
		if is_instance_valid(pieza_viajera):
			pieza_viajera.queue_free()
		piezas_en_transito = maxi(0, piezas_en_transito - 1)
		productos_almacenados = mini(productos_almacenados + 1, capacidad_almacenamiento_maxima)
		producto_salida_tipo = "COMPONENTE_PROCESADO"
		pieza_procesada.emit(producto_salida_tipo)
		_actualizar_estado_visual()
	)

func tiene_producto_en_salida() -> bool:
	return productos_almacenados > 0

func retirar_de_salida() -> String:
	if productos_almacenados <= 0:
		return ""

	productos_almacenados -= 1
	var prod = producto_salida_tipo
	pieza_retirada.emit(prod)
	_actualizar_estado_visual()
	return prod

func _actualizar_estado_visual() -> void:
	if not etiqueta_in or not etiqueta_out: return

	etiqueta_in.text = "CINTA AUTOMÁTICA\n[ ENTRADA: %d/%d ]" % [piezas_en_transito, capacidad_almacenamiento_maxima]
	if productos_almacenados > 0:
		etiqueta_out.text = "CINTA AUTOMÁTICA\n[ SALIDA: %d DISPONIBLES ]" % productos_almacenados
		etiqueta_out.modulate = Color(0.2, 1.0, 0.6)
		if pieza_en_cinta_preview: pieza_en_cinta_preview.visible = true
		if luz_out: luz_out.light_energy = 2.2
	else:
		etiqueta_out.text = "CINTA AUTOMÁTICA\n[ SALIDA: VACÍA ]"
		etiqueta_out.modulate = Color(0.4, 0.7, 0.8)
		if pieza_en_cinta_preview: pieza_en_cinta_preview.visible = false
		if luz_out: luz_out.light_energy = 0.8
