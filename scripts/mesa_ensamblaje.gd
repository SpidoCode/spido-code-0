class_name MesaEnsamblaje
extends Node3D

signal spid_actualizado(etapa: int, total: int, mensaje: String)
signal spid_completado
signal diagnostico_realizado

@export var celda_mesa: Vector2i = Vector2i(0, -2)

var etapas_completadas: Array[String] = []
var orden_esperado: Array[String] = ["CHASIS", "PATAS_DELANTERAS", "PATAS_TRASERAS", "SENSOR", "BRAZOS", "BATERIA"]
var diagnostico_ejecutado: bool = false

@onready var spid_chasis: MeshInstance3D = $SoporteSpid/SpidChasis
@onready var spid_ruedas: Node3D = $SoporteSpid/SpidRuedas
@onready var spid_sensor: MeshInstance3D = $SoporteSpid/SpidSensor
@onready var luz_plataforma: OmniLight3D = $LuzPlataforma
@onready var rueda_fl: MeshInstance3D = $SoporteSpid/SpidRuedas/RuedaFL
@onready var rueda_fr: MeshInstance3D = $SoporteSpid/SpidRuedas/RuedaFR
@onready var rueda_bl: MeshInstance3D = $SoporteSpid/SpidRuedas/RuedaBL
@onready var rueda_br: MeshInstance3D = $SoporteSpid/SpidRuedas/RuedaBR
var spid_brazos: Node3D = null
var spid_bateria: MeshInstance3D = null

func _ready() -> void:
	posicionar_en_celda(celda_mesa)
	_crear_componentes_extra_si_faltan()
	reiniciar()

func posicionar_en_celda(celda: Vector2i) -> void:
	celda_mesa = celda
	position = Vector3(celda.x * 2.0, 0, celda.y * 2.0)

func _crear_componentes_extra_si_faltan() -> void:
	var soporte = find_child("SoporteSpid", true, false)
	if not soporte: return

	# Crear Brazos
	if not spid_brazos:
		spid_brazos = Node3D.new()
		spid_brazos.name = "SpidBrazos"
		var mat_brazo = StandardMaterial3D.new()
		mat_brazo.albedo_color = Color(0.9, 0.6, 0.15, 1)
		mat_brazo.metallic = 0.5
		mat_brazo.roughness = 0.3

		var b_izq = MeshInstance3D.new()
		var mesh_b = BoxMesh.new()
		mesh_b.size = Vector3(0.18, 0.5, 0.18)
		b_izq.mesh = mesh_b
		b_izq.material_override = mat_brazo
		b_izq.position = Vector3(-0.72, 0.15, 0)
		spid_brazos.add_child(b_izq)

		var b_der = MeshInstance3D.new()
		b_der.mesh = mesh_b
		b_der.material_override = mat_brazo
		b_der.position = Vector3(0.72, 0.15, 0)
		spid_brazos.add_child(b_der)

		soporte.add_child(spid_brazos)

	# Crear Batería / Núcleo
	if not spid_bateria:
		spid_bateria = MeshInstance3D.new()
		spid_bateria.name = "SpidBateria"
		var mesh_bat = CylinderMesh.new()
		mesh_bat.top_radius = 0.18
		mesh_bat.bottom_radius = 0.18
		mesh_bat.height = 0.35
		var mat_bat = StandardMaterial3D.new()
		mat_bat.albedo_color = Color(0.15, 0.75, 0.95, 1)
		mat_bat.emission_enabled = true
		mat_bat.emission = Color(0.2, 0.85, 1.0, 1)
		mat_bat.emission_energy_multiplier = 2.5
		spid_bateria.mesh = mesh_bat
		spid_bateria.material_override = mat_bat
		spid_bateria.position = Vector3(0, 0.42, 0.35)
		soporte.add_child(spid_bateria)

func reiniciar() -> void:
	etapas_completadas.clear()
	diagnostico_ejecutado = false
	if spid_chasis: spid_chasis.visible = false
	if spid_ruedas: spid_ruedas.visible = true
	if rueda_fl: rueda_fl.visible = false
	if rueda_fr: rueda_fr.visible = false
	if rueda_bl: rueda_bl.visible = false
	if rueda_br: rueda_br.visible = false
	if spid_sensor: spid_sensor.visible = false
	if spid_brazos: spid_brazos.visible = false
	if spid_bateria: spid_bateria.visible = false
	if luz_plataforma:
		luz_plataforma.light_color = Color(0.2, 0.4, 0.3)
		luz_plataforma.light_energy = 0.5
	spid_actualizado.emit(0, orden_esperado.size(), "Mesa lista. Esperando montaje de Spido (0/6).")

func ensamblar_componente(_tipo: String = "") -> bool:
	var etapa = etapas_completadas.size()
	if etapa >= 6:
		return true

	etapas_completadas.append("PIEZA_%d" % (etapa + 1))
	var nueva_etapa = etapas_completadas.size()

	var tween = create_tween()
	match nueva_etapa:
		1:
			# 1/6: Chasis base
			if spid_chasis:
				spid_chasis.visible = true
				spid_chasis.scale = Vector3.ZERO
				tween.tween_property(spid_chasis, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if luz_plataforma:
				luz_plataforma.light_color = Color(0.3, 0.7, 0.4)
				luz_plataforma.light_energy = 1.0
			spid_actualizado.emit(1, 6, "1/6: Chasis de Spido fijado en el banco de montaje.")
		2:
			# 2/6: Extremidades delanteras
			if rueda_fl:
				rueda_fl.visible = true
				rueda_fl.scale = Vector3.ZERO
				tween.tween_property(rueda_fl, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if rueda_fr:
				rueda_fr.visible = true
				rueda_fr.scale = Vector3.ZERO
				tween.parallel().tween_property(rueda_fr, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if luz_plataforma:
				luz_plataforma.light_color = Color(0.2, 0.8, 0.9)
				luz_plataforma.light_energy = 1.3
			spid_actualizado.emit(2, 6, "2/6: Extremidades delanteras montadas.")
		3:
			# 3/6: Extremidades traseras
			if rueda_bl:
				rueda_bl.visible = true
				rueda_bl.scale = Vector3.ZERO
				tween.tween_property(rueda_bl, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if rueda_br:
				rueda_br.visible = true
				rueda_br.scale = Vector3.ZERO
				tween.parallel().tween_property(rueda_br, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if luz_plataforma:
				luz_plataforma.light_color = Color(0.2, 0.85, 0.85)
				luz_plataforma.light_energy = 1.5
			spid_actualizado.emit(3, 6, "3/6: Extremidades traseras montadas.")
		4:
			# 4/6: Sensor ocular A.D.A.
			if spid_sensor:
				spid_sensor.visible = true
				spid_sensor.scale = Vector3.ZERO
				tween.tween_property(spid_sensor, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if luz_plataforma:
				luz_plataforma.light_color = Color(0.9, 0.8, 0.2)
				luz_plataforma.light_energy = 1.8
			spid_actualizado.emit(4, 6, "4/6: Sensor óptico y procesador A.D.A. conectado.")
		5:
			# 5/6: Brazos manipuladores
			if spid_brazos:
				spid_brazos.visible = true
				spid_brazos.scale = Vector3.ZERO
				tween.tween_property(spid_brazos, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if luz_plataforma:
				luz_plataforma.light_color = Color(0.95, 0.5, 0.2)
				luz_plataforma.light_energy = 2.1
			spid_actualizado.emit(5, 6, "5/6: Brazos manipuladores acoplados con éxito.")
		6:
			# 6/6: Núcleo de energía / Batería
			if spid_bateria:
				spid_bateria.visible = true
				spid_bateria.scale = Vector3.ZERO
				tween.tween_property(spid_bateria, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			if luz_plataforma:
				luz_plataforma.light_color = Color(0.3, 1.0, 0.6)
				luz_plataforma.light_energy = 2.5
			spid_actualizado.emit(6, 6, "6/6: ¡Núcleo cargado y Spido completamente ensamblado!")

	await tween.finished

	if nueva_etapa >= 6:
		await _activar_spid()
		spid_completado.emit()
	elif nueva_etapa >= 3:
		_pulso_parcial()

	return true

func _pulso_parcial() -> void:
	if luz_plataforma:
		var tw = create_tween()
		tw.tween_property(luz_plataforma, "light_energy", 2.2, 0.2)
		tw.tween_property(luz_plataforma, "light_energy", 1.5, 0.2)

func _activar_spid() -> void:
	if luz_plataforma:
		var tw_luz = create_tween().set_loops(3)
		tw_luz.tween_property(luz_plataforma, "light_energy", 3.5, 0.2)
		tw_luz.tween_property(luz_plataforma, "light_energy", 1.5, 0.2)
		luz_plataforma.light_color = Color(0.2, 1.0, 0.5)

	var tw_spid = create_tween()
	tw_spid.tween_property($SoporteSpid, "position:y", 0.85, 0.2).set_trans(Tween.TRANS_SINE)
	tw_spid.tween_property($SoporteSpid, "position:y", 0.70, 0.2).set_trans(Tween.TRANS_BOUNCE)
	await tw_spid.finished

func probar_sistemas() -> bool:
	diagnostico_ejecutado = true
	diagnostico_realizado.emit()

	if luz_plataforma:
		luz_plataforma.light_color = Color(0.2, 1.0, 0.6)
		luz_plataforma.light_energy = 4.0

	var tw = create_tween().set_parallel(false)
	tw.tween_property($SoporteSpid, "position:y", 0.90, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property($SoporteSpid, "rotation:y", deg_to_rad(360), 0.8).as_relative()
	tw.tween_property($SoporteSpid, "position:y", 0.70, 0.25).set_trans(Tween.TRANS_BOUNCE)
	await tw.finished
	return true

func _obtener_siguiente_etapa() -> String:
	for req in orden_esperado:
		if req not in etapas_completadas:
			return req
	return ""
