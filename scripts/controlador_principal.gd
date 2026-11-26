class_name ControladorPrincipal
extends Control

@export var escena_bloque: PackedScene

# Contenedores UI con Scene Unique Nodes (%)
@onready var paleta_contenedor: VBoxContainer = %ListaBloques
@onready var lienzo: LienzoCodigo = %LienzoAstronauta1
@onready var lienzo_a2: LienzoCodigo = %LienzoAstronauta2
@onready var lienzo_a3: LienzoCodigo = %LienzoAstronauta3
@onready var lienzo_a4: LienzoCodigo = %LienzoAstronauta4
@onready var lienzo_a5: LienzoCodigo = %LienzoAstronauta5
@onready var lienzo_a6: LienzoCodigo = %LienzoAstronauta6
@onready var lienzo_a7: LienzoCodigo = %LienzoAstronauta7
@onready var lienzo_a8: LienzoCodigo = %LienzoAstronauta8
@onready var lienzo_a9: LienzoCodigo = %LienzoAstronauta9
@onready var lienzo_a10: LienzoCodigo = %LienzoAstronauta10
@onready var tabs_codigo: TabContainer = %EquipoCodigo
@onready var mundo_3d: Mundo3D = %Mundo3D

# Botones Superiores (Cápsulas Verdes)
@onready var btn_fases: Button = get_node_or_null("%BtnFases")
@onready var btn_tienda: Button = %BtnTienda
@onready var btn_codice: Button = %BtnCodice
@onready var btn_guia: Button = %BtnGuia

# Tarjeta de Misión / Fase
@onready var tarjeta_mision: PanelContainer = get_node_or_null("%TarjetaMision")
@onready var label_nivel_titulo: Label = %LabelNivelTitulo
@onready var btn_nivel_prev: Button = get_node_or_null("%BtnNivelPrev")
@onready var btn_nivel_next: Button = get_node_or_null("%BtnNivelNext")
@onready var label_concepto: Label = %LabelConcepto
@onready var label_mision_desc: Label = %LabelMisionDesc
@onready var label_estado_fase: Label = %LabelEstadoFase
@onready var barra_progreso_fase: ProgressBar = %BarraProgresoFase
@onready var label_progreso: Label = %LabelProgreso

# Badges Superiores Derechos
@onready var label_spido_piezas: Label = %LabelSpidoPiezas
@onready var label_creditos: Label = %LabelCreditos
@onready var oscurecedor_tienda: ColorRect = %OscurecedorTienda if has_node("%OscurecedorTienda") else null

# Terminal A.D.A.
@onready var btn_toggle_ada: Button = %BtnToggleADA
@onready var card_ada: PanelContainer = %CardADA
@onready var label_ada_texto: Label = %LabelADATexto

# Consola Flotante y Paleta Desplegable
@onready var consola_astronauta: PanelContainer = %ConsolaAstronauta
@onready var btn_minimizar_consola: Button = %BtnMinimizarConsola
@onready var btn_maximizar_consola: Button = get_node_or_null("%BtnMaximizarConsola")
@onready var handle_resize: Button = get_node_or_null("%HandleResize")
@onready var btn_abrir_consola_flotante: Button = %BtnAbrirConsolaFlotante
@onready var btn_toggle_paleta: Button = %BtnTogglePaleta
@onready var drawer_paleta: PanelContainer = %DrawerPaleta
@onready var btn_cerrar_paleta: Button = %BtnCerrarPaleta
@onready var btn_abrir_paleta_flotante: Button = %BtnAbrirPaletaFlotante

# Botones de Ejecución y Consola
@onready var btn_ejecutar: Button = %BtnEjecutar
@onready var btn_paso: Button = %BtnPaso
@onready var btn_reiniciar: Button = %BtnReiniciar
@onready var btn_limpiar: Button = %BtnLimpiar
@onready var btn_duplicar: Button = %BtnDuplicar
@onready var btn_velocidad: Button = %BtnVelocidad
@onready var btn_pista: Button = %BtnPista
@onready var label_estado: Label = %LabelEstado

# Modal Centro de Mejoras
@onready var modal_tienda: PanelContainer = %ModalTienda
@onready var label_saldo_tienda: Label = %LabelSaldoTienda
@onready var btn_cerrar_tienda: Button = %BtnCerrarTienda
@onready var grid_mejoras: GridContainer = %GridMejoras
@onready var lista_bloques: VBoxContainer = %ListaBloquesTienda
@onready var lista_astronautas: VBoxContainer = %ListaAstronautasTienda
@onready var lista_estaciones: VBoxContainer = %ListaEstacionesTienda

# Guía y Modales Auxiliares
@onready var panel_guia: PanelContainer = %PanelGuia
@onready var label_guia_texto: Label = %LabelGuiaTexto
@onready var btn_guia_continuar: Button = %BtnGuiaContinuar
@onready var panel_victoria: PanelContainer = %ModalVictoria
@onready var label_estrellas: Label = %LabelEstrellas
@onready var label_victoria_detalle: Label = %LabelDetalle
@onready var btn_modal_siguiente: Button = %BtnModalSiguiente
@onready var btn_modal_reintentar: Button = %BtnModalReintentar
@onready var fondo_menu_pausa: ColorRect = %FondoMenuPausa
@onready var menu_pausa: PanelContainer = %MenuPausa
@onready var btn_continuar: Button = %BtnContinuar
@onready var btn_volver_menu: Button = %BtnVolverMenu

const ESCENA_MENU_PRINCIPAL := "res://escenas/menu_inicio.tscn"
const HitosSandboxClass = preload("res://scripts/hitos_sandbox.gd")

var creditos: int = 0
var bloques_adquiridos: Array[String] = []
var astronautas_desbloqueados: Array[int] = [1]
var estaciones_desbloqueadas: Array[String] = ["MESON_PATAS"]
var mejoras_hardware_adquiridas: Array[String] = []

const ARBOL_MEJORAS = [
	# 1. BLOQUES DE ALGORITMIA
	{
		"fase": "BLOQUE BUCLE",
		"desc": "Repite tu algoritmo en bucle continuo de principio a fin. ¡El corazón de la automatización!",
		"costo": 20,
		"cat": "bloque",
		"id": "BLOQUE_BUCLE",
		"desbloquea_comando": "BUCLE",
		"indice_requerido": 1,
		"req_texto": "Requiere forjar Patas (Fase 1)"
	},
	{
		"fase": "BLOQUE GIRO 180°",
		"desc": "Da media vuelta en un solo paso algorítmico, ahorrando bloques en tu circuito de transporte.",
		"costo": 35,
		"cat": "bloque",
		"id": "BLOQUE_GIRO_180",
		"desbloquea_comando": "GIRO_180",
		"indice_requerido": 2,
		"req_texto": "Requiere automatizar Bucle (Fase 2)"
	},
	{
		"fase": "BLOQUE 3x AVANZAR",
		"desc": "Avanza 3 casillas de golpe a alta velocidad. Optimiza algoritmos en hangares amplios.",
		"costo": 45,
		"cat": "bloque",
		"id": "BLOQUE_AVZ_3",
		"desbloquea_comando": "AVANZAR_3",
		"indice_requerido": 3,
		"req_texto": "Requiere Fase 3"
	},

	# 2. ESPACIO Y TERRENO MODULAR (GDD §03: 3x3 -> 5x5 -> 7x7)
	{
		"fase": "TERRENO BASE 3x3",
		"desc": "Plataforma inicial de 3x3 casillas para abastecimiento y calibración.",
		"costo": 0,
		"cat": "espacio",
		"id": "ESPACIO_3X3",
		"tamano": 3,
		"indice_requerido": 0,
		"req_texto": "Inicial"
	},
	{
		"fase": "EXPANSIÓN TERRENO 5x5",
		"desc": "Expande el taller a 5x5 casillas para instalar la Máquina de Cinta y a Astro 2.",
		"costo": 40,
		"cat": "espacio",
		"id": "ESPACIO_5X5",
		"tamano": 5,
		"indice_requerido": 2,
		"req_texto": "Requiere Bucle Continuo (Fase 1)"
	},
	{
		"fase": "EXPANSIÓN TERRENO 7x7",
		"desc": "Expande el taller a 7x7 casillas para la Mesa de Ensamble Final y la Compuerta.",
		"costo": 70,
		"cat": "espacio",
		"id": "ESPACIO_7X7",
		"tamano": 7,
		"indice_requerido": 3,
		"req_texto": "Requiere Procesar en Cinta (Fase 2)"
	},

	# 3. ESTACIONES Y MAQUINARIA DE PRODUCCIÓN (GDD §03 & §04)
	{
		"fase": "MESA FABRICACIÓN INICIAL",
		"desc": "Mesa de manufactura inicial que procesa tuercas y crea piezas base para la nave.",
		"costo": 0,
		"cat": "estacion",
		"id": "MESON_PATAS",
		"indice_requerido": 0,
		"req_texto": "Inicial"
	},
	{
		"fase": "MÁQUINA DE CINTA AUTOMÁTICA",
		"desc": "Cinta transportadora continua con entrada y salida que procesa componentes de alta resistencia.",
		"costo": 30,
		"cat": "estacion",
		"id": "MAQUINA_CINTA",
		"indice_requerido": 2,
		"req_texto": "Requiere Expansión 5x5 (Fase 2)"
	},
	{
		"fase": "BANDEJA INTERMEDIA",
		"desc": "Almacén intermedio entre la salida de la cinta y la mesa de ensamble final.",
		"costo": 20,
		"cat": "estacion",
		"id": "BANDEJA_INTERMEDIA",
		"indice_requerido": 3,
		"req_texto": "Requiere Máquina de Cinta (Fase 2)"
	},
	{
		"fase": "MESA DE ENSAMBLE FINAL",
		"desc": "Banco central de montaje donde se ensambla y activa la estructura completa de Spido.",
		"costo": 45,
		"cat": "estacion",
		"id": "MESA_SPIDO",
		"indice_requerido": 3,
		"req_texto": "Requiere Expansión 7x7 (Fase 3)"
	},
	{
		"fase": "COMPUERTA DE ENTREGA",
		"desc": "Escotilla presurizada de despacho espacial. Cada robot despachado genera créditos continuos.",
		"costo": 50,
		"cat": "estacion",
		"id": "COMPUERTA_ENTREGA",
		"indice_requerido": 4,
		"req_texto": "Requiere Mesa de Ensamble Final (Fase 3)"
	},

	# 4. ASTRONAUTAS Y LÓGICA CONCURRENTE
	{
		"fase": "ASTRO 2: OPERADOR DE CINTA",
		"desc": "Despierta al 2º astronauta para alimentar la cinta automática y trasladar componentes.",
		"costo": 35,
		"cat": "astronauta",
		"id": "ASTRO_2",
		"astro_id": 2,
		"indice_requerido": 2,
		"req_texto": "Requiere Expansión 5x5 (Fase 2)"
	},
	{
		"fase": "ASTRO 3: ENSAMBLADOR FINAL",
		"desc": "Despierta al 3º astronauta para montar componentes en Spido y despachar a compuerta.",
		"costo": 60,
		"cat": "astronauta",
		"id": "ASTRO_3",
		"astro_id": 3,
		"indice_requerido": 4,
		"req_texto": "Requiere Expansión 7x7 (Fase 3)"
	},

	# 5. MEJORAS FÍSICAS Y HARDWARE (GDD §06)
	{
		"fase": "PROPULSORES RÁPIDOS",
		"desc": "Acelera la velocidad de paso y giro de todos los astronautas un 40%.",
		"costo": 40,
		"cat": "hardware",
		"id": "MEJORA_VELOCIDAD",
		"indice_requerido": 2,
		"req_texto": "Requiere Fase 2"
	},
	{
		"fase": "OVERCLOCK DE CINTA",
		"desc": "Reduce a la mitad el tiempo de procesamiento de la cinta transportadora.",
		"costo": 50,
		"cat": "hardware",
		"id": "MEJORA_CINTA",
		"indice_requerido": 3,
		"req_texto": "Requiere Máquina de Cinta"
	}
]

var hitos: Array[Dictionary] = []
var indice_hito_actual: int = 0
var hitos_completados: Array[int] = []

var en_ejecucion: bool = false
var detener_solicitado: bool = false
var factor_velocidad: int = 1
var indice_paso_actual: int = 0
var errores_durante_ejecucion: int = 0
var guia_activa: bool = false
var paso_guia: int = 0
var ultimo_error: String = ""
var bloque_con_error: BloqueItem = null
var ha_recogido_pieza_en_fase: bool = false

const PASOS_GUIA = [
	{"titulo": "1. OBSERVA", "texto": "Tu Astronauta Ingeniero está en la posición inicial y la baliza brillante marca la meta de calibración."},
	{"titulo": "2. PREDICE", "texto": "Cada bloque 'Avanzar' mueve al astronauta la cantidad de pasos configurada. Cuenta cuántas casillas hay hasta la baliza."},
	{"titulo": "3. CONSTRUYE", "texto": "Arrastra el bloque 'Avanzar' desde la paleta y selecciona el número de pasos deseado directamente en el bloque."},
	{"titulo": "4. EJECUTA & DEPURA", "texto": "Presiona 'Ejecutar' para correr tu algoritmo. También puedes usar 'Paso a Paso' para probar paso a paso."}
]

var consola_maximizada: bool = false
var redimensionando_consola: bool = false
var mouse_inicio_redimension_consola: Vector2 = Vector2.ZERO
var tamano_inicio_consola: Vector2 = Vector2.ZERO
const TAMANO_CONSOLA_NORMAL = Vector2(430.0, 680.0)
const TAMANO_CONSOLA_MAXIMA = Vector2(620.0, 840.0)
const TAMANO_CONSOLA_MINIMO = Vector2(360.0, 380.0)

const COMANDOS_DISPONIBLES = {
	"AVANZAR": {"tit": "Avanzar", "prefijo": "", "cat": "movimiento", "color": Color(0.545098, 0.796078, 0.568627, 1.0)},
	"AVANZAR_2": {"tit": "Avanzar 2", "prefijo": "", "cat": "movimiento", "color": Color(0.545098, 0.796078, 0.568627, 1.0)},
	"AVANZAR_3": {"tit": "Avanzar 3", "prefijo": "", "cat": "movimiento", "color": Color(0.545098, 0.796078, 0.568627, 1.0)},
	"RETROCEDER": {"tit": "Retroceder", "prefijo": "", "cat": "movimiento", "color": Color(0.545098, 0.796078, 0.568627, 1.0)},
	"GIRAR_DER": {"tit": "Girar Der", "prefijo": "", "cat": "giro", "color": Color(0.631373, 0.85098, 0.65098, 1.0)},
	"GIRAR_IZQ": {"tit": "Girar Izq", "prefijo": "", "cat": "giro", "color": Color(0.631373, 0.85098, 0.65098, 1.0)},
	"GIRO_180": {"tit": "Giro 180°", "prefijo": "", "cat": "giro", "color": Color(0.631373, 0.85098, 0.65098, 1.0)},
	"BUCLE": {"tit": "Bucle", "prefijo": "", "cat": "control", "color": Color(0.48, 0.55, 0.65, 1.0)},
	"TOMAR_PIEZA": {"tit": "Tomar Pieza", "prefijo": "", "cat": "accion", "color": Color(0.435294, 0.686275, 0.470588, 1.0)},
	"ENSAMBLAR": {"tit": "Depositar", "prefijo": "", "cat": "accion", "color": Color(0.435294, 0.686275, 0.470588, 1.0)},
	"DIAGNOSTICO": {"tit": "Diagnóstico", "prefijo": "", "cat": "accion", "color": Color(0.435294, 0.686275, 0.470588, 1.0)}
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	hitos = HitosSandboxClass.obtener_hitos()
	indice_hito_actual = 0
	hitos_completados.clear()
	_conectar_senales()

	tabs_codigo.set_tab_title(0, "Astro 1: Ingeniero")
	tabs_codigo.set_tab_title(1, "Astro 2: Tracción")
	tabs_codigo.set_tab_title(2, "Astro 3: Sensores")
	tabs_codigo.set_tab_title(3, "Astro 4: Brazos")
	tabs_codigo.set_tab_title(4, "Astro 5: Energía")
	for i in range(1, 10):
		tabs_codigo.set_tab_hidden(i, true)

	panel_victoria.visible = false
	fondo_menu_pausa.visible = false
	menu_pausa.visible = false
	if is_instance_valid(modal_tienda):
		modal_tienda.visible = false
	_plegar_paleta(false)
	_plegar_consola(false)
	if is_instance_valid(consola_astronauta):
		consola_astronauta.offset_left = -TAMANO_CONSOLA_NORMAL.x - 16.0
		consola_astronauta.offset_top = -TAMANO_CONSOLA_NORMAL.y - 16.0
		consola_astronauta.offset_right = -16.0
		consola_astronauta.offset_bottom = -16.0

	if is_instance_valid(btn_duplicar):
		btn_duplicar.visible = false
	actualizar_creditos_ui()
	_actualizar_badge_spido()
	_aplicar_hito_actual()

func _input(event: InputEvent) -> void:
	if redimensionando_consola:
		if event is InputEventMouseMotion:
			_redimensionar_consola(get_viewport().get_mouse_position())
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			redimensionando_consola = false

	if event.is_action_pressed("ui_cancel"):
		_cambiar_estado_pausa(not menu_pausa.visible)
		get_viewport().set_input_as_handled()

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11 or (event.keycode == KEY_ENTER and event.alt_pressed):
			var cur_mode = DisplayServer.window_get_mode()
			if cur_mode == DisplayServer.WINDOW_MODE_MAXIMIZED or cur_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			get_viewport().set_input_as_handled()

func cambiar_hito(indice: int) -> void:
	if indice < 0 or indice >= hitos.size():
		return
	indice_hito_actual = indice
	_aplicar_hito_actual(true)

func _aplicar_hito_actual(reposicionar_astros: bool = true) -> void:
	if indice_hito_actual < 0 or indice_hito_actual >= hitos.size():
		return
	ha_recogido_pieza_en_fase = false
	var hito = hitos[indice_hito_actual]

	# Cabecera de la Tarjeta de Misión
	label_nivel_titulo.text = hito.titulo.to_upper()
	label_concepto.text = hito.meta_texto.to_upper()
	if is_instance_valid(label_mision_desc):
		label_mision_desc.text = hito.descripcion
	label_ada_texto.text = hito.descripcion

	var total_hitos = max(1, hitos.size() - 1)
	var pct = int(round(float(indice_hito_actual) / float(total_hitos) * 100.0))
	if is_instance_valid(barra_progreso_fase):
		barra_progreso_fase.value = pct
	if is_instance_valid(label_progreso):
		label_progreso.text = "FASE %d/%d // Progresión (%d%%)" % [indice_hito_actual, total_hitos, pct]
	if is_instance_valid(label_estado_fase):
		var compl = (indice_hito_actual in hitos_completados)
		label_estado_fase.text = "COMPLETADO" if compl else "EN CURSO"
		label_estado_fase.modulate = Color(0.4, 0.95, 0.6) if compl else Color(0.35, 0.95, 0.55)

	if is_instance_valid(btn_nivel_prev):
		btn_nivel_prev.disabled = (indice_hito_actual == 0)
	if is_instance_valid(btn_nivel_next):
		btn_nivel_next.disabled = (indice_hito_actual == hitos.size() - 1)

	# Paleta de bloques disponibles
	_actualizar_paleta(_obtener_bloques_disponibles_actuales())

	# Visibilidad de pestañas según astronautas comprados en tienda
	for i in range(1, 10):
		var desbloqueado_por_tienda = astronautas_desbloqueados.has(i + 1)
		tabs_codigo.set_tab_hidden(i, not desbloqueado_por_tienda)

	# Configurar mundo 3D
	if mundo_3d:
		mundo_3d.config_nivel_actual = hito
		var tam_sector_hito = hito.get("tamano_sector", 5)
		var tam_final = max(tam_sector_hito, mundo_3d.tamano_sector_actual)
		mundo_3d.actualizar_sector(tam_final)

		# Mesa de Spido solo si fue comprada en tienda
		if mundo_3d.mesa_spid:
			mundo_3d.mesa_spid.posicionar_en_celda(hito.get("pos_mesa", Vector2i(2, 2)))
			mundo_3d.mesa_spid.visible = ("MESA_SPIDO" in estaciones_desbloqueadas)

		# Posición inicial solo al iniciar o resetear explícitamente
		if reposicionar_astros and mundo_3d.astronauta and hito.has("pos_astronauta"):
			mundo_3d.astronauta.configurar_inicio(hito.get("pos_astronauta", Vector2i(-1, 0)), hito.get("ori_astronauta", 2))

		if mundo_3d.baliza_meta:
			var mostrar_b = hito.get("mostrar_baliza", false)
			mundo_3d.baliza_meta.visible = mostrar_b
			if mostrar_b:
				mundo_3d.baliza_meta.posicionar_en_celda(hito.get("pos_baliza", Vector2i(0, -1)))

		# Activación de astronautas SOLAMENTE si fueron comprados en tienda
		if mundo_3d.astronauta_2:
			mundo_3d.astronauta_2.visible = (2 in astronautas_desbloqueados)
			if reposicionar_astros and (2 in astronautas_desbloqueados):
				var pos_a2 = hito.get("pos_astronauta_2", Vector2i(0, -1))
				var ori_a2 = hito.get("ori_astronauta_2", 0)
				mundo_3d.astronauta_2.configurar_inicio(pos_a2, ori_a2)
		if mundo_3d.astronauta_3:
			mundo_3d.astronauta_3.visible = (3 in astronautas_desbloqueados)
			if reposicionar_astros and (3 in astronautas_desbloqueados):
				var pos_a3 = hito.get("pos_astronauta_3", Vector2i(2, 1))
				var ori_a3 = hito.get("ori_astronauta_3", 2)
				mundo_3d.astronauta_3.configurar_inicio(pos_a3, ori_a3)
		if mundo_3d.astronauta_4:
			mundo_3d.astronauta_4.visible = (4 in astronautas_desbloqueados)
		if mundo_3d.astronauta_5:
			mundo_3d.astronauta_5.visible = (5 in astronautas_desbloqueados)

		# Estaciones y maquinaria según desbloqueo de tienda
		if mundo_3d.meson_patas:
			mundo_3d.meson_patas.visible = ("MESON_PATAS" in estaciones_desbloqueadas)
		if mundo_3d.maquina_cinta:
			mundo_3d.maquina_cinta.visible = ("MAQUINA_CINTA" in estaciones_desbloqueadas)
		if mundo_3d.bandeja_intermedia:
			mundo_3d.bandeja_intermedia.visible = ("BANDEJA_INTERMEDIA" in estaciones_desbloqueadas)
		if mundo_3d.compuerta_entrega:
			mundo_3d.compuerta_entrega.visible = ("COMPUERTA_ENTREGA" in estaciones_desbloqueadas)
		if mundo_3d.meson_sensores:
			mundo_3d.meson_sensores.visible = ("MESON_SENSORES" in estaciones_desbloqueadas)

		if reposicionar_astros and hito.has("piezas") and not hito.piezas.is_empty():
			mundo_3d._recrear_piezas(hito.piezas, true)

		if reposicionar_astros:
			if mundo_3d.astronauta:
				mundo_3d.astronauta.fijar_checkpoint_actual()
			if mundo_3d.astronauta_2 and mundo_3d.astronauta_2.visible:
				mundo_3d.astronauta_2.fijar_checkpoint_actual()
			if mundo_3d.astronauta_3 and mundo_3d.astronauta_3.visible:
				mundo_3d.astronauta_3.fijar_checkpoint_actual()

		mundo_3d.resaltar_astronauta_seleccionado(tabs_codigo.current_tab)

	_actualizar_badge_spido()
	_renderizar_centro_mejoras()
	_actualizar_estado("Mundo Nave Activo. Automatiza y programa a tus astronautas.")

func _obtener_bloques_disponibles_actuales() -> Array:
	if indice_hito_actual < 0 or indice_hito_actual >= hitos.size():
		return bloques_adquiridos
	var lista_base = hitos[indice_hito_actual].get("bloques_disponibles", ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"])
	var combinada = lista_base.duplicate()
	for b in bloques_adquiridos:
		if not combinada.has(b):
			combinada.append(b)
	return combinada

func _actualizar_paleta(bloques_permitidos: Array) -> void:
	for child in paleta_contenedor.get_children():
		child.queue_free()

	for id_cmd in bloques_permitidos:
		if COMANDOS_DISPONIBLES.has(id_cmd):
			var data = COMANDOS_DISPONIBLES[id_cmd]
			var bloque: BloqueItem
			if escena_bloque:
				bloque = escena_bloque.instantiate() as BloqueItem
			else:
				bloque = BloqueItem.new()

			var cat = data.get("cat", "movimiento")
			bloque.configurar(id_cmd, data.tit, data.prefijo, data.color, true, 1, cat)
			if not bloque.solicitado_anadir.is_connected(_on_bloque_paleta_anadido):
				bloque.solicitado_anadir.connect(_on_bloque_paleta_anadido)
			paleta_contenedor.add_child(bloque)

func _on_bloque_paleta_anadido(item_paleta: BloqueItem) -> void:
	var idx = tabs_codigo.current_tab
	var lienzos = [lienzo, lienzo_a2, lienzo_a3, lienzo_a4, lienzo_a5]
	if idx >= 0 and idx < lienzos.size():
		var l: LienzoCodigo = lienzos[idx]
		l.agregar_comando(
			item_paleta.id_comando,
			item_paleta.parametro_valor,
			item_paleta.titulo,
			item_paleta.prefijo,
			item_paleta.categoria,
			item_paleta.color_borde
		)
		_actualizar_estado("Bloque '%s' añadido al Astronauta %d." % [item_paleta.titulo, idx + 1])

func _conectar_senales() -> void:
	btn_ejecutar.pressed.connect(_on_ejecutar_pressed)
	btn_paso.pressed.connect(_on_paso_pressed)
	btn_reiniciar.pressed.connect(_on_reiniciar_pressed)
	btn_limpiar.pressed.connect(_on_limpiar_pressed)
	btn_duplicar.pressed.connect(_on_duplicar_pressed)
	if btn_velocidad:
		btn_velocidad.pressed.connect(_on_velocidad_pressed)

	if btn_fases and tarjeta_mision:
		btn_fases.pressed.connect(func():
			tarjeta_mision.visible = not tarjeta_mision.visible
			btn_fases.text = "FASES  ▲" if tarjeta_mision.visible else "FASES  ▼"
		)

	if btn_tienda:
		btn_tienda.pressed.connect(func(): _abrir_tienda(true))
	if btn_cerrar_tienda:
		btn_cerrar_tienda.pressed.connect(func(): _abrir_tienda(false))

	if btn_codice:
		btn_codice.pressed.connect(_on_btn_codice_pressed)
	if btn_guia:
		btn_guia.pressed.connect(func(): panel_guia.visible = not panel_guia.visible)

	if btn_toggle_ada:
		btn_toggle_ada.pressed.connect(func():
			card_ada.visible = not card_ada.visible
			btn_toggle_ada.text = "SISTEMA ADA  ▲" if card_ada.visible else "SISTEMA ADA  ▼"
		)

	if btn_cerrar_paleta:
		btn_cerrar_paleta.pressed.connect(func(): _plegar_paleta(true))
	if btn_abrir_paleta_flotante:
		btn_abrir_paleta_flotante.pressed.connect(func(): _plegar_paleta(false))
	if btn_toggle_paleta:
		btn_toggle_paleta.pressed.connect(func():
			if is_instance_valid(drawer_paleta):
				_plegar_paleta(drawer_paleta.visible)
		)

	if btn_minimizar_consola:
		btn_minimizar_consola.pressed.connect(func(): _plegar_consola(true))
	if btn_maximizar_consola:
		btn_maximizar_consola.pressed.connect(_toggle_maximizar_consola)
	if handle_resize:
		handle_resize.gui_input.connect(_on_handle_resize_gui_input)
	if btn_abrir_consola_flotante:
		btn_abrir_consola_flotante.pressed.connect(func(): _plegar_consola(false))

	if is_instance_valid(btn_nivel_prev):
		btn_nivel_prev.pressed.connect(func(): cambiar_hito(indice_hito_actual - 1))
	if is_instance_valid(btn_nivel_next):
		btn_nivel_next.pressed.connect(func(): cambiar_hito(indice_hito_actual + 1))

	btn_modal_siguiente.pressed.connect(_on_modal_siguiente_pressed)
	btn_modal_reintentar.pressed.connect(_on_modal_reintentar_pressed)
	btn_guia_continuar.pressed.connect(_on_guia_continuar_pressed)
	btn_pista.pressed.connect(_on_pista_pressed)
	btn_continuar.pressed.connect(_on_continuar_pressed)
	btn_volver_menu.pressed.connect(_on_volver_menu_pressed)
	btn_pista.disabled = true
	tabs_codigo.tab_changed.connect(_on_tab_codigo_changed)

	if mundo_3d:
		if mundo_3d.has_signal("tuerca_depositada"):
			mundo_3d.tuerca_depositada.connect(func(_tot):
				ganar_creditos(10, "¡Tuerca depositada en contenedor!")
			)

		if mundo_3d.mesa_spid:
			mundo_3d.mesa_spid.spid_actualizado.connect(func(_e, _t, _m):
				_actualizar_badge_spido()
			)
			mundo_3d.mesa_spid.spid_completado.connect(func():
				_actualizar_badge_spido()
			)
			mundo_3d.mesa_spid.diagnostico_realizado.connect(func():
				if not en_ejecucion: _verificar_hitos_sandbox()
			)

		if mundo_3d.meson_patas:
			mundo_3d.meson_patas.insumo_recibido.connect(func(_t, act, req): ganar_creditos(15, "Insumo depositado en Mesa Inicial (%d/%d)" % [act, req]))
			mundo_3d.meson_patas.producto_fabricado.connect(func(prod): ganar_creditos(25, "¡Pieza Base fabricada (%s) en Mesa Inicial!" % prod))
		if mundo_3d.maquina_cinta:
			mundo_3d.maquina_cinta.pieza_procesada.connect(func(prod):
				ganar_creditos(30, "¡%s forjado en la Cinta Automática!" % prod)
				_verificar_hitos_sandbox(true)
			)
		if mundo_3d.bandeja_intermedia:
			mundo_3d.bandeja_intermedia.componente_depositado.connect(func(stock):
				ganar_creditos(20, "Componente asegurado en Bandeja Intermedia (%d)" % stock)
				_verificar_hitos_sandbox(true)
			)
		if mundo_3d.compuerta_entrega:
			mundo_3d.compuerta_entrega.robot_despachado.connect(func(recompensa):
				ganar_creditos(recompensa, "¡ROBOT SPIDO DESPACHADO! Producción continua recibida")
				if mundo_3d.mesa_spid:
					mundo_3d.mesa_spid.reiniciar()
				_actualizar_badge_spido()
				_verificar_hitos_sandbox(true)
			)
		if mundo_3d.meson_sensores:
			mundo_3d.meson_sensores.insumo_recibido.connect(func(_t, act, req): ganar_creditos(15, "Insumo depositado en Mesón de Sensores (%d/%d)" % [act, req]))
			mundo_3d.meson_sensores.producto_fabricado.connect(func(prod): ganar_creditos(25, "¡%s fabricado en Mesón de Sensores!" % prod))

		var todos_astros = [
			mundo_3d.astronauta, mundo_3d.astronauta_2, mundo_3d.astronauta_3,
			mundo_3d.astronauta_4, mundo_3d.astronauta_5
		]
		for a in todos_astros:
			if a:
				a.accion_fallida.connect(_on_accion_fallida)
				a.pieza_recogida.connect(func(nom):
					_on_pieza_recogida(nom)
				)
				a.pieza_ensamblada.connect(func(tipo): 
					_on_pieza_ensamblada(tipo)
					_actualizar_badge_spido()
				)

func _actualizar_badge_spido() -> void:
	if not is_instance_valid(label_spido_piezas):
		return
	var montadas = 0
	if mundo_3d and mundo_3d.mesa_spid:
		montadas = mundo_3d.mesa_spid.etapas_completadas.size()
	label_spido_piezas.text = "%d/6" % montadas

func _plegar_paleta(plegar: bool) -> void:
	if is_instance_valid(drawer_paleta):
		drawer_paleta.visible = not plegar
	if is_instance_valid(btn_abrir_paleta_flotante):
		btn_abrir_paleta_flotante.visible = plegar
	if is_instance_valid(btn_toggle_paleta):
		btn_toggle_paleta.text = "BLOQUES"

func _plegar_consola(plegar: bool) -> void:
	if is_instance_valid(consola_astronauta):
		consola_astronauta.visible = not plegar
	if is_instance_valid(btn_abrir_consola_flotante):
		btn_abrir_consola_flotante.visible = plegar

func _on_handle_resize_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		redimensionando_consola = event.pressed
		if redimensionando_consola:
			mouse_inicio_redimension_consola = get_viewport().get_mouse_position()
			tamano_inicio_consola = Vector2(-consola_astronauta.offset_left - 16.0, -consola_astronauta.offset_top - 16.0)
		get_viewport().set_input_as_handled()

func _redimensionar_consola(mouse_actual: Vector2) -> void:
	if not is_instance_valid(consola_astronauta):
		return
	var delta = mouse_actual - mouse_inicio_redimension_consola
	var pantalla = get_viewport().get_visible_rect().size
	var nuevo_ancho = clampf(tamano_inicio_consola.x - delta.x, TAMANO_CONSOLA_MINIMO.x, pantalla.x - 32.0)
	var nuevo_alto = clampf(tamano_inicio_consola.y - delta.y, TAMANO_CONSOLA_MINIMO.y, pantalla.y - 32.0)
	consola_astronauta.offset_left = -nuevo_ancho - 16.0
	consola_astronauta.offset_top = -nuevo_alto - 16.0
	consola_astronauta.offset_right = -16.0
	consola_astronauta.offset_bottom = -16.0

func _toggle_maximizar_consola() -> void:
	consola_maximizada = not consola_maximizada
	var destino = TAMANO_CONSOLA_MAXIMA if consola_maximizada else TAMANO_CONSOLA_NORMAL
	if is_instance_valid(btn_maximizar_consola):
		btn_maximizar_consola.text = "REDUCIR" if consola_maximizada else "EXPANDIR"
	if is_instance_valid(consola_astronauta):
		var tween = create_tween().set_parallel(true)
		tween.tween_property(consola_astronauta, "offset_left", -destino.x - 16.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(consola_astronauta, "offset_top", -destino.y - 16.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_btn_codice_pressed() -> void:
	if is_instance_valid(panel_guia):
		label_guia_texto.text = "CÓDICE DE LA NAVE SPIDO:\n\n• Cada astronauta obedece la secuencia de su pestaña en la consola.\n• Ajusta los pasos en el bloque 'Avanzar' directamente con los controles +/-.\n• Activa 'Bucle' para automatizar un transporte continuo A <-> B.\n• En 'MEJORAS' puedes ampliar la nave y activar más operarios."
		panel_guia.visible = true

func _cambiar_estado_pausa(pausado: bool) -> void:
	fondo_menu_pausa.visible = pausado
	menu_pausa.visible = pausado
	get_tree().paused = pausado
	if pausado:
		btn_continuar.grab_focus()

func _on_continuar_pressed() -> void:
	_cambiar_estado_pausa(false)

func _on_volver_menu_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().change_scene_to_file(ESCENA_MENU_PRINCIPAL)

func _tiene_bloque_bucle_activo(secuencias: Array) -> bool:
	for sec in secuencias:
		for b in sec:
			if is_instance_valid(b) and b is BloqueItem and b.id_comando == "BUCLE":
				return true
	return false

func _on_ejecutar_pressed() -> void:
	if en_ejecucion:
		detener_solicitado = true
		_actualizar_estado("Deteniendo automatización...")
		btn_ejecutar.text = "Deteniendo..."
		return

	var secuencias = [
		lienzo.obtener_secuencia_comandos(),
		lienzo_a2.obtener_secuencia_comandos(),
		lienzo_a3.obtener_secuencia_comandos(),
		lienzo_a4.obtener_secuencia_comandos(),
		lienzo_a5.obtener_secuencia_comandos()
	]

	var hay_instrucciones = false
	for sec in secuencias:
		if not sec.is_empty():
			hay_instrucciones = true
			break

	if not hay_instrucciones:
		_actualizar_estado("Los lienzos están vacíos. Arrastra bloques de instrucciones para programar al equipo.")
		return

	en_ejecucion = true
	detener_solicitado = false
	_limpiar_error()
	errores_durante_ejecucion = 0
	ultimo_error = ""
	btn_ejecutar.text = "Detener"
	btn_ejecutar.modulate = Color(0.9, 0.4, 0.4)
	_bloquear_interfaz(true)
	btn_ejecutar.disabled = false

	# Resaltar bloque de inicio estilo Scratch al comenzar ejecución
	for l in [lienzo, lienzo_a2, lienzo_a3, lienzo_a4, lienzo_a5]:
		if is_instance_valid(l) and l.has_method("resaltar_inicio"):
			l.resaltar_inicio(true)
	await get_tree().create_timer(0.15).timeout
	for l in [lienzo, lienzo_a2, lienzo_a3, lienzo_a4, lienzo_a5]:
		if is_instance_valid(l) and l.has_method("resaltar_inicio"):
			l.resaltar_inicio(false)

	var ciclo = 1
	var astronautas = [
		mundo_3d.astronauta, mundo_3d.astronauta_2, mundo_3d.astronauta_3,
		mundo_3d.astronauta_4, mundo_3d.astronauta_5
	]

	while true:
		if detener_solicitado:
			break

		_actualizar_estado("Ejecutando algoritmos del equipo (Ciclo %d)..." % ciclo)
		var exito_ciclo = await _ejecutar_un_ciclo(astronautas)

		if not exito_ciclo:
			break

		# Actualizar lectura de secuencias para verificar si el usuario incluyó el bloque [LOOP] Bucle Continuo
		secuencias = [
			lienzo.obtener_secuencia_comandos(),
			lienzo_a2.obtener_secuencia_comandos(),
			lienzo_a3.obtener_secuencia_comandos(),
			lienzo_a4.obtener_secuencia_comandos(),
			lienzo_a5.obtener_secuencia_comandos()
		]

		var tiene_bucle = _tiene_bloque_bucle_activo(secuencias)
		if not tiene_bucle or detener_solicitado:
			break

		ciclo += 1
		await get_tree().create_timer(0.2).timeout

	en_ejecucion = false
	detener_solicitado = false
	btn_ejecutar.text = "EJECUTAR"
	btn_ejecutar.modulate = Color.WHITE
	_bloquear_interfaz(false)

	if errores_durante_ejecucion == 0:
		_actualizar_estado("Ejecución completada sin errores.")
	_verificar_hitos_sandbox()

func _ejecutar_un_ciclo(astronautas: Array) -> bool:
	var secuencias = [
		lienzo.obtener_secuencia_comandos(),
		lienzo_a2.obtener_secuencia_comandos(),
		lienzo_a3.obtener_secuencia_comandos(),
		lienzo_a4.obtener_secuencia_comandos(),
		lienzo_a5.obtener_secuencia_comandos()
	]

	var max_pasos = 0
	for sec in secuencias:
		max_pasos = max(max_pasos, sec.size())

	for paso in range(max_pasos):
		if detener_solicitado:
			return false

		# Lectura dinámica de secuencias para permitir cambios en vivo
		secuencias = [
			lienzo.obtener_secuencia_comandos(),
			lienzo_a2.obtener_secuencia_comandos(),
			lienzo_a3.obtener_secuencia_comandos(),
			lienzo_a4.obtener_secuencia_comandos(),
			lienzo_a5.obtener_secuencia_comandos()
		]

		for idx in range(min(astronautas.size(), secuencias.size())):
			var astro: AstronautaIngeniero = astronautas[idx]
			var sec: Array = secuencias[idx]
			if paso >= sec.size() or not astro.visible or sec.is_empty():
				continue

			var bloque: BloqueItem = sec[paso]
			bloque.resaltar_ejecucion(true)
			var ok = await astro.ejecutar_accion(bloque.id_comando, bloque.parametro_valor)
			bloque.resaltar_ejecucion(false)

			if not ok:
				errores_durante_ejecucion += 1
				bloque.resaltar_error(true)
				bloque_con_error = bloque
				_actualizar_estado("[ALERTA] %s se detuvo: %s" % [astro.nombre_rol, ultimo_error if not ultimo_error.is_empty() else "Acción bloqueada."])
				return false

		await get_tree().create_timer(0.06).timeout

	return true

func _on_duplicar_pressed() -> void:
	if en_ejecucion: return
	var lienzos = [lienzo, lienzo_a2, lienzo_a3, lienzo_a4, lienzo_a5]
	var idx = tabs_codigo.current_tab
	if idx >= 0 and idx < lienzos.size():
		var ok = lienzos[idx].duplicar_secuencia()
		if ok:
			_actualizar_estado("Secuencia algorítmica duplicada para Astronauta %d." % (idx + 1))

func _on_velocidad_pressed() -> void:
	match factor_velocidad:
		1:
			factor_velocidad = 2
			Engine.time_scale = 1.8
			btn_velocidad.text = "2x"
			btn_velocidad.modulate = Color(0.35, 0.95, 0.65)
		2:
			factor_velocidad = 3
			Engine.time_scale = 2.8
			btn_velocidad.text = "3x"
			btn_velocidad.modulate = Color(1.0, 0.85, 0.3)
		3:
			factor_velocidad = 1
			Engine.time_scale = 1.0
			btn_velocidad.text = "1x"
			btn_velocidad.modulate = Color.WHITE

func _on_paso_pressed() -> void:
	if en_ejecucion: return

	var astronautas = [
		mundo_3d.astronauta, mundo_3d.astronauta_2, mundo_3d.astronauta_3,
		mundo_3d.astronauta_4, mundo_3d.astronauta_5
	]
	var lienzos = [lienzo, lienzo_a2, lienzo_a3, lienzo_a4, lienzo_a5]

	var idx_actual = tabs_codigo.current_tab
	if idx_actual < 0 or idx_actual >= astronautas.size():
		return

	var astronauta_actual: AstronautaIngeniero = astronautas[idx_actual]
	var lienzo_actual: LienzoCodigo = lienzos[idx_actual]
	var secuencia = lienzo_actual.obtener_secuencia_comandos()

	if secuencia.is_empty():
		_actualizar_estado("El lienzo de %s está vacío." % astronauta_actual.nombre_rol)
		return

	if indice_paso_actual >= secuencia.size():
		indice_paso_actual = 0
		_limpiar_resaltados(secuencia)

	var bloque: BloqueItem = secuencia[indice_paso_actual]
	_limpiar_resaltados(secuencia)

	en_ejecucion = true
	_limpiar_error()
	_bloquear_interfaz(true)
	bloque.resaltar_ejecucion(true)

	var exito = await astronauta_actual.ejecutar_accion(bloque.id_comando, bloque.parametro_valor)
	await get_tree().create_timer(0.08).timeout
	bloque.resaltar_ejecucion(false)
	if not exito:
		errores_durante_ejecucion += 1
		bloque.resaltar_error(true)
		bloque_con_error = bloque
		_actualizar_estado("[ERROR] Paso manual: %s" % (ultimo_error if not ultimo_error.is_empty() else "La acción no pudo completarse."))

	indice_paso_actual += 1
	en_ejecucion = false
	_bloquear_interfaz(false)
	if indice_paso_actual >= secuencia.size():
		_verificar_hitos_sandbox()

func _on_reiniciar_pressed() -> void:
	if en_ejecucion:
		detener_solicitado = true
		await get_tree().create_timer(0.15).timeout

	_limpiar_error()
	indice_paso_actual = 0

	var secuencias = [
		lienzo.obtener_secuencia_comandos(),
		lienzo_a2.obtener_secuencia_comandos(),
		lienzo_a3.obtener_secuencia_comandos(),
		lienzo_a4.obtener_secuencia_comandos(),
		lienzo_a5.obtener_secuencia_comandos()
	]
	for sec in secuencias:
		_limpiar_resaltados(sec)

	if mundo_3d:
		mundo_3d.config_nivel_actual = hitos[indice_hito_actual]
		await mundo_3d.reiniciar_mundo(true)
		mundo_3d.resaltar_astronauta_seleccionado(tabs_codigo.current_tab)

	_actualizar_estado("Vuelta a base: astronautas restablecidos en sus posiciones.")

func _on_limpiar_pressed() -> void:
	if en_ejecucion: return
	var lienzos = [lienzo, lienzo_a2, lienzo_a3, lienzo_a4, lienzo_a5]
	var idx = tabs_codigo.current_tab
	if idx >= 0 and idx < lienzos.size():
		lienzos[idx].limpiar()
		_actualizar_estado("Lienzo del Astronauta %d limpiado." % (idx + 1))

func _on_tab_codigo_changed(tab_idx: int) -> void:
	if mundo_3d:
		mundo_3d.resaltar_astronauta_seleccionado(tab_idx)
	var nombres = ["Ingeniero", "Tracción", "Sensores", "Brazos", "Energía"]
	var rol = nombres[tab_idx] if tab_idx < nombres.size() else "Operador"
	_actualizar_estado("Editando algoritmo para Astronauta %d: %s." % [tab_idx + 1, rol])

func _verificar_hitos_sandbox(forzar: bool = false) -> void:
	if en_ejecucion and not forzar:
		return
	if indice_hito_actual < 0 or indice_hito_actual >= hitos.size():
		return
	var hito = hitos[indice_hito_actual]
	var completado = false

	match hito.tipo_meta:
		"BALIZA":
			if mundo_3d and mundo_3d.baliza_meta:
				var pos_a = Vector2i(mundo_3d.astronauta.grid_x, mundo_3d.astronauta.grid_z)
				var pos_b = hito.get("pos_baliza", Vector2i(0, -1))
				if pos_a == pos_b:
					mundo_3d.baliza_meta.activar_exito()
					completado = true
		"TOMAR_PIEZA":
			if ha_recogido_pieza_en_fase or (mundo_3d and mundo_3d.astronauta and is_instance_valid(mundo_3d.astronauta.pieza_en_mano)):
				completado = true
		"DEPOSITAR_INSUMO":
			if mundo_3d and mundo_3d.meson_patas and (mundo_3d.meson_patas.insumos_actuales >= 1 or mundo_3d.meson_patas.producto_disponible):
				completado = true
			elif mundo_3d and mundo_3d.tuercas_recolectadas_sesion >= 1:
				completado = true
		"FABRICAR_PATAS":
			if mundo_3d and mundo_3d.meson_patas and (mundo_3d.meson_patas.producto_disponible or mundo_3d.meson_patas.insumos_actuales >= 2):
				completado = true
		"DEPOSITAR_TUERCA":
			if mundo_3d and mundo_3d.tuercas_recolectadas_sesion >= 1:
				completado = true
		"ACTIVAR_BUCLE":
			var secuencias_actuales = [
				lienzo.obtener_secuencia_comandos(),
				lienzo_a2.obtener_secuencia_comandos(),
				lienzo_a3.obtener_secuencia_comandos(),
				lienzo_a4.obtener_secuencia_comandos(),
				lienzo_a5.obtener_secuencia_comandos()
			]
			if (bloques_adquiridos.has("BUCLE") or bloques_adquiridos.has("BLOQUE_BUCLE")) and _tiene_bloque_bucle_activo(secuencias_actuales):
				if mundo_3d and mundo_3d.meson_patas and mundo_3d.meson_patas.productos_almacenados >= 2:
					completado = true
		"COMPRAR_EXPANSION_5X5":
			if mundo_3d and mundo_3d.tamano_sector_actual >= 5:
				completado = true
		"PROCESAR_CINTA":
			if mundo_3d:
				if (mundo_3d.maquina_cinta and mundo_3d.maquina_cinta.productos_almacenados >= 1) or (mundo_3d.bandeja_intermedia and mundo_3d.bandeja_intermedia.stock_actual >= 1):
					completado = true
		"DESPACHO_COMPUERTA":
			if mundo_3d and mundo_3d.compuerta_entrega and mundo_3d.compuerta_entrega.robots_despachados_total >= 1:
				completado = true
		"ENSAMBLAR":
			if mundo_3d and mundo_3d.mesa_spid:
				completado = (mundo_3d.mesa_spid.etapas_completadas.size() >= hito.get("piezas_requeridas", 1))
		"SUBENSAMBLAJE":
			if mundo_3d and mundo_3d.meson_patas and mundo_3d.meson_patas.cantidad_actual >= 1:
				completado = true
		"CADENA_PRODUCCION":
			if mundo_3d and mundo_3d.mesa_spid:
				completado = (mundo_3d.mesa_spid.etapas_completadas.size() >= 2)
		"DIAGNOSTICO":
			if mundo_3d and mundo_3d.mesa_spid and (mundo_3d.mesa_spid.diagnostico_ejecutado or mundo_3d.mesa_spid.get("diagnostico_ok")):
				completado = true

	if completado and not (indice_hito_actual in hitos_completados):
		hitos_completados.append(indice_hito_actual)
		_celebrar_hito(hito)

func _celebrar_hito(hito: Dictionary) -> void:
	if not (indice_hito_actual in hitos_completados):
		hitos_completados.append(indice_hito_actual)

	var recompensa = hito.get("recompensa_creditos", 20)
	ganar_creditos(recompensa, "¡Objetivo cumplido: %s!" % hito.titulo)

	if is_instance_valid(label_estado_fase):
		label_estado_fase.text = "COMPLETADO"
		label_estado_fase.modulate = Color(0.4, 0.95, 0.6)

	# Si es el último hito del juego, celebramos la victoria final con el modal de Spido
	if indice_hito_actual >= hitos.size() - 1:
		en_ejecucion = false
		detener_solicitado = true
		btn_ejecutar.text = "EJECUTAR"
		btn_ejecutar.modulate = Color.WHITE
		_bloquear_interfaz(false)
		if is_instance_valid(label_victoria_detalle):
			label_victoria_detalle.text = "%s\n\n¡Has completado el ensamblaje autónomo y Spido está 100% operativo!" % hito.get("mensaje_ada", "¡Excelente!")
		panel_victoria.visible = true
		return

	# Notificación suave de A.D.A. sin detener la ejecución (progreso continuo tipo The Farmer Was Replaced)
	_mostrar_notificacion_hito(hito)

	# Avanzar suavemente al siguiente objetivo sin reiniciar el mundo ni los astronautas
	indice_hito_actual += 1
	_aplicar_hito_actual(false)

func _mostrar_notificacion_hito(hito: Dictionary) -> void:
	var msg = hito.get("mensaje_ada", "¡Excelente trabajo!")
	label_ada_texto.text = msg
	_actualizar_estado("¡Objetivo completado! (+%d Tuercas). Nuevas mejoras desbloqueadas en MEJORAS." % hito.get("recompensa_creditos", 20))

	# Efecto visual en tarjeta A.D.A.
	if is_instance_valid(card_ada):
		var tw = create_tween()
		tw.tween_property(card_ada, "modulate", Color(1.3, 1.8, 1.3), 0.15)
		tw.tween_property(card_ada, "modulate", Color.WHITE, 0.3)

func _on_modal_siguiente_pressed() -> void:
	panel_victoria.visible = false
	_actualizar_estado("¡Hangar completado! Spido está ensamblado y operativo.")

func _on_modal_reintentar_pressed() -> void:
	panel_victoria.visible = false
	panel_victoria.visible = false

func _on_pista_pressed() -> void:
	if indice_hito_actual < 0 or indice_hito_actual >= hitos.size(): return
	var hito = hitos[indice_hito_actual]
	var pista = hito.get("pista", "Verifica la secuencia de bloques en la consola.")
	_actualizar_estado("[PISTA A.D.A.] %s" % pista)
	label_ada_texto.text = pista

func _on_guia_continuar_pressed() -> void:
	panel_guia.visible = false

func _on_accion_fallida(motivo: String) -> void:
	ultimo_error = motivo
	_actualizar_estado("[ALERTA] %s" % motivo)

func _on_pieza_recogida(tipo: String) -> void:
	ha_recogido_pieza_en_fase = true
	_actualizar_estado("Pieza %s asegurada en manos del astronauta." % tipo)

func _on_pieza_ensamblada(tipo: String) -> void:
	ganar_creditos(30, "¡%s acoplada en Spido!" % tipo)
	_actualizar_badge_spido()
	_verificar_hitos_sandbox(true)

func ganar_creditos(cantidad: int, motivo: String = "") -> void:
	creditos += cantidad
	actualizar_creditos_ui()
	if not motivo.is_empty():
		_actualizar_estado("%s (+%d Tuercas)" % [motivo, cantidad])

func actualizar_creditos_ui() -> void:
	if is_instance_valid(label_creditos):
		label_creditos.text = "%d" % creditos
	if is_instance_valid(label_saldo_tienda):
		label_saldo_tienda.text = "Saldo: %d Tuercas" % creditos

func _abrir_tienda(abrir: bool) -> void:
	if is_instance_valid(oscurecedor_tienda):
		oscurecedor_tienda.visible = abrir
	if is_instance_valid(modal_tienda):
		modal_tienda.visible = abrir
		if abrir:
			actualizar_creditos_ui()
			_renderizar_centro_mejoras()

func _esta_mejora_desbloqueada(item: Dictionary) -> bool:
	match item.cat:
		"bloque":
			var cmd = item.get("desbloquea_comando", "")
			return bloques_adquiridos.has(cmd)
		"espacio":
			var tam = item.get("tamano", 5)
			if mundo_3d:
				return mundo_3d.tamano_sector_actual >= tam
			return false
		"estacion":
			return item.id in estaciones_desbloqueadas
		"astronauta":
			var a_id = item.get("astro_id", 2)
			return a_id in astronautas_desbloqueados
		"hardware":
			return mejoras_hardware_adquiridas.has(item.id)
	return false

func _esta_mejora_disponible_para_compra(item: Dictionary) -> bool:
	var req_idx = item.get("indice_requerido", 0)
	if req_idx <= 0:
		return true
	return (req_idx in hitos_completados) or (indice_hito_actual >= req_idx)

func _renderizar_centro_mejoras() -> void:
	if not is_instance_valid(grid_mejoras):
		return

	for child in grid_mejoras.get_children():
		child.queue_free()

	var SURFACE_COLOR := Color(0.34902, 0.388235, 0.447059, 1.0)
	var GREEN_DARK := Color(0.435294, 0.686275, 0.470588, 1.0)
	var GREEN_LIGHT := Color(0.545098, 0.796078, 0.568627, 1.0)
	var GREEN_HOVER := Color(0.631373, 0.85098, 0.65098, 1.0)
	var TEXT_COLOR := Color(0.956863, 0.964706, 0.94902, 1.0)
	var SHADOW_COLOR := Color(0.12549, 0.156863, 0.2, 0.95)

	for item in ARBOL_MEJORAS:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(280, 175)
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var ya_desbloqueado = _esta_mejora_desbloqueada(item)
		var prereq_cumplido = _esta_mejora_disponible_para_compra(item)

		var st = StyleBoxFlat.new()
		st.bg_color = SURFACE_COLOR
		if ya_desbloqueado:
			st.border_color = GREEN_DARK
		elif not prereq_cumplido:
			st.border_color = Color(0.22, 0.25, 0.30, 0.8)
		elif creditos >= item.costo:
			st.border_color = GREEN_LIGHT
		else:
			st.border_color = Color(0.30, 0.34, 0.40, 1.0)

		st.set_border_width_all(3)
		st.set_corner_radius_all(14)
		st.shadow_color = SHADOW_COLOR
		st.shadow_size = 5
		st.shadow_offset = Vector2(0, 4)
		st.content_margin_left = 14
		st.content_margin_right = 14
		st.content_margin_top = 10
		st.content_margin_bottom = 10
		panel.add_theme_stylebox_override("panel", st)

		var vbox = VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 5)

		var texto_cat = "[ MEJORA ]"
		match item.cat:
			"bloque": texto_cat = "BLOQUE DE CÓDIGO"
			"espacio": texto_cat = "TERRENO MODULAR"
			"estacion": texto_cat = "ESTACIÓN DE MONTAJE"
			"astronauta": texto_cat = "ASTRONAUTA CONCURRENTE"

		var lbl_cat = Label.new()
		lbl_cat.text = texto_cat
		lbl_cat.add_theme_color_override("font_color", GREEN_LIGHT if prereq_cumplido else Color(0.45, 0.50, 0.55))
		lbl_cat.add_theme_font_size_override("font_size", 10)
		vbox.add_child(lbl_cat)

		var lbl_tit = Label.new()
		lbl_tit.text = item.fase
		lbl_tit.add_theme_color_override("font_color", GREEN_LIGHT if ya_desbloqueado else (TEXT_COLOR if prereq_cumplido else Color(0.55, 0.60, 0.65)))
		lbl_tit.add_theme_color_override("font_outline_color", SHADOW_COLOR)
		lbl_tit.add_theme_constant_override("outline_size", 2)
		lbl_tit.add_theme_font_size_override("font_size", 13)
		vbox.add_child(lbl_tit)

		var lbl_desc = Label.new()
		lbl_desc.text = item.desc
		lbl_desc.add_theme_color_override("font_color", Color(0.80, 0.85, 0.88, 1.0) if prereq_cumplido else Color(0.50, 0.55, 0.60, 1.0))
		lbl_desc.add_theme_font_size_override("font_size", 11)
		lbl_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbl_desc.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.add_child(lbl_desc)

		var btn_accion = Button.new()
		btn_accion.custom_minimum_size = Vector2(0, 38)
		btn_accion.focus_mode = Control.FOCUS_NONE

		if ya_desbloqueado:
			btn_accion.text = "DESBLOQUEADO"
			btn_accion.disabled = true
			var st_dis = StyleBoxFlat.new()
			st_dis.bg_color = Color(0.20, 0.24, 0.28, 0.9)
			st_dis.border_color = GREEN_DARK
			st_dis.set_border_width_all(2)
			st_dis.set_corner_radius_all(10)
			st_dis.content_margin_top = 5
			st_dis.content_margin_bottom = 5
			btn_accion.add_theme_stylebox_override("disabled", st_dis)
			btn_accion.add_theme_color_override("font_disabled_color", GREEN_LIGHT)
			btn_accion.add_theme_font_size_override("font_size", 12)
		elif not prereq_cumplido:
			btn_accion.text = "BLOQUEADO // %s" % item.get("req_texto", "Misión previa")
			btn_accion.disabled = true
			var st_lock = StyleBoxFlat.new()
			st_lock.bg_color = Color(0.18, 0.20, 0.24, 0.8)
			st_lock.border_color = Color(0.25, 0.28, 0.33, 1.0)
			st_lock.set_border_width_all(1)
			st_lock.set_corner_radius_all(10)
			st_lock.content_margin_top = 5
			st_lock.content_margin_bottom = 5
			btn_accion.add_theme_stylebox_override("disabled", st_lock)
			btn_accion.add_theme_color_override("font_disabled_color", Color(0.50, 0.55, 0.60, 1.0))
			btn_accion.add_theme_font_size_override("font_size", 11)
		elif creditos >= item.costo:
			btn_accion.text = "ADQUIRIR (%d Tuercas)" % item.costo
			var st_norm = StyleBoxFlat.new()
			st_norm.bg_color = GREEN_LIGHT
			st_norm.border_color = GREEN_DARK
			st_norm.border_width_left = 3
			st_norm.border_width_top = 3
			st_norm.border_width_right = 3
			st_norm.border_width_bottom = 5
			st_norm.set_corner_radius_all(10)
			st_norm.shadow_color = SHADOW_COLOR
			st_norm.shadow_size = 2
			st_norm.shadow_offset = Vector2(0, 4)
			st_norm.content_margin_top = 4
			st_norm.content_margin_bottom = 4

			var st_hov = StyleBoxFlat.new()
			st_hov.bg_color = GREEN_HOVER
			st_hov.border_color = GREEN_DARK
			st_hov.border_width_left = 3
			st_hov.border_width_top = 3
			st_hov.border_width_right = 3
			st_hov.border_width_bottom = 5
			st_hov.set_corner_radius_all(10)
			st_hov.shadow_color = SHADOW_COLOR
			st_hov.shadow_size = 2
			st_hov.shadow_offset = Vector2(0, 5)
			st_hov.content_margin_top = 4
			st_hov.content_margin_bottom = 4

			var st_pres = StyleBoxFlat.new()
			st_pres.bg_color = GREEN_DARK
			st_pres.border_color = GREEN_DARK
			st_pres.border_width_left = 3
			st_pres.border_width_top = 3
			st_pres.border_width_right = 3
			st_pres.border_width_bottom = 2
			st_pres.set_corner_radius_all(10)
			st_pres.content_margin_top = 7
			st_pres.content_margin_bottom = 3

			btn_accion.add_theme_stylebox_override("normal", st_norm)
			btn_accion.add_theme_stylebox_override("hover", st_hov)
			btn_accion.add_theme_stylebox_override("pressed", st_pres)
			btn_accion.add_theme_color_override("font_color", TEXT_COLOR)
			btn_accion.add_theme_color_override("font_hover_color", TEXT_COLOR)
			btn_accion.add_theme_color_override("font_outline_color", SHADOW_COLOR)
			btn_accion.add_theme_constant_override("outline_size", 2)
			btn_accion.add_theme_font_size_override("font_size", 13)
			btn_accion.pressed.connect(func(): _comprar_mejora_arbol(item))
		else:
			btn_accion.text = "REQUIERE: %d Tuercas" % item.costo
			btn_accion.disabled = true
			var st_req = StyleBoxFlat.new()
			st_req.bg_color = Color(0.24, 0.27, 0.32, 0.7)
			st_req.border_color = Color(0.26, 0.30, 0.36, 1.0)
			st_req.set_border_width_all(2)
			st_req.set_corner_radius_all(10)
			st_req.content_margin_top = 5
			st_req.content_margin_bottom = 5
			btn_accion.add_theme_stylebox_override("disabled", st_req)
			btn_accion.add_theme_color_override("font_disabled_color", Color(0.65, 0.70, 0.76, 1.0))
			btn_accion.add_theme_font_size_override("font_size", 12)

		vbox.add_child(btn_accion)
		panel.add_child(vbox)
		grid_mejoras.add_child(panel)

func _comprar_mejora_arbol(item: Dictionary) -> void:
	if _esta_mejora_desbloqueada(item):
		return
	if not _esta_mejora_disponible_para_compra(item):
		_actualizar_estado("Esta mejora está bloqueada. Completa primero: %s" % item.get("req_texto", "Misión previa"))
		return
	if creditos < item.costo:
		return

	creditos -= item.costo
	actualizar_creditos_ui()

	match item.cat:
		"bloque":
			var cmd = item.get("desbloquea_comando", "")
			if not cmd.is_empty() and not bloques_adquiridos.has(cmd):
				bloques_adquiridos.append(cmd)
			_actualizar_paleta(_obtener_bloques_disponibles_actuales())
			_actualizar_estado("¡Bloque '%s' adquirido! Ya está disponible en tu paleta." % item.fase)
		"espacio":
			var nuevo_tam = item.get("tamano", 5)
			if mundo_3d:
				mundo_3d.actualizar_sector(nuevo_tam)
			_actualizar_estado("¡Terreno expandido a %dx%d casillas!" % [nuevo_tam, nuevo_tam])
		"estacion":
			if not item.id in estaciones_desbloqueadas:
				estaciones_desbloqueadas.append(item.id)
			match item.id:
				"MESA_SPIDO":
					if mundo_3d and mundo_3d.mesa_spid:
						mundo_3d.mesa_spid.posicionar_en_celda(Vector2i(2, 2))
						mundo_3d.mesa_spid.visible = true
						mundo_3d.mesa_spid.scale = Vector3.ZERO
						create_tween().tween_property(mundo_3d.mesa_spid, "scale", Vector3.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
					_actualizar_estado("¡Mesa de Ensamble Final Spido instalada en el sector de montaje!")
				"MESON_PATAS":
					if mundo_3d and mundo_3d.meson_patas:
						mundo_3d.meson_patas.visible = true
					_actualizar_estado("¡Mesa de Fabricación Inicial lista en el hangar!")
				"MAQUINA_CINTA":
					if mundo_3d and mundo_3d.maquina_cinta:
						mundo_3d.maquina_cinta.visible = true
						mundo_3d.maquina_cinta.scale = Vector3.ZERO
						create_tween().tween_property(mundo_3d.maquina_cinta, "scale", Vector3.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
					_actualizar_estado("¡Máquina de Cinta Automática instalada en la bahía!")
				"BANDEJA_INTERMEDIA":
					if mundo_3d and mundo_3d.bandeja_intermedia:
						mundo_3d.bandeja_intermedia.visible = true
						mundo_3d.bandeja_intermedia.scale = Vector3.ZERO
						create_tween().tween_property(mundo_3d.bandeja_intermedia, "scale", Vector3.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
					_actualizar_estado("¡Bandeja Intermedia de componentes instalada!")
				"COMPUERTA_ENTREGA":
					if mundo_3d and mundo_3d.compuerta_entrega:
						mundo_3d.compuerta_entrega.visible = true
						mundo_3d.compuerta_entrega.scale = Vector3.ZERO
						create_tween().tween_property(mundo_3d.compuerta_entrega, "scale", Vector3.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
					_actualizar_estado("¡Compuerta de Entrega presurizada en línea!")
				"MESON_SENSORES":
					if mundo_3d and mundo_3d.meson_sensores:
						mundo_3d.meson_sensores.visible = true
						mundo_3d.meson_sensores.scale = Vector3.ZERO
						create_tween().tween_property(mundo_3d.meson_sensores, "scale", Vector3.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
					_actualizar_estado("¡Mesón de Sensores Ópticos instalado en el hangar!")
		"hardware":
			if not item.id in mejoras_hardware_adquiridas:
				mejoras_hardware_adquiridas.append(item.id)
			match item.id:
				"MEJORA_VELOCIDAD":
					if mundo_3d:
						for a in [mundo_3d.astronauta, mundo_3d.astronauta_2, mundo_3d.astronauta_3, mundo_3d.astronauta_4, mundo_3d.astronauta_5]:
							if is_instance_valid(a):
								a.tiempo_movimiento = 0.20
								a.tiempo_giro = 0.14
					_actualizar_estado("¡Propulsores rápidos calibrados! Los astronautas se desplazan 40% más rápido.")
				"MEJORA_CINTA":
					if mundo_3d and mundo_3d.maquina_cinta:
						mundo_3d.maquina_cinta.tiempo_procesamiento = 0.5
					_actualizar_estado("¡Overclock de cinta aplicado! Tiempo de procesamiento reducido a 0.5s.")
		"astronauta":
			var a_id = item.get("astro_id", 2)
			if a_id == 4:
				for sub_id in [4, 5]:
					if not astronautas_desbloqueados.has(sub_id):
						astronautas_desbloqueados.append(sub_id)
					tabs_codigo.set_tab_hidden(sub_id - 1, false)
				if mundo_3d:
					if mundo_3d.astronauta_4:
						mundo_3d.astronauta_4.visible = true
						mundo_3d.astronauta_4.configurar_inicio(Vector2i(2, 0), 0)
					if mundo_3d.astronauta_5:
						mundo_3d.astronauta_5.visible = true
						mundo_3d.astronauta_5.configurar_inicio(Vector2i(-2, 0), 0)
				_actualizar_estado("¡Astros 4 y 5 activados para automatización a escala total!")
			else:
				if not astronautas_desbloqueados.has(a_id):
					astronautas_desbloqueados.append(a_id)
				tabs_codigo.set_tab_hidden(a_id - 1, false)
				if mundo_3d:
					var a_node = mundo_3d.astronauta_2 if a_id == 2 else mundo_3d.astronauta_3
					if a_node:
						a_node.visible = true
						var pos_i = Vector2i(0, -1) if a_id == 2 else Vector2i(2, 1)
						var ori_i = 0 if a_id == 2 else 2
						a_node.configurar_inicio(pos_i, ori_i)
						a_node.scale = Vector3.ZERO
						create_tween().tween_property(a_node, "scale", Vector3.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
				_actualizar_estado("¡Astro %d activado y listo para programar!" % a_id)

	_verificar_hitos_sandbox(false)
	_renderizar_centro_mejoras()

func _limpiar_resaltados(secuencia: Array) -> void:
	for b in secuencia:
		if is_instance_valid(b) and b is BloqueItem:
			b.resaltar_ejecucion(false)

func _limpiar_error() -> void:
	ultimo_error = ""
	if is_instance_valid(bloque_con_error):
		bloque_con_error.resaltar_error(false)
		bloque_con_error = null

func _actualizar_estado(mensaje: String) -> void:
	if is_instance_valid(label_estado):
		label_estado.visible = false
		label_estado.text = mensaje

func _bloquear_interfaz(bloquear: bool) -> void:
	btn_paso.disabled = bloquear
	btn_reiniciar.disabled = bloquear
	btn_limpiar.disabled = bloquear
	if is_instance_valid(btn_nivel_prev):
		btn_nivel_prev.disabled = bloquear or (indice_hito_actual == 0)
	if is_instance_valid(btn_nivel_next):
		btn_nivel_next.disabled = bloquear or (indice_hito_actual == hitos.size() - 1)
