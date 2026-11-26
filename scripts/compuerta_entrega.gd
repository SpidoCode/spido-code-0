class_name CompuertaEntrega
extends Node3D

signal robot_despachado(ganancia_creditos: int)

@export var celda: Vector2i = Vector2i(0, -3)
@export var recompensa_por_robot: int = 100

var base_marco: MeshInstance3D
var portal_holografico: MeshInstance3D
var luz_compuerta: OmniLight3D
var etiqueta_compuerta: Label3D
var robots_despachados_total: int = 0

func _ready() -> void:
	_construir_visuales()
	posicionar_en_celda(celda)

func posicionar_en_celda(p_celda: Vector2i) -> void:
	celda = p_celda
	position = Vector3(celda.x * 2.0, 0, celda.y * 2.0)

func _construir_visuales() -> void:
	# 1. Marco de la compuerta presurizada
	base_marco = MeshInstance3D.new()
	base_marco.name = "MarcoCompuerta"
	var torus = TorusMesh.new()
	torus.inner_radius = 0.85
	torus.outer_radius = 1.15
	base_marco.mesh = torus
	var mat_marco = StandardMaterial3D.new()
	mat_marco.albedo_color = Color(0.18, 0.22, 0.28, 1.0)
	mat_marco.metallic = 0.9
	mat_marco.roughness = 0.3
	base_marco.material_override = mat_marco
	base_marco.rotation_degrees = Vector3(90, 0, 0)
	base_marco.position = Vector3(0, 1.0, 0)
	add_child(base_marco)

	# 2. Portal holográfico de eyección
	portal_holografico = MeshInstance3D.new()
	portal_holografico.name = "CampoFuerza"
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.8
	cyl.bottom_radius = 0.8
	cyl.height = 0.05
	portal_holografico.mesh = cyl
	var mat_p = StandardMaterial3D.new()
	mat_p.albedo_color = Color(0.15, 0.9, 0.6, 0.6)
	mat_p.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_p.emission_enabled = true
	mat_p.emission = Color(0.2, 1.0, 0.65, 1.0)
	mat_p.emission_energy_multiplier = 2.0
	portal_holografico.material_override = mat_p
	portal_holografico.rotation_degrees = Vector3(90, 0, 0)
	portal_holografico.position = Vector3(0, 1.0, 0)
	add_child(portal_holografico)

	# 3. Luz ambiental del portal
	luz_compuerta = OmniLight3D.new()
	luz_compuerta.light_color = Color(0.2, 1.0, 0.7)
	luz_compuerta.light_energy = 2.2
	luz_compuerta.omni_range = 3.5
	luz_compuerta.position = Vector3(0, 1.2, 0)
	add_child(luz_compuerta)

	# 4. Etiqueta 3D
	etiqueta_compuerta = Label3D.new()
	etiqueta_compuerta.name = "EtiquetaCompuerta"
	etiqueta_compuerta.text = "COMPUERTA DE ENTREGA\n[ DESPACHO AL ESPACIO ]"
	etiqueta_compuerta.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	etiqueta_compuerta.no_depth_test = true
	etiqueta_compuerta.font_size = 22
	etiqueta_compuerta.outline_size = 6
	etiqueta_compuerta.outline_modulate = Color(0.05, 0.08, 0.12, 0.9)
	etiqueta_compuerta.modulate = Color(0.3, 1.0, 0.7, 1.0)
	etiqueta_compuerta.position = Vector3(0, 2.3, 0)
	add_child(etiqueta_compuerta)

func despachar_robot() -> void:
	robots_despachados_total += 1
	# Efecto visual de eyección continua
	if luz_compuerta:
		var tw = create_tween()
		tw.tween_property(luz_compuerta, "light_energy", 5.0, 0.2).set_trans(Tween.TRANS_BOUNCE)
		tw.tween_property(luz_compuerta, "light_energy", 2.2, 0.3)

	if etiqueta_compuerta:
		etiqueta_compuerta.text = "COMPUERTA DE ENTREGA\n[ ¡ROBOT DESPACHADO! +%d CR ]\nTotal Despachados: %d" % [recompensa_por_robot, robots_despachados_total]

	robot_despachado.emit(recompensa_por_robot)
