class_name HitosSandbox
extends RefCounted

static func obtener_hitos() -> Array[Dictionary]:
	return [
		{
			"id": 1,
			"clave": "PRIMEROS_PASOS",
			"titulo": "1. Fase 1: Abastecedor (Tablero 3x3)",
			"descripcion": "Abastece la Mesa Inicial con materia prima. Recoge una tuerca de la Caja de Suministros y llévala a la mesa para comenzar la producción.",
			"meta_texto": "Lleva una tuerca de la Caja de Suministros a la Mesa Inicial",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 3,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "DEPOSITAR_INSUMO",
			"recompensa_creditos": 20,
			"mensaje_ada": "¡Excelente maniobra! Has entregado la primera materia prima en la Mesa de Fabricación Inicial.",
			"pista": "Orienta al astronauta hacia la caja de suministros para recoger la tuerca y luego acércala a la mesa de trabajo.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 2,
			"clave": "FRICCION_Y_REPETICION",
			"titulo": "2. Fabricación Base: Segunda Entrega (3x3)",
			"descripcion": "La forja requiere otro insumo para completar la fabricación. Realiza una segunda entrega desde la caja de suministros hasta la mesa inicial.",
			"meta_texto": "Lleva la 2ª tuerca a la Mesa Inicial para fabricar la Pieza Base",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 3,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "FABRICAR_PATAS",
			"recompensa_creditos": 25,
			"mensaje_ada": "¡Pieza base fabricada! Repetir viajes manualmente consume mucho código; revisa las mejoras de automatización en la tienda.",
			"pista": "Programa el viaje de retorno a la caja de suministros y vuelve a la mesa con la segunda tuerca.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 3,
			"clave": "BUCLE_FARMEO",
			"titulo": "3. Automatización Continua: El Bucle (3x3)",
			"descripcion": "Automatiza el ciclo de transporte para que Astro 1 mantenga la Mesa Inicial abastecida de forma continua sin tener que programar cada viaje a mano.",
			"meta_texto": "Automatiza el ciclo continuo de abastecimiento en la Mesa Inicial",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 3,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "ACTIVAR_BUCLE",
			"recompensa_creditos": 35,
			"mensaje_ada": "¡Producción continua activa! Tu línea de montaje básica ya trabaja de forma autónoma.",
			"pista": "Usa una estructura de repetición en tu algoritmo para que el trayecto entre la caja y la mesa se repita indefinidamente.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 4,
			"clave": "OPERADOR_CINTA_5X5",
			"titulo": "4. Fase 2: Operador de Cinta Automática (5x5)",
			"descripcion": "Conecta la producción con la Máquina de Cinta. Coordina a Astro 2 para retirar piezas de la mesa inicial, procesarlas en la cinta y recoger los componentes terminados por la salida.",
			"meta_texto": "Procesa componentes a través de la Cinta Automática",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 2,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"pos_astronauta_2": Vector2i(0, -1),
			"ori_astronauta_2": 0,
			"mostrar_mesa": false,
			"pos_mesa": Vector2i(2, 2),
			"mostrar_meson_patas": true,
			"tipo_meta": "PROCESAR_CINTA",
			"recompensa_creditos": 60,
			"mensaje_ada": "¡Flujo de procesamiento industrial completado! Los componentes procesados están listos para el montaje robótico.",
			"pista": "Alimenta la cinta por su tolva de entrada y recoge el componente procesado en el otro extremo.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 5,
			"clave": "ENSAMBLADOR_FINAL_7X7",
			"titulo": "5. Fase 3: Ensamblador Final en Spido (7x7)",
			"descripcion": "Inicia el ensamblaje robótico en el banco central. Coordina a Astro 3 para trasladar los componentes procesados hacia Spido hasta completar su estructura de 6 piezas.",
			"meta_texto": "Completa el ensamblaje de 6 piezas en Spido",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 3,
			"tamano_sector": 7,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"pos_astronauta_2": Vector2i(0, -1),
			"ori_astronauta_2": 0,
			"pos_astronauta_3": Vector2i(2, 1),
			"ori_astronauta_3": 2,
			"mostrar_mesa": false,
			"pos_mesa": Vector2i(2, 2),
			"mostrar_meson_patas": true,
			"tipo_meta": "ENSAMBLAR",
			"piezas_requeridas": 6,
			"recompensa_creditos": 80,
			"mensaje_ada": "¡Spido completamente ensamblado con sus 6 componentes! Ahora instala la Compuerta de Entrega para activar el despacho continuo de producción.",
			"pista": "Crea un ciclo de traslado para acoplar cada componente terminado en el banco de montaje hasta que Spido cobre vida.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 6,
			"clave": "DESPACHO_CONTINUO_COMPUERTA",
			"titulo": "6. Despacho y Ganancia Continua por Compuerta",
			"descripcion": "Activa la logística espacial de la nave. Despacha a los robots Spido terminados a través de la compuerta para establecer una línea de producción continua.",
			"meta_texto": "Despacha a Spido terminado a través de la compuerta",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR", "DIAGNOSTICO"],
			"cantidad_astronautas": 3,
			"tamano_sector": 7,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"pos_astronauta_2": Vector2i(0, -1),
			"ori_astronauta_2": 0,
			"pos_astronauta_3": Vector2i(2, 1),
			"ori_astronauta_3": 2,
			"mostrar_mesa": false,
			"pos_mesa": Vector2i(2, 2),
			"mostrar_meson_patas": true,
			"tipo_meta": "DESPACHO_COMPUERTA",
			"recompensa_creditos": 100,
			"mensaje_ada": "¡Línea de producción espacial continua completada con éxito! Cada robot despachado genera créditos automáticos.",
			"pista": "Cuando Spido esté completamente activo en la mesa, aproxímate a la compuerta para autorizar su despegue.",
			"piezas": []
		}
	]
