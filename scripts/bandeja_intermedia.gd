class_name BandejaIntermedia
extends Node3D

signal componente_depositado(total: int)
signal componente_retirado(restantes: int)

@export var celda: Vector2i = Vector2i(1, 1)
@export var capacidad_maxima: int = 12

var stock_actual: int = 0
var tipo_almacenado: String = "COMPONENTE_PROCESADO"

var base_malla: MeshInstance3D
var panel_etiqueta: Label3D
var luz_indicador: OmniLight3D
var contenedor_pilas: Node3D

func _ready() -> void:
	_construir_visuales()
	posicionar_en_celda(celda)
	_actualizar_estado_visual()

func posicionar_en_celda(p_celda: Vector2i) -> void:
	celda = p_celda
	position = Vector3(celda.x * 2.0, 0, celda.y * 2.0)

func _construir_visuales() -> void:
	base_malla = MeshInstance3D.new()
	base_malla.name = "BaseBandeja"
	var box = BoxMesh.new()
	box.size = Vector3(1.3, 0.25, 1.3)
	base_malla.mesh = box
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.25, 0.32, 1.0)
	mat.metallic = 0.85
	mat.roughness = 0.3
	base_malla.material_override = mat
	base_malla.position = Vector3(0, 0.125, 0)
	add_child(base_malla)

	# Borde superior luminoso
	var borde = MeshInstance3D.new()
	var m_b = TorusMesh.new()
	m_b.inner_radius = 0.52
	m_b.outer_radius = 0.58
	borde.mesh = m_b
	var mat_b = StandardMaterial3D.new()
	mat_b.albedo_color = Color(0.2, 0.8, 1.0, 1.0)
	mat_b.emission_enabled = true
	mat_b.emission = Color(0.2, 0.8, 1.0, 1.0)
	mat_b.emission_energy_multiplier = 1.2
	borde.material_override = mat_b
	borde.position = Vector3(0, 0.26, 0)
	add_child(borde)

	luz_indicador = OmniLight3D.new()
	luz_indicador.light_color = Color(0.25, 0.85, 1.0)
	luz_indicador.light_energy = 1.0
	luz_indicador.omni_range = 2.2
	luz_indicador.position = Vector3(0, 0.8, 0)
	add_child(luz_indicador)

	panel_etiqueta = Label3D.new()
	panel_etiqueta.name = "EtiquetaBandeja"
	panel_etiqueta.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	panel_etiqueta.no_depth_test = true
	panel_etiqueta.font_size = 20
	panel_etiqueta.outline_size = 5
	panel_etiqueta.outline_modulate = Color(0.05, 0.08, 0.12, 0.9)
	panel_etiqueta.modulate = Color(0.3, 0.9, 1.0, 1.0)
	panel_etiqueta.position = Vector3(0, 1.25, 0)
	panel_etiqueta.visible = false
	add_child(panel_etiqueta)

	contenedor_pilas = Node3D.new()
	contenedor_pilas.name = "PilaVisualPiezas"
	add_child(contenedor_pilas)

func puede_recibir() -> bool:
	return stock_actual < capacidad_maxima

func depositar_componente(tipo: String = "") -> bool:
	if not puede_recibir():
		return false

	stock_actual += 1
	if not tipo.is_empty():
		tipo_almacenado = tipo
	_animar_deposito()
	_actualizar_estado_visual()
	componente_depositado.emit(stock_actual)
	return true

func tiene_componentes() -> bool:
	return stock_actual > 0

func retirar_componente() -> String:
	if stock_actual <= 0:
		return ""

	stock_actual -= 1
	_actualizar_estado_visual()
	componente_retirado.emit(stock_actual)
	return tipo_almacenado

func _animar_deposito() -> void:
	if luz_indicador:
		var tw = create_tween()
		tw.tween_property(luz_indicador, "light_energy", 2.6, 0.15)
		tw.tween_property(luz_indicador, "light_energy", 1.0, 0.25)

func _actualizar_estado_visual() -> void:
	if not panel_etiqueta: return

	panel_etiqueta.text = "BANDEJA INTERMEDIA\n[ STOCK: %d / %d ]" % [stock_actual, capacidad_maxima]
	if stock_actual >= capacidad_maxima:
		panel_etiqueta.modulate = Color(1.0, 0.7, 0.2)
	elif stock_actual > 0:
		panel_etiqueta.modulate = Color(0.3, 1.0, 0.6)
	else:
		panel_etiqueta.modulate = Color(0.4, 0.8, 1.0)

	# Actualizar cilindros apilados
	if contenedor_pilas:
		for ch in contenedor_pilas.get_children():
			ch.queue_free()

		var a_mostrar = mini(stock_actual, 4)
		for i in range(a_mostrar):
			var mesh_inst = MeshInstance3D.new()
			var c_mesh = CylinderMesh.new()
			c_mesh.top_radius = 0.22
			c_mesh.bottom_radius = 0.22
			c_mesh.height = 0.12
			mesh_inst.mesh = c_mesh
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(0.2, 0.9, 0.8, 1.0)
			mat.emission_enabled = true
			mat.emission = Color(0.15, 0.8, 0.7, 1.0)
			mat.emission_energy_multiplier = 0.8
			mesh_inst.material_override = mat
			mesh_inst.position = Vector3(0, 0.32 + (i * 0.13), 0)
			contenedor_pilas.add_child(mesh_inst)
