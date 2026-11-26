class_name MesonSubensamblaje
extends Node3D

signal insumo_recibido(tipo: String, actual: int, requeridos: int)
signal producto_fabricado(tipo_producto: String)
signal producto_retirado(tipo_producto: String)

@export var celda_mesa: Vector2i = Vector2i(-2, 0)
@export var tipo_estacion: String = "PATAS" # PATAS, SENSORES, BRAZOS
@export var producto_salida: String = "PATAS"
@export var insumo_requerido: String = "CUALQUIERA"
@export var cantidad_requerida: int = 1
@export var capacidad_almacenamiento_maxima: int = 10

var insumos_actuales: int = 0
var productos_almacenados: int = 0
var producto_disponible: bool = false

var base_malla: MeshInstance3D
var luz_indicador: OmniLight3D
var soporte_salida: Node3D
var malla_producto_preview: MeshInstance3D
var panel_etiqueta: Label3D
var tolva_entrada: MeshInstance3D

func _ready() -> void:
	_construir_visuales_si_faltan()
	position = Vector3(celda_mesa.x * 2.0, 0, celda_mesa.y * 2.0)
	_actualizar_estado_visual()

func _construir_visuales_si_faltan() -> void:
	if not base_malla:
		# 1. Cuerpo principal de la máquina (Aleación grafito con biseles)
		base_malla = MeshInstance3D.new()
		base_malla.name = "BaseMeson"
		var box = BoxMesh.new()
		box.size = Vector3(1.5, 0.7, 1.4)
		base_malla.mesh = box
		var mat_chasis = StandardMaterial3D.new()
		mat_chasis.albedo_color = Color(0.18, 0.22, 0.27, 1) # Gris grafito industrial
		mat_chasis.metallic = 0.85
		mat_chasis.roughness = 0.3
		base_malla.material_override = mat_chasis
		base_malla.position = Vector3(0, 0.35, 0)
		add_child(base_malla)

		# 2. Placa de apoyo y ribetes luminosos inferiores
		var sub_base = MeshInstance3D.new()
		var m_sub = BoxMesh.new()
		m_sub.size = Vector3(1.6, 0.1, 1.5)
		sub_base.mesh = m_sub
		var mat_sub = StandardMaterial3D.new()
		mat_sub.albedo_color = Color(0.12, 0.14, 0.17, 1)
		sub_base.material_override = mat_sub
		sub_base.position = Vector3(0, 0.05, 0)
		add_child(sub_base)

		# 3. Consola / Panel vertical trasero con pantalla brillante
		var panel_trasero = MeshInstance3D.new()
		var m_panel = BoxMesh.new()
		m_panel.size = Vector3(1.3, 0.7, 0.2)
		panel_trasero.mesh = m_panel
		var mat_pt = StandardMaterial3D.new()
		mat_pt.albedo_color = Color(0.15, 0.18, 0.22, 1)
		mat_pt.metallic = 0.6
		panel_trasero.material_override = mat_pt
		panel_trasero.position = Vector3(0, 0.95, -0.5)
		add_child(panel_trasero)

		# Pantalla holográfica de la consola
		var pantalla = MeshInstance3D.new()
		var m_screen = BoxMesh.new()
		m_screen.size = Vector3(1.0, 0.45, 0.05)
		pantalla.mesh = m_screen
		var mat_screen = StandardMaterial3D.new()
		mat_screen.albedo_color = Color(0.1, 0.6, 0.8, 1)
		mat_screen.emission_enabled = true
		mat_screen.emission = Color(0.15, 0.75, 0.95, 1)
		mat_screen.emission_energy_multiplier = 1.2
		pantalla.material_override = mat_screen
		pantalla.position = Vector3(0, 0.98, -0.38)
		add_child(pantalla)

		# 4. Tolva de Entrada de Insumos (INPUT) hacia el Este (+X, de cara al centro)
		tolva_entrada = MeshInstance3D.new()
		tolva_entrada.name = "TolvaEntrada"
		var m_tolva = CylinderMesh.new()
		m_tolva.top_radius = 0.32
		m_tolva.bottom_radius = 0.2
		m_tolva.height = 0.25
		tolva_entrada.mesh = m_tolva
		var mat_tolva = StandardMaterial3D.new()
		mat_tolva.albedo_color = Color(0.9, 0.6, 0.15, 1) # Ámbar advertencia / tolva
		mat_tolva.emission_enabled = true
		mat_tolva.emission = Color(0.9, 0.55, 0.1, 1)
		mat_tolva.emission_energy_multiplier = 0.8
		tolva_entrada.material_override = mat_tolva
		tolva_entrada.position = Vector3(0.35, 0.8, 0.0)
		add_child(tolva_entrada)

	if not luz_indicador:
		luz_indicador = OmniLight3D.new()
		luz_indicador.name = "LuzIndicador"
		luz_indicador.position = Vector3(0, 1.3, 0)
		luz_indicador.omni_range = 3.5
		luz_indicador.light_energy = 1.2
		add_child(luz_indicador)

	if not panel_etiqueta:
		panel_etiqueta = Label3D.new()
		panel_etiqueta.name = "EtiquetaEstacion"
		panel_etiqueta.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		panel_etiqueta.no_depth_test = true
		panel_etiqueta.font_size = 24
		panel_etiqueta.outline_size = 6
		panel_etiqueta.outline_modulate = Color(0.05, 0.08, 0.12, 0.9)
		panel_etiqueta.modulate = Color(0.3, 0.9, 1.0, 1.0)
		panel_etiqueta.position = Vector3(0, 1.7, 0)
		add_child(panel_etiqueta)

	if not soporte_salida:
		# 5. Bandeja de Salida (OUTPUT) hacia el Norte / frente
		soporte_salida = Node3D.new()
		soporte_salida.name = "SoporteSalida"
		soporte_salida.position = Vector3(-0.35, 0.85, 0.0)
		add_child(soporte_salida)

		# Base de la bandeja
		var bandeja = MeshInstance3D.new()
		var m_band = BoxMesh.new()
		m_band.size = Vector3(0.5, 0.08, 0.5)
		bandeja.mesh = m_band
		var mat_band = StandardMaterial3D.new()
		mat_band.albedo_color = Color(0.2, 0.3, 0.35, 1)
		mat_band.metallic = 0.9
		bandeja.material_override = mat_band
		soporte_salida.add_child(bandeja)

		# Malla preview del producto forjado (extremidad mecánica / cilindro cian brillante)
		malla_producto_preview = MeshInstance3D.new()
		var mesh_p = CylinderMesh.new()
		mesh_p.top_radius = 0.22
		mesh_p.bottom_radius = 0.22
		mesh_p.height = 0.25
		malla_producto_preview.mesh = mesh_p
		var mat_p = StandardMaterial3D.new()
		mat_p.albedo_color = Color(0.2, 0.9, 0.8, 1)
		mat_p.metallic = 0.8
		mat_p.roughness = 0.2
		mat_p.emission_enabled = true
		mat_p.emission = Color(0.2, 0.9, 0.8, 1)
		mat_p.emission_energy_multiplier = 1.8
		malla_producto_preview.material_override = mat_p
		malla_producto_preview.position = Vector3(0, 0.16, 0)
		soporte_salida.add_child(malla_producto_preview)
		soporte_salida.visible = false

func puede_recibir_insumo(tipo_pieza: String) -> bool:
	if productos_almacenados >= capacidad_almacenamiento_maxima:
		return false
	if tipo_pieza != insumo_requerido and insumo_requerido != "CUALQUIERA":
		return false
	return true

func recibir_insumo(tipo_pieza: String) -> bool:
	if not puede_recibir_insumo(tipo_pieza):
		return false

	insumos_actuales += 1
	insumo_recibido.emit(tipo_pieza, insumos_actuales, cantidad_requerida)
	_animar_recepcion()

	if insumos_actuales >= cantidad_requerida:
		await _fabricar_producto()

	_actualizar_estado_visual()
	return true

func _animar_recepcion() -> void:
	if luz_indicador:
		var tw = create_tween()
		tw.tween_property(luz_indicador, "light_energy", 3.0, 0.15)
		tw.tween_property(luz_indicador, "light_energy", 1.2, 0.2)

func _fabricar_producto() -> void:
	insumos_actuales = 0
	productos_almacenados = mini(productos_almacenados + 1, capacidad_almacenamiento_maxima)
	producto_disponible = true

	# Efecto de fabricación con giro y escala
	if soporte_salida:
		soporte_salida.scale = Vector3.ZERO
		soporte_salida.visible = true
		var tw = create_tween().set_parallel(true)
		tw.tween_property(soporte_salida, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(soporte_salida, "rotation:y", TAU, 0.3).as_relative()
		await tw.finished

	producto_fabricado.emit(producto_salida)
	_actualizar_estado_visual()

func tiene_producto_listo() -> bool:
	return productos_almacenados > 0

func retirar_producto() -> String:
	if productos_almacenados <= 0:
		return ""
	productos_almacenados -= 1
	producto_disponible = (productos_almacenados > 0)
	var prod = producto_salida
	if productos_almacenados == 0 and soporte_salida:
		soporte_salida.visible = false
	_actualizar_estado_visual()
	producto_retirado.emit(prod)
	return prod

func _actualizar_estado_visual() -> void:
	if not luz_indicador: return

	var nombre_estacion = "FORJADORA DE PATAS" if tipo_estacion == "PATAS" else ("MÁQUINA DE SENSORES" if tipo_estacion == "SENSORES" else "ESTACIÓN DE TRABAJO")

	if productos_almacenados >= capacidad_almacenamiento_maxima:
		# Rojo / Ámbar saturado: Bandeja llena al máximo
		luz_indicador.light_color = Color(1.0, 0.35, 0.2)
		luz_indicador.light_energy = 2.6
		if soporte_salida: soporte_salida.visible = true
		if panel_etiqueta:
			panel_etiqueta.text = "%s\n[ BANDEJA LLENA: %d/%d %s ]\n¡DESAHOGAR CON ASTRO 2!" % [nombre_estacion, productos_almacenados, capacidad_almacenamiento_maxima, producto_salida]
			panel_etiqueta.modulate = Color(1.0, 0.4, 0.3)
	elif productos_almacenados > 0:
		# Verde esmeralda: Hay productos listos y todavía puede seguir recibiendo
		luz_indicador.light_color = Color(0.2, 1.0, 0.5)
		luz_indicador.light_energy = 2.0
		if soporte_salida: soporte_salida.visible = true
		if panel_etiqueta:
			panel_etiqueta.text = "%s\n[ STOCK LISTO: %d/%d %s ]" % [nombre_estacion, productos_almacenados, capacidad_almacenamiento_maxima, producto_salida]
			panel_etiqueta.modulate = Color(0.2, 1.0, 0.6)
	elif insumos_actuales > 0:
		# Amarillo / Naranja: Recibiendo insumos
		luz_indicador.light_color = Color(0.95, 0.75, 0.15)
		luz_indicador.light_energy = 1.5
		if soporte_salida: soporte_salida.visible = false
		if panel_etiqueta:
			panel_etiqueta.text = "%s\n[ INSUMOS: %d / %d ]" % [nombre_estacion, insumos_actuales, cantidad_requerida]
			panel_etiqueta.modulate = Color(1.0, 0.85, 0.25)
	else:
		# Azul suave: Mesón en espera
		luz_indicador.light_color = Color(0.2, 0.7, 1.0)
		luz_indicador.light_energy = 1.0
		if soporte_salida: soporte_salida.visible = false
		if panel_etiqueta:
			panel_etiqueta.text = "%s\n[ STOCK: 0 / %d ]" % [nombre_estacion, capacidad_almacenamiento_maxima]
			panel_etiqueta.modulate = Color(0.3, 0.9, 1.0)

func reiniciar() -> void:
	insumos_actuales = 0
	productos_almacenados = 0
	producto_disponible = false
	if soporte_salida:
		soporte_salida.visible = false
	_actualizar_estado_visual()
